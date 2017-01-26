
xml_attrs <- function(x, ...) {
  UseMethod("xml_attrs", x)
}

xml_attrs.xml_node <- function(x, ...) {
  XmlDocumentParser$xml_attrs(x$node)
}

xml_attr <- function (x, attr, ns = character(), default = NA_character_) {
    UseMethod("xml_attr")
}

xml_attr.xml_node <- function (x, attr, ns = character(), default = NA_character_) {
    XmlDocumentParser$xml_attr(x$node, attr, default)
}



`xml_attr<-` <- function (x, attr, ns = character(), value)  {
  UseMethod("xml_attr<-")
}

`xml_attr<-.xml_node` <- function (x, attr, ns = character(), value) {
  XmlDocumentParser$set_xml_attr(x$node, attr, value)
  x
}


