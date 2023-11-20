//
//  Presenter.swift
//  ESportsTracker
//
//  Created by f1nch on 15.11.23.
//

import Foundation
import UIKit
//Presenter отвечающий только за обработку информации об идущих матчах
class LiveMatchPresenter: Presenter {
    var model: Model
    var viewToPresent: View
    
    init(viewToPresent: MatchView, matchesModel: MatchesInfoModel) {
        self.viewToPresent = viewToPresent
        self.model = matchesModel
        self.model.presenter = self
    }
    
    //возвращает колличество кс матчей из модели
    func getCsMatchesCount() -> Int {
        (model as! MatchesInfoModel).liveCsMatchesInfo?.count ?? 0
    }
    
    //заполняет ячейку таблицы созданную во встроенном методе,сделано в презентере,тк view не должно иметь доступа к данным модели
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
    
    //функция обновления картинок в уже созданных ячейках матчей,вызывается по загрузке картинок с сервера
    //сейчас отрисовка происходит прямо в презентере,надо перенести во view с передачей данных отсюда
    func updateRows(rowsToUpdate indexPath: IndexPath) {
        if let tableVC = viewToPresent as? AllMatchesTableViewController {
            tableVC.tableView.reloadRows(at: [indexPath], with: .automatic)
        }
    }
    
    //метод обновления всех ячеек,будет работать только если presenter обновляет TableView с матчами,если в нем хранится Модель матчей и матчей > 0
    func updateLiveMatchesTVCells() {
        if let tableVC = viewToPresent as? AllMatchesTableViewController,
           let model = model as? MatchesInfoModel,
           let matchesCount = model.liveCsMatchesInfo?.count,
           matchesCount > 0 {
                tableVC.tableView.reloadData()//reloadData вызывает заново у TableView мтетоды подсчёта колличества рядов и создание каждой ячейки
            tableVC.spinnerStopAnimating()
        }
    }
}
