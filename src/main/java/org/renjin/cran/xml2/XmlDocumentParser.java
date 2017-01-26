package org.renjin.cran.xml2;

import org.jsoup.Jsoup;
import org.renjin.eval.Context;
import org.renjin.eval.EvalException;
import org.renjin.invoke.annotations.Current;
import org.renjin.primitives.io.connections.Connection;
import org.renjin.primitives.io.connections.Connections;
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
import javax.xml.transform.*;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;
import java.io.IOException;
import java.io.StringReader;
import java.io.StringWriter;
import java.io.Writer;
import java.util.LinkedList;

/**
 * Parses XML documents from R code.
 *
 * <p>Note that only public methods are accessible from R code.</p>
 */
public class XmlDocumentParser {

  /**
   * Parse an XML document as a string.
   *
   * @param xml       a string with XML
   * @param dtdvalid  a boolean to indicate if the XML processor should be validating or not
   * @param noblanks  a boolean to indicate if 'ignorable whitespace' should be removed
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
   * Parse an HTML document as a string.
   *
   * @param html      a string with HTML
   * @param noblanks  a boolean to indicate if 'ignorable whitespace' should be removed
   * @return      an R list with classes <code>xml_document</code> and <code>xml_node</code>
   * @throws IOException
   */
  public static ListVector parse_html(String html, boolean noblanks) throws IOException {

    org.jsoup.nodes.Document doc = Jsoup.parse(html);

    String xml = doc.outerHtml();

    return parse(xml, false, noblanks);
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


  /**
   * Returns the parent node of a node
   * @param node  a document node
   * @return      a document node which is the parent of <code>node</code>
   * @throws    EvalException If <code>node</code> has no parent.
   */
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


  /**
   * Returns the siblings of a node
   * @param node  a document node
   * @return      an R list of class <code>xml_nodeset</code>
   */
  public static ListVector xml_siblings(Node node) {

    LinkedList<Node> siblings = new LinkedList<Node>();

    Node sibling = node.getPreviousSibling();
    while (sibling != null) {
      // add sibling at the front of the list
      siblings.addFirst(sibling);
      sibling = sibling.getPreviousSibling();
    }

    sibling = node.getNextSibling();
    while (sibling != null) {
      // add sibling at the end of the list
      siblings.addLast(sibling);
      sibling = sibling.getNextSibling();
    }

    ListVector.Builder ns = new ListVector.Builder();
    for (Node s : siblings) {
      if (s instanceof Element) {
        ns.add(xml_node(s));
      }
    }

    ns.setAttribute("class", new StringArrayVector("xml_nodeset"));

    return ns.build();
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

  public static Document xml_new_document(String version, String encoding) throws ParserConfigurationException {

    DocumentBuilderFactory docFactory = DocumentBuilderFactory.newInstance();
    DocumentBuilder docBuilder = docFactory.newDocumentBuilder();
    Document document = docBuilder.newDocument();
    document.setXmlVersion(version);
    document.setXmlStandalone(true);

    return document;
  }

  public static ListVector xml_set_root_or_add(Document document, String tagName, ListVector attributes) {

    Element child = create_element(document, tagName, attributes);

    if(document.getChildNodes().getLength() == 0) {
      document.appendChild(child);
    } else {
      document.getChildNodes().item(0).appendChild(child);
    }

    return xml_node(child);
  }


  /**
   * Formats the node for priting to the console.
   */
  public static String node_format(Node node) {

    short type = node.getNodeType();

    switch(type) {
      case Node.DOCUMENT_NODE:
        return "Document";
      case Node.TEXT_NODE:
        return "Text: " + node.getTextContent();
      case Node.ELEMENT_NODE:
        if (node.isSameNode(node.getOwnerDocument().getDocumentElement())) {
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

  private static void xml_write(Node node, Writer writer) throws TransformerException, IOException {
    Transformer transformer = TransformerFactory.newInstance().newTransformer();
    transformer.setOutputProperty(OutputKeys.INDENT, "yes");
    transformer.setOutputProperty(OutputKeys.DOCTYPE_PUBLIC, "yes");

    transformer.setOutputProperty("{http://xml.apache.org/xslt}indent-amount", "2");


    StreamResult result = new StreamResult(writer);
    DOMSource source = new DOMSource(node);
    transformer.transform(source, result);
    writer.flush();
  }

  public static String xml_write_character(Node node) throws TransformerException, IOException {
    StringWriter writer = new StringWriter();
    xml_write(node, writer);
    return writer.toString();
  }

  public static void xml_write_doc(@Current Context context, Document document, SEXP connectionSexp) throws IOException, TransformerException {
    Connection connection = Connections.getConnection(context, connectionSexp);
    xml_write(document, connection.getPrintWriter());
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

  public static String xml_attr(Node node, String attr, String defaultValue) {
    if(!(node instanceof Element)) {
      return defaultValue;
    }
    Element element = (Element) node;
    if(element.hasAttribute(attr)) {
      return element.getAttribute(attr);
    } else {
      return defaultValue;
    }
  }

  public static void set_xml_attr(Node node, String attr, String value) {
    if(!(node instanceof Element)) {
      throw new EvalException("Cannot set attribute on node of type " + node.getClass().getSimpleName());
    }
    ((Element) node).setAttribute(attr, value);
  }

  public static boolean identical_nodes(Node a, Node b) {
    return a.isSameNode(b);
  }


  public static ListVector xml_add_child(Node parentNode, String tagName, ListVector attributes, int where) {
    if (!(parentNode instanceof Element)) {
      throw new EvalException("Cannot add element to node of type " + parentNode.getClass().getSimpleName());
    }
    Element parent = (Element) parentNode;
    Element child = create_element(parent.getOwnerDocument(), tagName, attributes);

    if(where >= parent.getChildNodes().getLength() || parent.getChildNodes().getLength() == 0) {
      parent.appendChild(child);

    } else if(where < 1) {
      parent.insertBefore(child, parent.getFirstChild());

    } else {
      Node before = child.getChildNodes().item(where);
      parent.insertBefore(child, before);
    }
    return xml_node(child);
  }

  private static Element create_element(Document document, String tagName, ListVector attributes) {
    Element child = document.createElement(tagName);
    for (NamedValue namedValue : attributes.namedValues()) {
      child.setAttribute(namedValue.getName(), namedValue.getValue().asString());
    }
    return child;
  }
}
