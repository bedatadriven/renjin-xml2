[![Build Status](https://travis-ci.org/mjkallen/renjin-xml2.svg?branch=master)](https://travis-ci.org/mjkallen/renjin-xml2)

# renjin-xml2

A drop-in replacement for the [xml2](https://github.com/hadley/xml2) package in Renjin. Note that this replacement 
package is currently by no means fully functional. For one, it doesn't yet handle HTML files. In the remainder of this 
README, the term *xml2* refers to the original R package authored by Wickham *et al*.

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

Java has an option to remove certain 'ignorable whitespace' using the `setIgnoringElementContentWhitespace()` method, 
but the document clearly states that this option can only be used in validating mode.

## License

The *xml2* package is licensed as GPL version 2 or later and this replacement package has the same license. See the 
[LICENSE](LICENSE) file for the full text of the license.
