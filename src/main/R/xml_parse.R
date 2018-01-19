
# 'read_xml' should do something similar to xml2::read_xml on CRAN
read_xml <- function(x, encoding = "", ..., as_html = FALSE, options = "NOBLANKS") {
  UseMethod("read_xml", x)
}

read_xml.character <- function(x, encoding = "", ..., as_html = FALSE, options = "NOBLANKS") {
    if (as_html) {
        read_html(x, encoding = encoding, ..., options = options)
    } else {
        XmlDocumentParser$parse(x, "DTDVALID" %in% options, "NOBLANKS" %in% options)
    }
}

read_xml.default <- function(x, encoding = "", ..., as_html = FALSE, options = "NOBLANKS") {
  stop("no method for object of class ", class(x))
}

read_html <- function(x, encoding = "", ..., options = c("RECOVER", "NOERROR", "NOBLANKS")) {
  UseMethod("read_html")
}

read_html.character <- function(x, encoding = "", ..., options = c("RECOVER", "NOERROR", "NOBLANKS")) {
  XmlDocumentParser$parse_html(x, "NOBLANKS" %in% options)
}

read_html.default <- function(x, encoding = "", ..., options = c("RECOVER", "NOERROR", "NOBLANKS")) {
  stop("no method for object of class ", class(x))
}

read_html.response <- function(x, encoding = "", options = c("RECOVER",
    "NOERROR", "NOBLANKS"), ...) {

  options <- parse_options(options, xml_parse_options())
  content <- httr::content(x, as = "raw")
  xml2::read_html(content, encoding = encoding, options = options, ...)
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