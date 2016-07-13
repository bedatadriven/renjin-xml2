
# 'read_xml' should do something similar to xml2::read_xml on CRAN
read_xml <- function(x, ...) {
  UseMethod("read_xml", x)
}

read_xml.character <- function(x, ...) {
  XmlDocumentParser$parse(x)
}

read_xml.default <- function(x, ...) {
  stop("no method for object of class ", class(x))
}

print.xml_document <- function(x) {
  cat("{xml_document}\n")
  cat(XmlDocumentParser$node_format(x$node), "\n")
}

xml_name <- function(x, ...) {
  node_name(x, ...)
}

node_name <- function(x, ...) {
  XmlDocumentParser$node_name(x$node)
}

as.character.xml_node <- function(x, ...) {
  XmlDocumentParser$node_format(x$node)
}

print.xml_node <- function(x) {
  cat("{xml_node}\n")
  cat(XmlDocumentParser$node_format(x$node), "\n")
}