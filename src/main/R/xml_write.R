

write_xml <- function (x, file, ...)  {
  UseMethod("write_xml")
}

write_xml.xml_document <- function (x, file, ..., options = "format", encoding = "UTF-8")  {

  if(!identical(encoding, "UTF-8")) {
    stop("Only UTF-8 encoding supported.")
  }

  if(inherits(file, 'connection')) {
    conn <- file
  } else {
    conn <- file(file)
    on.exit(close(conn))
  }

  XmlDocumentParser$xml_write_doc(x$doc, conn)
}
