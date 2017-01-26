
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


xml_siblings <- function(x) {
  XmlDocumentParser$xml_siblings(x$node)
}

xml_root <- function(x) {
  stopifnot(inherits(x, c("xml_node", "xml_document", "xml_nodeset")))

  if (inherits(x, "xml_nodeset")) {
    if (length(x) == 0) {
      return(NULL)
    } else {
      return(xml_root(x[[1]]))
    }
  }

  XmlDocumentParser$xml_root(x$doc)

}

xml_add_child <- function(.x, .value, ...,where = length(xml_children(.x)), .copy = TRUE) {
  UseMethod("xml_add_child")
}

xml_add_child.xml_node <- function (.x, .value, ..., .where = length(xml_children(.x)),
                              .copy = inherits(.value, "xml_node")) {


  node <- XmlDocumentParser$xml_add_child(.x$node, .value, list(...), .where)

  invisible(node)
}