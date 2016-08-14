
xml_name <- function(x, ...) {
    UseMethod("xml_name", x)
}

xml_name.xml_node <- function(x, ...) {
    XmlDocumentParser$node_name(x$node)
}

xml_name.xml_nodeset <- function(x, ...) {
    vapply(x, xml_name, character(1))
}
