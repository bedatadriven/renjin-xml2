
xml_attrs <- function(x, ...) {
  UseMethod("xml_attrs", x)
}

xml_attrs.xml_node <- function(x, ...) {
  XmlDocumentParser$xml_attrs(x$node)
}
