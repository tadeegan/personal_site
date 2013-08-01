require 'yaml'
files = YAML.load_file('pages.yml')["pages"]
puts files.inspect
header_txt = File.readlines("header.html")
files.each do |file|
    lines = File.readlines(file)
    in_header = false;
    puts "in #{file}"
    File.open(file, "w") do |f|
        lines.each { |line|
            if line.include? "<!--HEADER_START-->"
                in_header = true;
                f.puts line
                f.puts header_txt
                next;
            end
            if line.include? "<!--HEADER_END-->"
                in_header = false;
                f.puts line
                next;
            end
            f.puts line unless in_header}
    end
end
