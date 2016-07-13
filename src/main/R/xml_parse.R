
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
