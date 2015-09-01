require "fileutils"
require "asciidoctor"

$rootDir = File.expand_path(File.dirname(File.dirname(__FILE__)))


def process(which)
  print "Processing " + which + ":\n"

  print "  - Complete HTML... "
  adoc = Asciidoctor.convert_file($rootDir + "/" + which + ".adoc", :to_file => false, :header_footer => true, :safe => Asciidoctor::SafeMode::UNSAFE, :attributes => {"numbered" => true})
  adoc.gsub!('src="//www.youtube.com/', 'src="https://www.youtube.com/')
  f = File.open($rootDir + "/output/" + which + ".html", "wb")
  f.write(adoc)
  f.close
  print "done.\n"

  print "  - Preparing files for DocBook... "
  FileUtils.rm_rf($rootDir + "/tmp/adoc")
  Dir.mkdir($rootDir + "/tmp/adoc")
  FileUtils.cp($rootDir + "/" + which + ".adoc", $rootDir + "/tmp/adoc/" + which + ".adoc")
  for step in 1..2
    Dir.glob($rootDir + "/" + which + "/**/*").each do |fromPath|
      toPath = fromPath.gsub($rootDir + "/" + which, $rootDir + "/tmp/adoc/" + which)
      if File.directory?(fromPath)
        if step == 1
          FileUtils.mkdir_p(toPath) unless Dir.exists?(toPath)
        end
      else
        if step == 2
          if /\.adoc$/ =~ toPath
            relPathAdoc = fromPath.gsub($rootDir + "/" + which + "/", "")
            relPathHtml = relPathAdoc.gsub(/\.adoc$/, '.html')
            f = File.open(fromPath, "rb")
            contents = f.read
            f.close
            contents.gsub!(/^(= .*?\n)/, "\\1++++\n<?dbhtml filename=\"" + relPathHtml + "\"?>\n++++\n\n++++\n<simpara role=\"c5-edit-this-page\"><link xlink:href=\"https://github.com/concrete5/concrete5-documentation/tree/master/" + which + "/" + relPathAdoc + "\">Edit on GitHub</link></simpara>\n++++\n\n")
            
            f = File.open(toPath, "wb")
            f.write(contents)
            f.close
          else
            FileUtils.cp(fromPath, toPath)
          end
        end
      end
    end
  end
  print "done.\n"

  print "  - Generating DocBook... "
  docbook = Asciidoctor.convert_file($rootDir + "/tmp/adoc/" + which + ".adoc", :to_file => false, :header_footer => true, :safe => Asciidoctor::SafeMode::UNSAFE, :backend => "docbook", :attributes => {"numbered" => true})
  f = File.open($rootDir + "/tmp/" + which + "-docbook.xml", "wb")
  f.write(docbook)
  f.close
  print "done.\n"

  print "  - Generating chunked html... "
  FileUtils.rm_rf($rootDir + "/output/" + which)
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

process("developers")
# process("editors")
