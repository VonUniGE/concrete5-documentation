require "asciidoctor"

def process(which)
    adoc = Asciidoctor.convert_file "../" + which + ".adoc", :to_file => false, :header_footer => true, :safe => Asciidoctor::SafeMode::UNSAFE, :attributes => {"numbered" => true}
    Dir.mkdir("../html") unless Dir.exists?("../html")
    f = File.open("../html/" + which + ".html", "wb")
    f.write(adoc)
    f.close 
end

process "developers"
process "editors"
