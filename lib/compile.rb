require "asciidoctor"

def process(which)
    adoc = Asciidoctor.convert_file "../" + which + ".adoc", :to_file => false, :header_footer => true, :safe => Asciidoctor::SafeMode::UNSAFE, :attributes => {"numbered" => true}
    adoc.gsub!('src="//www.youtube.com/', 'src="https://www.youtube.com/')
    f = File.open("../output/" + which + ".html", "wb")
    f.write(adoc)
    f.close 
end

Dir.mkdir("../output") unless Dir.exists?("../output")

process "developers"
# process "editors"
