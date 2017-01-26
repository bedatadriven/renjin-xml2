
print.xml_node <- function(x) {
    cat("{xml_node}\n")
    cat(XmlDocumentParser$node_format(x$node), "\n")
}

as.character.xml_node <- function(x, ...) {
    XmlDocumentParser$xml_write_character(x$node)
}

as.character.xml_document <- function(x, ...) {
    XmlDocumentParser$xml_write_character(x$doc)
}

print.xml_document <- function(x) {
    cat("{xml_document}\n")
    cat(XmlDocumentParser$node_format(x$node), "\n")
}

print.xml_nodeset <- function(x, width = getOption("width"), max_n = 20, ...) {

    n <- length(x)
    cat("{xml_nodeset (", n, ")}\n", sep = "")

    x <- x[seq_len(min(n, max_n))]

    for (i in seq_along(x)) {
        cat("[", i, "] ", XmlDocumentParser$node_format(x[[i]]$node), "\n", sep = "")
    }

    if (n > max_n) cat("...\n")
}
