


xml_text <- function (x, trim = FALSE) {
    UseMethod("xml_text")
}


xml_text.xml_node <- function (x, trim = FALSE) {
    res <- XmlDocumentParser$xml_text(x$node)
    if (isTRUE(trim)) {
        res <- sub("^[[:space:] ]+", "", res)
        res <- sub("[[:space:] ]+$", "", res)
    }
    res
}

xml_text.xml_missing <- function(x, trim = FALSE) {
    NA_character_
}


`xml_text<-` <- function (x, value) {
    UseMethod("xml_text<-")
}

`xml_text<-.xml_node` <- function (x, value) {
    XmlDocumentParser$set_xml_text(x$node, value)
    x
}
