
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

test.xml_parent <- function() {

    doc <- read_xml('<foo><bar>Hello world!</bar><oof></oof></foo>')

    children <- xml_children(doc)

    # We need to use a special function to compare two nodes as R's identical() will return FALSE:
    is.same <- org.maartenjan.xml2:::identical_nodes

    assertTrue( is.same(xml_parent(children[[1]]), doc) )

    # The root has a parent namely the document itself, but the document does not have a parent:
    assertThat( xml_parent(xml_parent(doc)), throwsError() )

}

test.xml_root <- function() {

    doc <- read_xml('<foo><bar>Hello world!</bar></foo>')

    children <- xml_children(doc)

    assertThat( xml_root(children), instanceOf("xml_document") )

    # We need to use a special function to compare two nodes as R's identical() will return FALSE:
    is.same <- org.maartenjan.xml2:::identical_nodes

    assertTrue( is.same(xml_root(children), doc) )

}

test.xml_siblings <- function() {
    doc <- read_xml('<foo><bar>hello</bar><oof>world</oof>!</foo>')

    # There is only one root element:
    assertThat( length(xml_siblings(doc)), equalTo(0) )

    children <- xml_children(doc)
    bar <- children[[1]]
    oof <- children[[2]]

    assertThat( xml_siblings(bar), instanceOf("xml_nodeset") )
    assertThat( length(xml_siblings(bar)), equalTo(1) )
    assertThat( xml_name(xml_siblings(bar)[[1]]), identicalTo("oof") )
    assertThat( xml_name(xml_siblings(oof)[[1]]), identicalTo("bar"))

    # Test for preservation of order:
    doc <- read_xml('<foo><bar>hello</bar><oof>world</oof><rab>!</rab></foo>')
    children <- xml_children(doc)

    assertThat( xml_name(xml_siblings(children[[1]])), identicalTo(c("oof", "rab")) )
    assertThat( xml_name(xml_siblings(children[[2]])), identicalTo(c("bar", "rab")) )
    assertThat( xml_name(xml_siblings(children[[3]])), identicalTo(c("bar", "oof")) )

}


test.xml_add_child <- function() {

    doc <- read_xml('<foo/>')

    xml_add_child(doc, 'error', type = 'catastrophic', message = "No more foos in the bar.")

    children <- xml_children(doc)
    child <- children[[1]]
    attrs <- xml_attrs(child)

    assertThat(length(children), identicalTo(1L))
    assertThat(xml_name(child), identicalTo("error"))
    assertThat(attrs[['type']], identicalTo('catastrophic'))
    assertThat(attrs[['message']], identicalTo('No more foos in the bar.'))

}