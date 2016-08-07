[![Build Status](https://travis-ci.org/mjkallen/renjin-xml2.svg?branch=master)](https://travis-ci.org/mjkallen/renjin-xml2)

# renjin-xml2

A drop-in replacement for the [xml2](https://github.com/hadley/xml2) package in Renjin. Note that this replacement 
package is currently by no means fully functional. For one, it doesn't yet handle HTML files. In the remainder of this 
README, the term *xml2* refers to the original R package authored by Wickham and others.

## Some technical details

The *xml2* package uses S3 classes to represent an XML document and its nodes: `xml_document` and `xml_node`. There is a 
third class `xml_nodeset` to represent a list of nodes.

Objects of class `xml_document` inherit from `xml_node` therefore objects from these two classes have almost the same 
structure: both are a list with two named elements: `node` and `doc`. An XML document is essentially represented by the 
root node. The `node` element will be the pointer to the node and the `doc` element will be a pointer to the document. 
The latter is a way to keep track of the document which 'owns' the node, but Java allows you to obtain a reference to 
this document from a node.

## License

The *xml2* package is licensed as GPL version 2 or later and this replacement package has the same license. See the 
[LICENSE](LICENSE) file for the full text of the license. 