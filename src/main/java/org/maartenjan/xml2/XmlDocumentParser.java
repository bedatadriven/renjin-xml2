package org.maartenjan.xml2;

import org.renjin.eval.EvalException;
import org.renjin.sexp.*;
import org.renjin.util.NamesBuilder;
import org.w3c.dom.*;
import org.xml.sax.ErrorHandler;
import org.xml.sax.InputSource;
import org.xml.sax.SAXException;
import org.xml.sax.SAXParseException;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;
import java.io.IOException;
import java.io.StringReader;

/**
 * Parses XML documents from R code.
 *
 * <p>Note that only public methods are accessible from R code.</p>
 */
public class XmlDocumentParser {

  /**
   * Parse an XML document as a string.
   *
   * @param xml   a string with XML
   * @return      an R list with classes <code>xml_document</code> and <code>xml_node</code>
   * @throws IOException
   */
  public static ListVector parse(String xml, boolean dtdvalid, boolean noblanks) throws IOException {

    DocumentBuilderFactory builderFactory = DocumentBuilderFactory.newInstance();
    builderFactory.setNamespaceAware(true);
    builderFactory.setValidating(dtdvalid);
    builderFactory.setIgnoringElementContentWhitespace(noblanks);

    DocumentBuilder builder;
    try {
      builder = builderFactory.newDocumentBuilder();
    }
    catch(ParserConfigurationException e) {
      throw new RuntimeException(e);
    }

    builder.setErrorHandler(new ErrorHandler() {

      public void warning(SAXParseException e) throws SAXException {}

      public void fatalError(SAXParseException e) throws SAXException {
        throw e;
      }

      public void error(SAXParseException e) throws SAXException {
        throw e;
      }

    });

    InputSource is = new InputSource(new StringReader(xml));
    Document doc;
    try {
      doc = builder.parse(is);
    }
    catch (SAXException e) {
      throw new RuntimeException(e);
    }

    Element root = doc.getDocumentElement();

    return xml_document(root, doc);
  }


  /**
   * Returns the name of a document node.
   *
   * @param node  a document node
   * @return      a character string with the name of the element tag (e.g. 'p' or 'html').
   *              For text and comment nodes, this method returns 'text' and 'comment' respectively
   *              and an empty string for all other node types.
   */
  public static String node_name(Node node) {

    short type = node.getNodeType();

    switch(type) {
      case Node.ELEMENT_NODE:
        return node.getNodeName();
      case Node.TEXT_NODE:
        return "text";
      case Node.COMMENT_NODE:
        return "comment";
      default:
        return "";
    }

  }


  private static ListVector xml_children(Node node, boolean elements_only) {

    NodeList children = node.getChildNodes();

    ListVector.Builder ns = new ListVector.Builder();
    Node child;
    for (int i = 0; i < children.getLength(); ++i) {
      child = children.item(i);
      if (!elements_only || child instanceof Element) {
        ns.add(xml_node(child));
      }
    }

    ns.setAttribute("class", new StringArrayVector("xml_nodeset"));

    return ns.build();
  }


  /**
   * Returns the child elements of a document node.
   *
   * @param node  a document node
   * @return      an R list of class <code>xml_nodeset</code>
   */
  public static ListVector xml_children(Node node) {
    return xml_children(node, true);
  }


  /**
   * Returns all direct descendants of a document node.
   *
   * @param node  a document node
   * @return      an R list of class <code>xml_nodeset</code>
   */
  public static ListVector xml_contents(Node node) {
    return xml_children(node, false);
  }


  public static ListVector xml_parent(Node node) {

    Node parent = node.getParentNode();
    if (parent == null) {
      throw new EvalException("Parent does not exist");
    }
    return xml_node(parent);
  }

  /**
   * Returns the root of a document
   *
   * @param doc   a document
   * @return      an R list of class <code>xml_document</code>
   */
  public static ListVector xml_root(Document doc) {
    return xml_document(doc.getDocumentElement(), doc);
  }


  private static ListVector xml_node(Node node) {

    ListVector.NamedBuilder lv = new ListVector.NamedBuilder();

    lv.add("node", new ExternalPtr<Node>(node));
    lv.add("doc", new ExternalPtr<Document>(node.getOwnerDocument()));
    lv.setAttribute("class", new StringArrayVector("xml_node"));

    return lv.build();
  }


  private static ListVector xml_document(Node node, Document doc) {

    ListVector.NamedBuilder lv = new ListVector.NamedBuilder();

    lv.add("node", new ExternalPtr<Node>(node));
    lv.add("doc", new ExternalPtr<Document>(doc));
    lv.setAttribute("class", new StringArrayVector("xml_document", "xml_node"));

    return lv.build();
  }


  public static String node_format(Node node) {

    short type = node.getNodeType();

    switch(type) {
      case Node.DOCUMENT_NODE:
        return "Document";
      case Node.TEXT_NODE:
        return "Text: " + node.getTextContent();
      case Node.ELEMENT_NODE:
        if (node == node.getOwnerDocument().getDocumentElement()) {
          return "Root: " + node.getNodeName();
        } else {
          return "Element: " + node.getNodeName();
        }
      case Node.COMMENT_NODE:
        return "Comment: " + node.getNodeValue();
      default:
        return "Other";
    }

  }


  /**
   * Returns the attributes of a document node.
   *
   * @param node  a document node
   * @return      a named R list in which the names are the attribute names and
   *              the values are the attribute values.
   */
  public static StringArrayVector xml_attrs(Node node) {

    NamedNodeMap attrs = node.getAttributes();

    AttributeMap.Builder attributes = AttributeMap.builder();
    NamesBuilder names = NamesBuilder.withInitialCapacity(attrs.getLength());

    String[] values = new String[attrs.getLength()];

    // only Element nodes can have attributes
    if (node.getNodeType() == Node.ELEMENT_NODE && node.hasAttributes()) {
      for(int i = 0 ; i < attrs.getLength() ; ++i) {
        Attr attribute = (Attr) attrs.item(i);
        values[i] = attribute.getValue();
        names.add(attribute.getName());
      }
      attributes.setNames((StringVector)names.build());
    } else {
      attributes.setNames(StringVector.EMPTY).build();
    }

    return new StringArrayVector(values, attributes.build());
  }

  public static boolean identical_nodes(Node a, Node b) {
    return a.isSameNode(b);
  }

}
