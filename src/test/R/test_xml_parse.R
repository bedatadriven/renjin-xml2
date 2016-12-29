
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
  # No error should occur if we consider the string to contain HTML:
  assertThat( read_xml(xml, as_html = TRUE), instanceOf("xml_document") )

# Test that validation fails for an XML document without a DTD:
  xml <- '<foo><bar>foobar</bar></foo>'
  assertThat( read_xml(xml, options = "DTDVALID"), throwsError() )

  # A valid XML document should pass the validity check and result in an xml_document:
  xml <- '<?xml version="1.0"?><!DOCTYPE foo [ <!ELEMENT foo (#PCDATA)> ]><foo>Hello world!</foo>'
  assertThat( read_xml(xml, options = "DTDVALID"), instanceOf("xml_document") )

}

test.read_html <- function() {

  # HTML is not XML so read_html() shouldn't choke on unclosed tags:
  html <- '<html><head><title>Hi</title></head><body><p>First <i>paragraph</p></body></html>'
  assertThat( read_html(html), instanceOf("xml_document") )

}

test.xml_node <- function() {

  doc <- read_xml("<p>foobar</p>")
  root <- doc$node

  # private methods should not be visible to the R code:
  assertThat( org.maartenjan.xml2:::xml_node(root), throwsError() )

}