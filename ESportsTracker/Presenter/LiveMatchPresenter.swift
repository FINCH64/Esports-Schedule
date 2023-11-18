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
            cell.homeTeamId = match.homeTeam?.id ?? 0
            cell.awayTeamId = match.awayTeam?.id ?? 0
            
            cell.homeTeamImageLoadIndicator.isHidden = false
            cell.homeTeamImageLoadIndicator.startAnimating()
            
            cell.awayTeamImageLoadIndicator.isHidden = false
            cell.awayTeamImageLoadIndicator.startAnimating()
            
            MatchesInfoManager.shared.getTeamImage(teamId: cell.homeTeamId, indexPath: indexPath)
            MatchesInfoManager.shared.getTeamImage(teamId: cell.awayTeamId, indexPath: indexPath)
            
            cell.matchStatus.text = match.status?.type == "inprogress" ? "live" : "not live"
            cell.matchScore.text = "\(match.homeScore?.current ?? 0):\(match.awayScore?.current ?? 0)" 
        }
        
        return cell
    }
    
    //функция обновления картинок в уже созданных ячейках матчей,вызывается по загрузке картинок с сервера
    //сейчас отрисовка происходит прямо в презентере,надо перенести во view с передачей данных отсюда
    func updateCellsTeamImages(imageData: Data,indexPath: IndexPath,logoTeamId: Int) {
        if let tableVC = viewToPresent as? AllMatchesTableViewController,
           let cellToInsertImages = tableVC.tableView(tableVC.tableView, cellForRowAt: indexPath) as? LiveMatchCell {
            if cellToInsertImages.homeTeamId == logoTeamId {
                cellToInsertImages.homeTeamImage.image = UIImage(data: imageData)
                cellToInsertImages.homeTeamImageLoadIndicator.stopAnimating()
                cellToInsertImages.homeTeamImageLoadIndicator.isHidden = true
            } else if cellToInsertImages.awayTeamId == logoTeamId {
                cellToInsertImages.awayTeamImage.image = UIImage(data: imageData)
                cellToInsertImages.awayTeamImageLoadIndicator.stopAnimating()
                cellToInsertImages.awayTeamImageLoadIndicator.isHidden = true
            }
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
