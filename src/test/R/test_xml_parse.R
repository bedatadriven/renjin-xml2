
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

}

test.xml_name <- function() {

  xml <- "<p>Hello world!</p>"
  doc <- read_xml(xml)

  # An 'xml_document' object is represented by its root node:
  assertThat( xml_name(doc), identicalTo("p") )

}