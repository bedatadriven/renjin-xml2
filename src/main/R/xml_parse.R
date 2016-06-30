
# 'read_xml' should do something similar to xml2::read_xml on CRAN
read_xml <- function(x, ...) {
  UseMethod("read_xml", x)
}

read_xml.character <- function(x, ...) {
  doc <- XmlDocumentParser$parse(x) # Java class is 'Document'
  root <- doc_root(doc)
  structure(list(node = root, doc = doc), class = c("xml_document", "xml_node"))
}

read_xml.default <- function(x, ...) {
  stop("no method for object of class ", class(x))
}

print.xml_document <- function(x) {
  cat("{xml_document}\n")
  cat("<", xml_name(x), ">\n", sep = "")
}

doc_root <- function(doc) {
  XmlDocumentParser$doc_root(doc) # Java class is 'Element'
}

xml_name <- function(x, ...) {
  node_name(x, ...)
}

node_name <- function(x, ...) {
  XmlDocumentParser$node_name(x$node)
}