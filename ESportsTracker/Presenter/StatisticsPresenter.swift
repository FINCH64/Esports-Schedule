//
//  StatisticsPresenter.swift
//  ESportsTracker
//
//  Created by f1nch on 26.11.23.
//

import Foundation
import UIKit

class StatisticsPresenter: Presenter {
    var model: Model
    var viewToPresent: View
    
    init(model: Model, viewToPresent: View) {
        self.model = model
        self.viewToPresent = viewToPresent
    }
    
    //заполняет ячейку таблицы со ставками на основе данных из модели
    func fillStatisticCellMatch(cellToFill: UITableViewCell,cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = cellToFill as! MyBetsCell
        let bet = getBetsModel().betsInSelectedRange[indexPath.row]
        let betOdd = bet.matchOdd
        let betAmmount = bet.betAmount
        let betProfit = (betOdd * betAmmount) - betAmmount
        do {
            let match = try JSONDecoder().decode(Event.self, from: bet.matchEvent!)
            let mapBetPlacedOn = match.status?.description ?? "Unknown map"
            let homeTeamName = match.homeTeam?.name ?? "Home team name"
            let awayTeamName = match.awayTeam?.name ?? "Away team name"
            let dateEventPlayed = bet.datePlayed ?? Date()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd-MM-yyyy"
            
            cell.homeTeamNameLabel.text = homeTeamName
            cell.awayTeamNameLabel.text = awayTeamName
            cell.matchDateLabel.text = dateFormatter.string(from: dateEventPlayed)
            
            cell.betTypeLabel.text = bet.betType == BetType.map.rawValue ? "\(mapBetPlacedOn) winner" : "Match winner"
            cell.teamBetMadeOnLabel.text = bet.teamBetOn == TeamType.home.rawValue ? homeTeamName : awayTeamName
            cell.mapBetPlacedLabel.text = bet.mapBetPlacedOn ?? "No map info"

            if bet.matchResultChecked == true {
                cell.betStatusLabel.text = bet.betWon ? "Win" : "Lose"
                cell.betProfitLabel.text = bet.betWon ? "+ \(betProfit)" : "- \(betAmmount)"
            } else {
                cell.betStatusLabel.text = "Not finished"
                cell.betProfitLabel.text = "0.0"
            }
            
            
        } catch let error as NSError {
            print(error.localizedDescription)
            return cell
        }
        
        
        return cell
    }
    
    //метод обновления всех ячеек со ставками,будет работать только если presenter обновляет таблицу на экране со статистикой,если с ним свяязана модель всех ставок и в диапазоне их > 0
    func updateMyBetsCells() {
        getStatsVC().spinnerStopAnimating()
        
        if getBetsModel().betsInSelectedRange.count > 0 {
            self.calculateAndShowStats()
            reloadData()
        }
    }
    
    //получить количество ставок в заданом диапазоне
    func getBetsInSelectedRange() -> Int {
        getBetsModel().betsInSelectedRange.count
    }
    
    //обновить данные о ставках
    func fetchBets() {
        getBetsModel().fetchBets()
    }
    
    //найти все ставки в заданном диапазоне и записать их в поле в модели ставок
    func findSelectedBets(inDates dateInterval: DateInterval? = nil) {
        getBetsModel().findSelectedBets(inDates: dateInterval)
        self.calculateAndShowStats()
    }
    
    //подсчитать и отрисовать статистику по ставкам,попадающим в диапазон фильтра
    func calculateAndShowStats() {
        var betsWonCounter = 0
        var betsLostCounter = 0
        var overallIncomeCounter = 0.0
            
        getBetsModel().betsInSelectedRange.forEach{ bet in
        if bet.matchResultChecked {
            if bet.betWon {
                betsWonCounter += 1
            }else if !bet.betWon {
                betsLostCounter += 1
            }
                overallIncomeCounter += bet.betProfit
            }
        }
             
        getStatsVC().setBetsWon(wonCount: "\(betsWonCounter)")
        getStatsVC().setBetsLost(lostCount: "\(betsLostCounter)")
        getStatsVC().setOverallIncome(overallIncome: overallIncomeCounter)
    }
    
    //возвращает Model типа MyBetsModel,сделано чтобы не приводить искуственно при каждой надобности использовать
    func getBetsModel() -> MyBetsModel {
        model as! MyBetsModel
    }
    
    //возвращает View типа View статистики ставок,сделано чтобы не приводить искуственно при каждой надобности использовать
    func getStatsVC() -> StatisticsVC {
        viewToPresent as! StatisticsVC
    }
    
    //reloadData вызывает заново у TableView мтетоды подсчёта колличества рядов и создание каждой ячейки
    func reloadData() {
        getStatsVC().statisticBetsTableView.reloadData()
    }
}
