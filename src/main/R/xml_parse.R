
# 'read_xml' should do something similar to xml2::read_xml on CRAN
read_xml <- function(x, ...) {
  UseMethod("read_xml", x)
}

read_xml.character <- function(x, options = "NOBLANKS") {
  XmlDocumentParser$parse(x, "DTDVALID" %in% options, "NOBLANKS" %in% options)
}

read_xml.default <- function(x, ...) {
  stop("no method for object of class ", class(x))
}

# non-exported function to test if the R code can access private methods in the Java class:
xml_node <- function(x) {
  XmlDocumentParser$xml_node(x)
}

# non-exported function to check if two nodes are the same:
identical_nodes <- function(x, y) {
  stopifnot(inherits(x, "xml_node"))
  stopifnot(inherits(y, "xml_node"))
  XmlDocumentParser$identical_nodes(x$node, y$node)
}