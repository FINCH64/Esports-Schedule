//
//  UpcomingMatchCell.swift
//  ESportsTracker
//
//  Created by f1nch on 25.5.24.
//

import UIKit

//класс отображающий структуру ячейки с будущими матчами
class UpcomingMatchCell: UICollectionViewCell {
    
    @IBOutlet weak var homeTeamNameLabel: UILabel!
    @IBOutlet weak var awayTeamNameLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = CGFloat(15)
    }
}
