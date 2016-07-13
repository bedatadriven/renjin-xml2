
xml_name <- function(x, ...) {
    UseMethod("xml_name", x)
}

xml_name.xml_node <- function(x, ...) {
    XmlDocumentParser$node_name(x$node)
}
