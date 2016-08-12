
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

print.xml_nodeset <- function(x) {
    cat("{xml_nodeset (", length(x), ")}\n", sep = "")
    for (i in seq_along(x)) {
        cat("[", i, "] ", XmlDocumentParser$node_format(x[[i]]$node), "\n", sep = "")
    }
}
