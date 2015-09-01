require "fileutils"
require "asciidoctor"

$rootDir = File.expand_path(File.dirname(File.dirname(__FILE__)))

def process(which)
    print "Processing " + which + ":\n"

    print "  - Complete HTML... "
    adoc = Asciidoctor.convert_file $rootDir + "/" + which + ".adoc", :to_file => false, :header_footer => true, :safe => Asciidoctor::SafeMode::UNSAFE, :attributes => {"numbered" => true}
    adoc.gsub!('src="//www.youtube.com/', 'src="https://www.youtube.com/')
    f = File.open($rootDir + "/output/" + which + ".html", "wb")
    f.write(adoc)
    f.close
    print "done.\n"

    print "  - Generating DocBook... "
    docbook = Asciidoctor.convert_file $rootDir + "/" + which + ".adoc", :to_file => false, :header_footer => true, :safe => Asciidoctor::SafeMode::UNSAFE, :backend => "docbook", :attributes => {"numbered" => true}
    f = File.open($rootDir + "/tmp/" + which + "-docbook.xml", "wb")
    f.write(docbook)
    f.close
    print "done.\n"

    print "  - Generating chunked html... "
    Dir.mkdir($rootDir + "/output/" + which) unless Dir.exists?($rootDir + "/output/" + which)
    if system("xsltproc --output " + $rootDir + "/output/" + which + "/index.html " + $rootDir + "/lib/html-chunked-parameters.xsl " + $rootDir + "/tmp/" + which + "-docbook.xml") == false
    	raise "xsltproc failed!"
    end
    print "done.\n"
end

$stdout.sync = true

FileUtils.rm_rf($rootDir + "/tmp")
Dir.mkdir($rootDir + "/tmp")
Dir.mkdir($rootDir + "/output") unless Dir.exists?($rootDir + "/output")

process "developers"
# process "editors"
