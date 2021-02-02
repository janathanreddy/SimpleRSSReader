//
//  FeedParsers.swift
//  SimpleRssReader
//
//  Created by Janarthan Subburaj on 02/02/21.
//

import Foundation

class FeedParser: NSObject, XMLParserDelegate {
   var rssItems = [(title: String, description: String, pubDate: String)]()
  
   var currentElement = ""
  
   var currentTitle = "" {
    didSet {
      currentTitle = currentTitle.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
  }
  
   var currentDescription = "" {
    didSet {
      currentDescription = currentDescription.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
  }
  
   var currentPubDate = "" {
    didSet {
      currentPubDate = currentPubDate.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
  }
  
   var parserCompletionHandler: (([(title: String, description: String, pubDate: String)]) -> Void)?
  
  func parseFeed(feedURL: String, completionHandler: (([(title: String, description: String, pubDate: String)]) -> Void)?) -> Void {
    
    parserCompletionHandler = completionHandler
    
    guard let feedURL = URL(string:feedURL) else {
      print("feed URL is invalid")
      return
    }
    
    URLSession.shared.dataTask(with: feedURL, completionHandler: { data, response, error in
      if let error = error {
        print(error)
        return
      }
      
      guard let data = data else {
        print("No data fetched")
        return
      }
      
      let parser = XMLParser(data: data)
      parser.delegate = self
      parser.parse()
    }).resume()
  }
  
  // MARK: - XMLParser Delegate
  func parserDidStartDocument(_ parser: XMLParser) {
    rssItems.removeAll()
  }
  
  func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
    currentElement = elementName
    
    if currentElement == "item" {
      currentTitle = ""
      currentDescription = ""
      currentPubDate = ""
    }
  }
  
  func parser(_ parser: XMLParser, foundCharacters string: String) {
    switch currentElement {
    case "title":
      currentTitle += string
    case "description":
      currentDescription += string
    case "pubDate":
      currentPubDate += string
    default:
      break
    }
  }
  
  func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
    if elementName == "item" {
      let rssItem = (title: currentTitle, description: currentDescription, pubDate: currentPubDate)
      rssItems.append(rssItem)
    }
  }
  
  func parserDidEndDocument(_ parser: XMLParser) {
    parserCompletionHandler?(rssItems)
  }
  
  func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
    print(parseError.localizedDescription)
  }
}
