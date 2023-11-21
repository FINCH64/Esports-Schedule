//
//  MyBetsPresenter.swift
//  ESportsTracker
//
//  Created by f1nch on 21.11.23.
//

import Foundation
import UIKit

class MyBetsPresenter: Presenter {
    var model: Model
    var viewToPresent: View
    
    init(model: Model, viewToPresent: View) {
        self.model = model
        self.viewToPresent = viewToPresent
    }
    
    //заполняет ячейку таблицы со ставками на основе данных из модели
    func fillCellLiveMatch(cellToFill: UITableViewCell,cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = cellToFill as! LiveMatchCell
        let match = (model as! MatchesInfoModel).liveCsMatchesInfo?[indexPath.row]
        
        if let match = match {
            if let homeTeamLogoData = match.homeTeam?.teamLogoData {
                cell.homeTeamImage.image = UIImage(data: homeTeamLogoData)
                cell.homeTeamImageLoadIndicator.stopAnimating()
                cell.homeTeamImageLoadIndicator.isHidden = true
            } else {
                cell.homeTeamImageLoadIndicator.isHidden = false
                cell.homeTeamImageLoadIndicator.startAnimating()
            }
            
            if let awayTeamLogoData = match.awayTeam?.teamLogoData {
                cell.awayTeamImage.image = UIImage(data: awayTeamLogoData)
                cell.awayTeamImageLoadIndicator.stopAnimating()
                cell.awayTeamImageLoadIndicator.isHidden = true
            } else {
                cell.awayTeamImageLoadIndicator.isHidden = false
                cell.awayTeamImageLoadIndicator.startAnimating()
            }
            
            cell.homeTeamId = match.homeTeam?.id ?? 0
            cell.awayTeamId = match.awayTeam?.id ?? 0
            
            cell.homeTeamName.text = match.homeTeam?.name ?? "Team 1"
            cell.awayTeamName.text = match.awayTeam?.name ?? "Team 2"
            
            cell.matchStatus.text = match.status?.type == "inprogress" ? "Live" : "Not live"
            cell.matchScore.text = "\(match.homeScore?.current ?? 0):\(match.awayScore?.current ?? 0)"
        }
        
        return cell
    }
   
    //метод обновления всех ячеек со ставками,будет работать только если presenter обновляет таблицу на экране со ставками,если с ним свяязана модель всех ставок и их больше 0
    func updateMyBetsCells() {
        if let tableVC = viewToPresent as? MyBetsVC,
           let model = model as? MyBetsModel,
           model.myBets.count > 0 {
                //tableVC.tableView.reloadData()//reloadData вызывает заново у TableView мтетоды подсчёта колличества рядов и создание каждой ячейки
                //tableVC.spinnerStopAnimating()
        }
    }
    
    func fetchBets() {
        if let model = model as? MyBetsModel {
            model.fetchBets()
        }
    }
}
