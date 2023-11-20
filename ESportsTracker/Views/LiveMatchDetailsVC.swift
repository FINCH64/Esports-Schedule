//
//  LiveMatchDetailsVC.swift
//  ESportsTracker
//
//  Created by f1nch on 15.11.23.
//

import UIKit

class LiveMatchDetailsVC: UIViewController,MatchView {
    
    @IBOutlet weak var tournamentShortNameLabel: UILabel!
    @IBOutlet weak var tournamentFullNameLabel: UILabel!
    @IBOutlet weak var homeTeamLogo: UIImageView!
    @IBOutlet weak var awayTeamLogo: UIImageView!
    @IBOutlet weak var homeTeamNameLabel: UILabel!
    @IBOutlet weak var awayTeamNameLabel: UILabel!
    @IBOutlet weak var matchStatusLabel: UILabel!
    @IBOutlet weak var matchTypeLabel: UILabel!
    @IBOutlet weak var mapNumberLabel: UILabel!
    @IBOutlet weak var mapsScoreLabel: UILabel!
    @IBOutlet weak var timeFromStartLabel: UILabel!
    
    var presenter: Presenter?
    var matchIndex: IndexPath? //IndexPath(номер выбранного ряда в таблице) совпадает с номером матча в массиве матчей по кс
    var match: Event?
    
    override func viewDidLoad() { //получим данные по переданному индексу от TableVC из модели и соберём всё вью по этим данным
        super.viewDidLoad()
        //MatchesInfoManager.shared.updateAllCurrentLiveMatches(updateAllMatchesTable: true)
        presenter = LiveMatchDetailsPresenter(model: MatchesInfoModel.shared,viewToPresent: self)
        self.match = (presenter as! LiveMatchDetailsPresenter).getSelectedMatch(forIndex: matchIndex?.row ?? 0)
        
        let currentUnixTime = Date().timeIntervalSince1970
        let mapStartUnixTime = Double(match?.time?.currentPeriodStartTimestamp ?? Int(currentUnixTime))
        let secondsPassedFromMapStart =  currentUnixTime - mapStartUnixTime
        
        tournamentShortNameLabel.text = match?.tournament?.uniqueTournament?.name ?? "Tournament short name"
        tournamentFullNameLabel.text = match?.tournament?.name ?? "Tournament full name"
        homeTeamLogo.image = UIImage(data: match?.homeTeam?.teamLogoData ?? Data())
        awayTeamLogo.image = UIImage(data: match?.awayTeam?.teamLogoData ?? Data())
        homeTeamNameLabel.text = match?.homeTeam?.name ?? "-"
        awayTeamNameLabel.text = match?.awayTeam?.name ?? "-"
        matchStatusLabel.text = match?.status?.type == "inprogress" ? "Live" : "Not live"
        matchTypeLabel.text = "Best of \(match?.bestOf ?? 0)"
        mapNumberLabel.text = match?.status?.description ?? "-"
        mapsScoreLabel.text = "\(match?.homeScore?.current ?? 0):\(match?.awayScore?.current ?? 0)"
        timeFromStartLabel.text = "\(Int(secondsPassedFromMapStart/60)) minutes"
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
