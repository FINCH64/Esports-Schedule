//
//  MyBetsCell.swift
//  ESportsTracker
//
//  Created by f1nch on 22.11.23.
//

import Foundation
import UIKit

class MyBetsCell: UITableViewCell {
    
    
    @IBOutlet weak var betStatusLabel: UILabel!
    @IBOutlet weak var homeTeamNameLabel: UILabel!
    @IBOutlet weak var awayTeamNameLabel: UILabel!
    @IBOutlet weak var matchDateLabel: UILabel!
    @IBOutlet weak var betProfitLabel: UILabel!
    @IBOutlet weak var betTypeLabel: UILabel!
    @IBOutlet weak var teamBetMadeOnLabel: UILabel!
    @IBOutlet weak var mapBetPlacedLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
