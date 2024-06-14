//
//  Presenter.swift
//  ESportsTracker
//
//  Created by f1nch on 5.4.24.
//

import Foundation
import UIKit
//Presenter отвечающий только за обработку информации об идущих матчах
class LiveMatchPresenter: Presenter {
    var model: Model
    var viewToPresent: View
    
    //презентер модели устанавливается только на этом экране,
    //тк он выбран в TabBar controller по умолчанию,в дальнейшем презентеры моделей устанавливаются в классе навигатора
    init(viewToPresent: MatchView, matchesModel: MatchesInfoModel) {
        self.viewToPresent = viewToPresent
        self.model = matchesModel
        self.model.presenter = self
    }
    
    //возвращает колличество кс матчей из модели
    func getCsMatchesCount() -> Int {
        getMatchesModel().liveCsMatchesInfo?.count ?? 0
    }
    
    //установить презентер модели
    //он устанавливается только на этом экране,тк он выбран в TabBar controller по умолчанию,в дальнейшем презентеры моделей устанавливаются в классе навигатора
    func setModelPresenter(newPresenter: Presenter) {
        getMatchesModel().setPresenterForModel(newPresenter: newPresenter)
    }
    
    //обновить текущие матчи
    func updateCurrentLiveMatches() {
        spinnerStartAnimating()
        getMatchesModel().updateAllCurrentLiveMatches()
    }
    
    //заполняет ячейку таблицы созданную во встроенном методе,сделано в презентере,тк view не должно иметь доступа к данным модели
    func fillCellLiveMatch(cellToFill: UITableViewCell,cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = cellToFill as! LiveMatchCell
        let match = getMatchesModel().liveCsMatchesInfo?[indexPath.row]
        
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
    func updateRows(rowsToUpdate indexPath: IndexPath) {
        getLiveMatchesVC().reloadRows(at: [indexPath], with: .automatic)
    }
    
    //reloadData вызывает заново у TableView мтетоды подсчёта колличества рядов и создание каждой ячейки
    func reloadData() {
        spinnerStopAnimating()
        getLiveMatchesVC().reloadData()
    }
    
    //метод обновления всех ячеек с лайв матчами если матчей > 0
    func updateLiveMatchesTVCells() {
        spinnerStopAnimating()
        
        if let matchesCount = getMatchesModel().liveCsMatchesInfo?.count,
            matchesCount > 0 {
            getLiveMatchesVC().hideNoMatchesMessage()
            reloadData()
        } else {
            getLiveMatchesVC().showNoMatchesMessage()
        }
    }
    
    //возвращает View типа View лайв матчей,сделано чтобы не приводить искуственно при каждой надобности использовать
    func getLiveMatchesVC() -> AllMatchesTableViewController {
        viewToPresent as! AllMatchesTableViewController
    }
    
    //возвращает Model типа MatchesInfoModel,сделано чтобы не приводить искуственно при каждой надобности использовать
    func getMatchesModel() -> MatchesInfoModel {
        model as! MatchesInfoModel
    }
    
    //остановить спинер означающий подгрузку лайв матчей
    func spinnerStopAnimating() {
        getLiveMatchesVC().spinnerStopAnimating()
    }
    
    //
    func spinnerStartAnimating() {
        getLiveMatchesVC().spinnerStartAnimating()
    }
}
