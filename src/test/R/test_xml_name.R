
library(hamcrest)
library(xml2)

test.xml_name <- function() {

    xml <- "<p>Hello world!</p>"
    doc <- read_xml(xml)

    # An 'xml_document' object is represented by its root node:
    assertThat( xml_name(doc), identicalTo("p") )

    xml <- "<foo><!-- comment node -->Some text.<![CDATA[ unparsed character data ]]></foo>"
    doc <- read_xml(xml)
    contents <- xml_contents(doc)

    assertThat( xml_name(contents[[1]]), identicalTo("comment") )
    assertThat( xml_name(contents[[2]]), identicalTo("text") )
    assertThat( xml_name(contents[[3]]), identicalTo("") )

}
