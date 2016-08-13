
# returns an object of class 'xml_nodeset' which is a list of XML nodes:
xml_children <- function(x) {
  XmlDocumentParser$xml_children(x$node)
}

xml_contents <- function(x) {
  XmlDocumentParser$xml_contents(x$node)
}


xml_parent <- function(x) {
  UseMethod("xml_parent")
}

xml_parent.xml_node <- function(x) {
  XmlDocumentParser$xml_parent(x$node)
}
