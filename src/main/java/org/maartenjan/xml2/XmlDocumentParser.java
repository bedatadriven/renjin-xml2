package org.maartenjan.xml2;

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
 * Parse XML documents from R code.
 */
public class XmlDocumentParser {

  /**
   *
   * @param xml   a string with XML
   * @return      an R list with classes xml_document and xml_node
   * @throws IOException
   */
  public static ListVector parse(String xml) throws IOException {

    DocumentBuilderFactory builderFactory = DocumentBuilderFactory.newInstance();
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

  public static ListVector xml_children(Node node) {
    return xml_children(node, true);
  }

  public static ListVector xml_contents(Node node) {
    return xml_children(node, false);
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
      case Node.TEXT_NODE:
        return "Text: " + node.getTextContent();
      case Node.ELEMENT_NODE:
        return "Element: " + node.getNodeName();
      case Node.COMMENT_NODE:
        return "Comment: " + node.getNodeValue();
      default:
        return "Other";
    }

  }

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

}
