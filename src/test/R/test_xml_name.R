
library(hamcrest)
library(org.maartenjan.xml2)

test.xml_name <- function() {

    xml <- "<p>Hello world!</p>"
    doc <- read_xml(xml)

    # An 'xml_document' object is represented by its root node:
    assertThat( xml_name(doc), identicalTo("p") )

}
