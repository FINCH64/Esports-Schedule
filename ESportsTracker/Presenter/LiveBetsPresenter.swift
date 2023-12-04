//
//  MyBetsPresenter.swift
//  ESportsTracker
//
//  Created by f1nch on 21.11.23.
//

import Foundation
import UIKit

class LiveBetsPresenter: Presenter {
    var model: Model
    var viewToPresent: View
    
    init(model: Model, viewToPresent: View) {
        self.model = model
        self.viewToPresent = viewToPresent
    }
    
    //заполняет ячейку таблицы со ставками на основе данных из модели
    func fillCellLiveMatch(cellToFill: UITableViewCell,cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = cellToFill as! MyBetsCell
        let bet = getBetsModel().myLiveBets[indexPath.row]
        do {
            let match = try JSONDecoder().decode(Event.self, from: bet.matchEvent!)
            let homeTeamName = match.homeTeam?.name ?? "Home team name"
            let awayTeamName = match.awayTeam?.name ?? "Away team name"
            let mapBetPlacedOn = bet.mapBetPlacedOn ?? "No map info"
            let dateEventPlayed = bet.datePlayed ?? Date()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd-MM-yyyy"
            
            cell.homeTeamNameLabel.text = homeTeamName
            cell.awayTeamNameLabel.text = awayTeamName
            cell.matchDateLabel.text = dateFormatter.string(from: dateEventPlayed)
            
            cell.betTypeLabel.text = bet.betType == BetType.map.rawValue ? "\(mapBetPlacedOn) winner" : "Match winner"
            cell.teamBetMadeOnLabel.text = bet.teamBetOn == TeamType.home.rawValue ? homeTeamName : awayTeamName
            cell.mapBetPlacedLabel.text = mapBetPlacedOn
            
            if bet.matchResultChecked == true {
                cell.betStatusLabel.text = bet.betWon ? "Win" : "Lose"
                cell.betProfitLabel.text = "\(bet.betProfit)$"
            } else {
                cell.betStatusLabel.text = "Not finished"
                cell.betProfitLabel.text = "0.0$"
            }
            
        } catch let error as NSError {
            print(error.localizedDescription)
            return cell
        }
        
        return cell
    }
   
    //метод обновления всех ячеек со ставками,будет работать только если ставок больше 0,останавливает спинер подгрузки лайв ставок
    func updateMyBetsCells() {
        getLiveBetsVC().spinnerStopAnimating()
   
        if getBetsModel().myLiveBets.count > 0 {
            reloadData()
        }
    }
    
    //возвращает колличество лайв ставок
    func getLiveBetsCount() -> Int {
        (model as? MyBetsModel)?.myLiveBets.count ?? 0
    }
    
    //обновить данные о ставках
    func fetchBets() {
        if let model = model as? MyBetsModel {
            model.fetchBets()
        }
    }
    
    //возвращает Model типа MyBetsModel,сделано чтобы не приводить искуственно при каждой надобности использовать
    func getBetsModel() -> MyBetsModel {
        model as! MyBetsModel
    }
    
    //возвращает View типа View лайв ставок,сделано чтобы не приводить искуственно при каждой надобности использовать
    func getLiveBetsVC() -> LiveBetsVC {
        viewToPresent as! LiveBetsVC
    }
    
    //reloadData вызывает заново у TableView мтетоды подсчёта колличества рядов и создание каждой ячейки
    func reloadData() {
        getLiveBetsVC().betsTableView.reloadData()
    }
}
