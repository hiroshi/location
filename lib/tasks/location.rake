desc "import cities from worldcitiespop.txt.gz. FILE=path/to/file"
task :worldcities => :environment do
  require "zlib"
  require "csv"
  path = "db/worldcitiespop.txt.gz"

  begin
    reader = Zlib::GzipReader.open(path) do |reader|
      puts reader.readline # dispose the header line
      #csv = CSV::IOReader.new(reader)
      conn = City.connection
      reader.each do |line|
        begin
          country, city, accentcity, region, population, latitude, longitude = CSV.parse_line(line)
          conn.insert("INSERT INTO cities (country_code, name, region_code, latitude, longitude) VALUES (\"#{country}\", \"#{city}\", \"#{region}\", \"#{latitude}\", \"#{longitude}\")")
        rescue CSV::IllegalFormatError => e
          puts e.message
          puts line
        rescue SQLite3::SQLException => e # add your adapter's exception
          puts e.message
        end
      end
    end
  rescue Errno::ENOENT => e
    puts e.message
    puts "You may found one at http://www.maxmind.com/app/worldcities."
    puts "  (cd db; wget http://www.maxmind.com/download/worldcities/worldcitiespop.txt.gz)"
  end
end
