package org.maartenjan.xml2;

import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.xml.sax.InputSource;
import org.xml.sax.SAXException;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;
import java.io.IOException;
import java.io.StringReader;

/**
 * Parse XML documents from R code.
 */
public class XmlDocumentParser {

  public static Document parse(String xml) throws IOException {

    DocumentBuilderFactory builderFactory = DocumentBuilderFactory.newInstance();
    DocumentBuilder builder;
    try {
      builder = builderFactory.newDocumentBuilder();
    }
    catch(ParserConfigurationException e) {
      throw new RuntimeException(e);
    }

    InputSource is = new InputSource(new StringReader(xml));
    Document xmlDoc;
    try {
      xmlDoc = builder.parse(is);
    }
    catch (SAXException e) {
      throw new RuntimeException(e);
    }

    return(xmlDoc);
  }

  public static Element doc_root(Document doc) {
    return(doc.getDocumentElement());
  }

  public static String node_name(Element node) {
    return(node.getTagName());
  }
}
