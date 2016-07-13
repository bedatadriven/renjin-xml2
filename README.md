# renjin-xml2

A drop-in replacement for the xml2 package in Renjin. Note that this is currently by no means functional.

The [xml2](https://github.com/hadley/xml2) package uses S3 classes to represent an XML document and its nodes: 
`xml_document` and `xml_node`. There is a third class `xml_nodeset` to represent a list of nodes.

Objects of class `xml_document` inherit from `xml_node` therefore objects from these two classes have almost the same 
structure: both are a list with two named elements: `node` and `doc`. An XML document is essentially represented by the 
root node. The `node` element will be the pointer to the node and the `doc` element will be a pointer to the document. 
The latter is a way to keep track of the document which 'owns' the node, but Java allows you to obtain a reference to 
this document from a node.

