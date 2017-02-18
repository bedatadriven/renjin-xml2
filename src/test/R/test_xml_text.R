

library(hamcrest)
library(xml2)

test.from_elements <- function() {
    x <- read_xml("<p>This is some text. This is <b>bold!</b></p>")

    assertThat(xml_text(x), equalTo("This is some text. This is bold!"))
}

test.update_text <- function() {


    doc <- xml_new_document()
    root  <- xml_add_child(doc, 'foo')
    xml_text(root) <- 'bar'

    assertThat(xml_text(root), equalTo("bar"))

    assertThat(as.character(doc), identicalTo(paste0(
        '<?xml version="1.0" encoding="UTF-8"?>\n',
        '<foo>bar</foo>\n')))

}