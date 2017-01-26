

library(hamcrest)
library(org.maartenjan.xml2)

test.new.doc <- function() {

    doc <- xml_new_document()
    root  <- xml_add_child(doc, 'testsuites', count = "45")

    assertTrue(inherits(doc, 'xml_document'))

    assertThat(as.character(doc), identicalTo(paste0(
        '<?xml version="1.0" encoding="UTF-8"?>\n',
        '<testsuites count="45"/>\n')))

}

test.write_doc <- function() {

    doc <- xml_new_document()
    root  <- xml_add_child(doc, 'testsuites', count = "45")

    f <- tempfile()
    write_xml(doc, f)

    xml <- readLines(f)
    cat(xml, sep="\n")
}


