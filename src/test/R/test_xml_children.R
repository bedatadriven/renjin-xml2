
library(hamcrest)
library(org.maartenjan.xml2)

test.xml_children <- function() {

    doc <- read_xml("<html><head><title>Hello world</title></head><body><p>My text.</p></body></html>")

    assertThat( xml_children(doc), instanceOf("xml_nodeset") )
    assertThat( length(xml_children(doc)), equalTo(2) )
    assertThat( xml_children(doc)[[1]], instanceOf("xml_node") )

    assertThat( length(xml_children(read_xml("<p>foobar</p>"))), equalTo(0) )

    assertThat( length(xml_children(read_xml("<html><p>foobar</p><!-- comment --></html>"))), equalTo(1) )

}

test.xml_contents <- function() {

    doc <- read_xml("<html><p>foobar</p><!-- comment --></html>")

    assertThat( length(xml_contents(doc)), equalTo(2) )

}
