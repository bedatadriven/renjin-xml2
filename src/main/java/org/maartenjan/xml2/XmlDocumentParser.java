package org.maartenjan.xml2;

import org.renjin.sexp.*;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
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

  public static String node_name(Element node) {
    return(node.getTagName());
  }

  public static ListVector xml_children(Element node) {

    NodeList children = node.getChildNodes();

    ListVector.Builder ns = new ListVector.Builder();
    Node child;
    for (int i = 0; i < children.getLength(); ++i) {
      child = children.item(i);
      if (child instanceof Element) {
        ns.add(xml_node((Element) child));
      }
    }

    ns.setAttribute("class", new StringArrayVector("xml_nodeset"));

    return ns.build();
  }

  private static ListVector xml_node(Element node) {

    ListVector.NamedBuilder lv = new ListVector.NamedBuilder();

    lv.add("node", new ExternalPtr<Element>(node));
    lv.add("doc", new ExternalPtr<Document>(node.getOwnerDocument()));
    lv.setAttribute("class", new StringArrayVector("xml_node"));

    return lv.build();
  }

  private static ListVector xml_document(Element node, Document doc) {

    ListVector.NamedBuilder lv = new ListVector.NamedBuilder();

    lv.add("node", new ExternalPtr<Element>(node));
    lv.add("doc", new ExternalPtr<Document>(doc));
    lv.setAttribute("class", new StringArrayVector("xml_document", "xml_node"));

    return lv.build();
  }

  public static String node_format(Element node) {

    String tag = node.getNodeName();
    String content;

    if(node.hasChildNodes() && node.getFirstChild().getNodeType() == Node.TEXT_NODE) {
      content = node.getFirstChild().getTextContent();
    } else {
      content = "...";
    }

    return "<" + tag + ">" + content + "</" + tag + ">" ;
  }
}
