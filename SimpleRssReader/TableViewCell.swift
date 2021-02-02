//
//  TableViewCell.swift
//  SimpleRssReader
//
//  Created by Janarthan Subburaj on 02/02/21.
//

import UIKit

enum CellState {
  case expanded
  case collapsed
}

class TableViewCell: UITableViewCell {
    
    @IBOutlet weak var HeadLabel: UILabel!
    @IBOutlet weak var DateLabel: UILabel!
    @IBOutlet weak var DetailsLabel: UILabel!
            
        
    override func awakeFromNib() {
        super.awakeFromNib()
        DetailsLabel.numberOfLines = 5
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
