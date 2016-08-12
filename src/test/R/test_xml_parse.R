
library(hamcrest)
library(org.maartenjan.xml2)

test.read_xml <- function() {

  xml <- "<p>Hello world!</p>"

  # A somewhat lame test:
  assertThat( read_xml(xml), instanceOf("xml_document") )
  assertThat( names(read_xml(xml)), identicalTo(c("node", "doc")) )

  # An XML document must have a single node at the root:
  xml <- "<h1>Malformed XML</h1><p>Hello world!</p>"
  assertThat( read_xml(xml), throwsError() )

  # Test that validation fails for an XML document without a DTD:
  xml <- '<foo><bar>foobar</bar></foo>'
  assertThat( read_xml(xml, options = "DTDVALID"), throwsError() )

  # A valid XML document should pass the validity check and result in an xml_document:
  xml <- '<?xml version="1.0"?><!DOCTYPE foo [ <!ELEMENT foo (#PCDATA)> ]><foo>Hello world!</foo>'
  assertThat( read_xml(xml, options = "DTDVALID"), instanceOf("xml_document") )

}

test.xml_node <- function() {

  doc <- read_xml("<p>foobar</p>")
  root <- doc$node

  # private methods should not be visible to the R code:
  assertThat( org.maartenjan.xml2:::xml_node(root), throwsError() )

}