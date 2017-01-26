[![Build Status](http://build.renjin.org/job/Replacement-Packages/job/xml2/badge/icon)](http://build.renjin.org/job/Replacement-Packages/job/xml2/) [![Build Status](https://travis-ci.org/bedatadriven/renjin-xml2.svg?branch=master)](https://travis-ci.org/bedatadriven/renjin-xml2)

# renjin-xml2

A drop-in replacement for the [xml2](https://github.com/hadley/xml2) package in Renjin. Note that this replacement 
package is currently by no means fully functional. Check the [NAMESPACE](NAMESPACE) file to get an impression of which 
functions are available. In the remainder of this README, the term *xml2* refers to the original R package authored by 
Wickham *et al*.

## Some technical details

### S3 classes

The *xml2* package uses S3 classes to represent an XML document and its nodes: `xml_document` and `xml_node`. There is a 
third class `xml_nodeset` to represent a list of nodes.

Objects of class `xml_document` inherit from `xml_node` therefore objects from these two classes have almost the same 
structure: both are a list with two named elements: `node` and `doc`. An XML document is essentially represented by the 
root node. The `node` element will be the pointer to the node and the `doc` element will be a pointer to the document. 
The latter is a way to keep track of the document which 'owns' the node, but Java allows you to obtain a reference to 
this document from a node.

### Blank nodes

Before version [1.0.0](https://github.com/hadley/xml2/releases/tag/v1.0.0) of the *xml2* package, the `read_xml()` 
function passed the `XML_PARSE_NOBLANKS` option to *libxml2* by default. Since version 1.0.0, the function has an 
`options` argument to control the parser options and `options="NOBLANKS"` is the default value. The effect of this 
option is to remove blank nodes, but the exact definition used by *libxml2* for a blank node is not clear, see e.g. 
[this discussion](https://mail.gnome.org/archives/xml/2009-December/msg00019.html). 

Java has an option to remove certain 'ignorable whitespace' using `setIgnoringElementContentWhitespace` when the parser 
is created, but the 
[documentation](https://docs.oracle.com/javase/7/docs/api/javax/xml/parsers/DocumentBuilderFactory.html#setIgnoringElementContentWhitespace%28boolean%29) 
clearly states that this option can only be used in validating mode. At a minimum, this requires a DTD to be present in 
the XML document.

All this means that behavior between *xml2* and *renjin-xml2* may be different when dealing with blank nodes.

### HTML

The *xml2* includes a function `read_html()` to parse HTML files. HTML looks like XML, but browser will accept HTML 
documents which are invalid or malformed XML documents. The package uses the 
[HTMLparser](http://xmlsoft.org/html/libxml-HTMLparser.html) module from the *libxml2* C library to parse (and fix) 
HTML documents. Java built-in XML processors do not have such an HTML parser, therefore the *renjin-xml2* package uses 
the [jsoup](https://jsoup.org/) Java library. In particular, we use *jsoup* to parse the document and convert it to a 
well-formed XML document using the [outerHtml()](https://jsoup.org/apidocs/org/jsoup/nodes/Document.html#outerHtml--) 
method.

## License

The *xml2* package is licensed as GPL version 2 or later and this replacement package has the same license. See the 
[LICENSE](LICENSE) file for the full text of the license.

