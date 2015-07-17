//
//  SeriesTableViewCell.swift
//  Tview
//
//  Created by 1001914 on 2015. 7. 17..
//
//

import UIKit

class SeriesTableViewCell: UITableViewCell {
    
    @IBOutlet weak var rank: UILabel!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var genre: UILabel!
    @IBOutlet weak var rating: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
