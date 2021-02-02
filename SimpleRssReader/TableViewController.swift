//
//  TableViewController.swift
//  SimpleRssReader
//
//  Created by Janarthan Subburaj on 02/02/21.
//

import UIKit

class TableViewController: UITableViewController {

    let feedParser = FeedParser()
    let feedURL = "http://www.apple.com/main/rss/hotnews/hotnews.rss"
    var rssItems: [(title: String, description: String, pubDate: String)]?
    var cellStates: [CellState]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = 140
        tableView.rowHeight = UITableView.automaticDimension
        
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.singleLine
        
        feedParser.parseFeed(feedURL: feedURL) { [weak self] rssItems in
          self?.rssItems = rssItems
          self?.cellStates = Array(repeating: .collapsed, count: rssItems.count)
          
          DispatchQueue.main.async {
            self?.tableView.reloadSections(IndexSet(integer: 0), with: .none)
          }
        }
    }


    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let rssItems = rssItems else {
          return 0
        }
        return rssItems.count
        
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! TableViewCell
        
        if let item = rssItems?[indexPath.row] {
            (cell.HeadLabel.text, cell.DetailsLabel.text, cell.DateLabel.text) = (item.title, item.description, item.pubDate)
          
          if let cellState = cellStates?[indexPath.row] {
            cell.DetailsLabel.numberOfLines = cellState == .expanded ? 0: 4
          }
        }
        
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      tableView.deselectRow(at: indexPath, animated: true)
      
      let cell = tableView.cellForRow(at: indexPath) as! TableViewCell
      
      tableView.beginUpdates()
      cell.DetailsLabel.numberOfLines = cell.DetailsLabel.numberOfLines == 4 ? 0 : 4
      cellStates?[indexPath.row] = cell.DetailsLabel.numberOfLines == 4 ? .collapsed : .expanded
      tableView.endUpdates()
    }
}
