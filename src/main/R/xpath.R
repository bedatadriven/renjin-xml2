

missing_node <- structure(list(), class = "xml_missing")

xml_missing <- function() missing_node

xml_find_all <- function (x, xpath, ns = xml_ns(x)) {
    UseMethod("xml_find_all")
}

xml_find_all.xml_node <- function (x, xpath, ns = xml_ns(x)) {
    XmlDocumentParser$xpath_search(x$node, xpath)
}

xml_find_all.xml_missing <- function (x, xpath, ns = xml_ns(x)) {
    xml_missing
}

xml_find_first <- function(x, xpath, ns = xml_ns(x)) {
    UseMethod("xml_find_first")
}

xml_find_first.default <- function(x, xpath, ns = xml_ns(x)) {
    ns <- xml_find_all(x, xpath, ns)
    if(length(ns) == 0) {
        missing_node
    } else {
        ns[[1]]
    }
}

