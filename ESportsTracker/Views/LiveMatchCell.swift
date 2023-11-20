//
//  LiveMatchCell.swift
//  ESportsTracker
//
//  Created by f1nch on 17.11.23.
//

import UIKit

//класс отображающий информацию о ячейке таблицы со всеми матчами
class LiveMatchCell: UITableViewCell {

    
    @IBOutlet weak var homeTeamImage: UIImageView!
    @IBOutlet weak var awayTeamImage: UIImageView!
    @IBOutlet weak var matchStatus: UILabel!
    @IBOutlet weak var matchScore: UILabel!
    @IBOutlet weak var homeTeamImageLoadIndicator: UIActivityIndicatorView!
    @IBOutlet weak var awayTeamImageLoadIndicator: UIActivityIndicatorView!
    @IBOutlet weak var homeTeamName: UILabel!
    @IBOutlet weak var awayTeamName: UILabel!
    
    //нужно сохранить id команд чтобы после загрузки их лого,можно было понять какое из них к какой команде отнести
    //кроме id с этим поможет indexRow передаваемый в загрузку картинок и обновленние ячейки.Он будет указывать в каком ряду искать команды с id загруженных картинок
    var homeTeamId = 0
    var awayTeamId = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
