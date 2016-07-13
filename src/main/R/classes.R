
print.xml_node <- function(x) {
    cat("{xml_node}\n")
    cat(XmlDocumentParser$node_format(x$node), "\n")
}

as.character.xml_node <- function(x, ...) {
    XmlDocumentParser$node_format(x$node)
}

print.xml_document <- function(x) {
    cat("{xml_document}\n")
    cat(XmlDocumentParser$node_format(x$node), "\n")
}
