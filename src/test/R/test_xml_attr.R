
library(hamcrest)
library(org.maartenjan.xml2)

test.xml_attrs <- function() {

    xml <- '<foo class="bar" id="123"></foo>'
    doc <- read_xml(xml)

    # Attributes are returned as a named character vector:
    assertThat( xml_attrs(doc), identicalTo(c(class="bar", id="123")) )
    # No attributes should result in an empty named character vector:
    assertThat(
        xml_attrs(read_xml("<p>Hello world!</p>")),
        identicalTo(structure(character(0), .Names = character(0)))
    )

}