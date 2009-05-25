namespace :location do
  desc "import cities from worldcitiespop.txt.gz. FILE=path/to/file"
  task :cities => :environment do
    require "zlib"
    require "csv"
    require "iconv"
    path = "db/worldcitiespop.txt.gz"

    begin
      reader = Zlib::GzipReader.open(path) do |reader|
        puts reader.readline # dispose the header line
        #csv = CSV::IOReader.new(reader)
        conn = City.connection
        columns = "(country_code, name, region_code, latitude, longitude, fulltext_keywords)"

        until reader.eof? do
          # NOTE: Bulk insert of 20 items is almost 16x firster than single insert
          values_list = (0..20).map{ reader.gets}.compact.map do |line|
            begin
              country, city, accentcity, region, population, latitude, longitude = CSV.parse_line(line).map do |e|
                Iconv.conv("UTF-8", "ISO-8859-1", e.gsub(/'/,"''"))
              end
            rescue CSV::IllegalFormatError => e
              puts e.message
              puts line
            end
            # "Tokyo" -> "to ok ky yo tok oky kyo toky okyo tokyo"
            unless city.blank?
              fulltext_keywords = city.gsub(/''/,"'").split(/[-\s]+/).map do |w|
                ws = w.split(//)
                (2 .. ws.length).map do |l|
                  (0 .. (ws.length - l)).map do |i|
                    # w[i,l]
                    ws[i,l].join
                  end.join(" ")
                end.join(" ")
              end.join(" ").gsub(/'/,"''")
            end

            "('#{country}', '#{city}', '#{region}', #{latitude || 'NULL'}, #{longitude || 'NULL'}, '#{fulltext_keywords}')"
          end

          begin
            # Try bulk insert
            conn.execute("INSERT INTO cities #{columns} VALUES #{values_list.join(", ")}")
            # rescue SQLite3::SQLException => e # add your adapter's exception # NOTE: 
          rescue => e # add your adapter's exception
            # if failed insert indivisualy
            values_list.each do |values|
              begin
                conn.execute("INSERT INTO cities #{columns} VALUES #{values}")
              rescue => e
                puts e.message
              end
            end
          end
        end
      end
    rescue Errno::ENOENT => e
      puts e.message
      puts "You may found one at http://www.maxmind.com/app/worldcities."
      puts "  (cd db; wget http://www.maxmind.com/download/worldcities/worldcitiespop.txt.gz)"
    end
  end

  desc "import countries from db/iso3166-1.csv"
  task :countries => :environment do
    require "csv"
    conn = Country.connection
    CSV.open("db/iso3166-1.csv", "r") do |row|
      country_code, name = row.map{|e|e.gsub(/'/,"''")}
      conn.insert("INSERT INTO countries (country_code, name) VALUES ('#{country_code.downcase}', '#{name}')")
    end
  end

  desc "import regions from db/iso3166-2.csv and db/fips10-4.csv"
  task :regions => :environment do
    require "csv"
    conn = Region.connection
    def conn.insert_region(row)
      country_code, region_code, name = row.map{|e|e.gsub(/'/,"''")}
      self.insert("INSERT INTO regions (country_code, region_code, name) VALUES ('#{country_code.downcase}', '#{region_code.downcase}', '#{name}')")
    end

    CSV.open("db/iso3166-2.csv", "r") do |row|
      conn.insert_region(row)
    end
    CSV.open("db/fips10-4.csv", "r") do |row|
      conn.insert_region(row)
    end
  end
end
