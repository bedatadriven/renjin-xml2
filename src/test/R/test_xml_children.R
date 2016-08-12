
library(hamcrest)
library(org.maartenjan.xml2)

test.xml_children <- function() {

    doc <- read_xml("<html><head><title>Hello world</title></head><body><p>My text.</p></body></html>")

    assertThat( xml_children(doc), instanceOf("xml_nodeset") )
    assertThat( length(xml_children(doc)), equalTo(2) )
    assertThat( xml_children(doc)[[1]], instanceOf("xml_node") )

    assertThat(
        xml_children(read_xml("<p>foobar</p>")),
        identicalTo(structure(list(), class = "xml_nodeset"))
    )

    assertThat( length(xml_children(read_xml("<html><p>foobar</p><!-- comment --></html>"))), equalTo(1) )

}

test.xml_contents <- function() {

    doc <- read_xml("<html><p>foobar</p><!-- comment --></html>")

    assertThat( length(xml_contents(doc)), equalTo(2) )

    # Test removal of blank (text) nodes.
    # The following XML document has a root 'foo' with two child nodes:
    # (1) an empty text node (i.e. a whitespace) and
    # (2) a 'bar' element
    xml <- '<?xml version="1.0"?><!DOCTYPE foo [ <!ELEMENT foo (bar)><!ELEMENT bar (#PCDATA)> ]><foo> <bar></bar></foo>'

    # Default option "NOBLANKS" removed:
    doc <- read_xml(xml, options = "")
    assertThat( length(xml_contents(doc)), equalTo(2) )

    # Blank text nodes are removed even without the "DTDVALID" options if the XML document has a DTD:
    doc <- read_xml(xml, options = "NOBLANKS")
    assertThat( length(xml_contents(doc)), equalTo(1) )

    doc <- read_xml(xml, options = c("DTDVALID", "NOBLANKS"))
    assertThat( length(xml_contents(doc)), equalTo(1) )

    # If the document has no DTD, then blank text nodes are not removed, even with the "NOBLANKS" option:
    xml <- '<foo> <bar></bar></foo>'
    doc <- read_xml(xml, options = "NOBLANKS")
    assertThat( length(xml_contents(doc)), equalTo(2) )

}
