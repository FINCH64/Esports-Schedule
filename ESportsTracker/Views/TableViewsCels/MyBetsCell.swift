//
//  MyBetsCell.swift
//  ESportsTracker
//
//  Created by f1nch on 22.11.23.
//

import Foundation
import UIKit

//класс отображающий ячейку таблицы со сделанными ставками
class MyBetsCell: UITableViewCell {
    
    
    @IBOutlet weak var betStatusLabel: UILabel!
    @IBOutlet weak var homeTeamNameLabel: UILabel!
    @IBOutlet weak var awayTeamNameLabel: UILabel!
    @IBOutlet weak var matchDateLabel: UILabel!
    @IBOutlet weak var betProfitLabel: UILabel!
    @IBOutlet weak var betTypeLabel: UILabel!
    @IBOutlet weak var teamBetMadeOnLabel: UILabel!
    @IBOutlet weak var mapBetPlacedLabel: UILabel!
    
}
