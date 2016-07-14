
# returns an object of class 'xml_nodeset' which is a list of XML nodes:
xml_children <- function(x) {
  XmlDocumentParser$xml_children(x$node)
}

xml_contents <- function(x) {
  XmlDocumentParser$xml_contents(x$node)
}
