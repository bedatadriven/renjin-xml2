
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

    assertThat(xml_attr(doc, 'class'), identicalTo('bar'))
    assertThat(xml_attr(doc, 'id'), identicalTo('123'))
    assertThat(xml_attr(doc, 'baz'), identicalTo(NA_character_))



}


test.xml_attr <- function() {


    xml <- '<foo/>'

    doc <- read_xml(xml)
    xml_attr(doc, 'foo') <- 'bar'
    xml_attr(doc, 'baz') <- 'inga'

    attrs <- xml_attrs(doc)

    assertThat( attrs['foo'], identicalTo(c(foo='bar')))
    assertThat( attrs['baz'], identicalTo(c(baz='inga')))


}