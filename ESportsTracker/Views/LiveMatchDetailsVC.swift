//
//  LiveMatchDetailsVC.swift
//  ESportsTracker
//
//  Created by f1nch on 8.4.24.
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
    @IBOutlet weak var betAmountTextField: UITextField!
    @IBOutlet weak var betOddsTextField: UITextField!
    @IBOutlet weak var betTypeSegmentedControl: UISegmentedControl!
    @IBOutlet weak var placeBetButton: UIButton!
    @IBOutlet weak var teamToBetSegmentedControl: UISegmentedControl!
    
    
    var presenter: Presenter?
    var matchIndex: IndexPath? //IndexPath(номер выбранного ряда в таблице) совпадает с номером матча в массиве матчей по кс
    var match: Event?
    
    //установим презентер и отрисуем view,на основе переданного матча
    override func viewDidLoad() { //получим данные по переданному индексу от TableVC из модели и соберём всё вью по этим данным
        super.viewDidLoad()
        
        presenter = LiveMatchDetailsPresenter(matchesModel: MatchesInfoModel.shared, betsModel: MyBetsModel.shared, viewToPresent: self)
        self.match = getSelectedMatch(forIndex: matchIndex?.row ?? 0)
        
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
    
    //при нажатии на кнопку проверяет введённые данные и если они верны пытается сохранить ставку
    @IBAction func placeBetTapped(_ sender: UIButton) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
        let okAction =  UIAlertAction(title: "OK", style: .default)
        alertController.addAction(okAction)
        alertController.title = "Wrong input"
        
        guard let betAmmount = Double(betAmountTextField.text ?? "err") else {
            alertController.message = "Bet ammount must contain only numbers"
            present(alertController, animated: false)
            return
        }
        
        guard let betOdd = Double(betOddsTextField.text ?? "err") else {
            alertController.message = "Bet odd must contain only numbers"
            present(alertController, animated: false)
            return
        }
        
        guard betTypeSegmentedControl.selectedSegmentIndex == 0 || betTypeSegmentedControl.selectedSegmentIndex == 1 else {
            alertController.message = "Select bet type"
            present(alertController, animated: false)
            return
        }
        
        guard teamToBetSegmentedControl.selectedSegmentIndex == 0 || teamToBetSegmentedControl.selectedSegmentIndex == 1 else {
            alertController.message = "Select on which team to bet"
            present(alertController, animated: false)
            return
        }
        
        let betType = betTypeSegmentedControl.selectedSegmentIndex == 0 ? BetType.map : BetType.match
        
        let teamBet = teamToBetSegmentedControl.selectedSegmentIndex == 0 ? TeamType.home : TeamType.away
        
        saveTask(betAmount: betAmmount, betOdd: betOdd, forMatch: match!, teamBetOn: teamBet,betType: betType)
    }
    
    //возвращает презентер типа презентера деталей лайв матчей,сделано чтобы не приводить искуственно при каждой надобности использовать презентер
    func getLiveMatchDetailsPresenter() -> LiveMatchDetailsPresenter {
        presenter as! LiveMatchDetailsPresenter
    }
    
    //вернет Event(идущий матч) под номером ряда,на который нажали
    func getSelectedMatch(forIndex: Int) -> Event{
        getLiveMatchDetailsPresenter().getSelectedMatch(forIndex: forIndex)
    }
    
    //сохранить ставку,сделанную на идущий матч
    func saveTask(betAmount: Double, betOdd: Double, forMatch: Event, teamBetOn: TeamType,betType: BetType) {
        getLiveMatchDetailsPresenter().saveTask(betAmount: betAmount, betOdd: betOdd, forMatch: forMatch, teamBetOn: teamBetOn,betType: betType)
    }
}
