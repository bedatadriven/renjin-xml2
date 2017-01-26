

xml_new_document <- function(version="1.0", encoding = "UTF-8") {
    doc <- XmlDocumentParser$xml_new_document(version, encoding)
    structure(list(doc = doc), class = "xml_document")
}

xml_add_child.xml_document <- function (.x, .value, ..., .where = length(xml_children(.x)),
                                  .copy = inherits(.value, "xml_node"))  {
  if (inherits(.x, "xml_node")) {
      NextMethod("xml_add_child")
  }
  else {
    invisible(XmlDocumentParser$xml_set_root_or_add(.x$doc, .value, list(...)))

  }
}
