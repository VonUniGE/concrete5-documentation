<?xml version='1.0'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:import href="docbook-xsl/html/chunk.xsl" />
  <xsl:import href="docbook-xsl/html/highlight.xsl" />
  <!-- See http://docbook.sourceforge.net/release/xsl/1.78.1/doc/html/index.html -->
  <xsl:param name="chunker.output.encoding" select="'UTF-8'" />
  <xsl:param name="generate.css.header" select="1" />
  <xsl:param name="custom.css.source" select="'./../lib/html-chunked-css.xml'" />
  <xsl:param name="highlight.source" select="1" />
  <xsl:param name="generate.toc" select="'
appendix          nop
article           nop
book              toc
chapter           toc
part              nop
preface           nop
qandadiv          nop
qandaset          nop
reference         nop
sect1             toc
sect2             toc
sect3             toc
sect4             toc
sect5             toc
section           toc
set               nop
  '" />
</xsl:stylesheet>
