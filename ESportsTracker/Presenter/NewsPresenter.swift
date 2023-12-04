//
//  NewsPresenter.swift
//  ESportsTracker
//
//  Created by f1nch on 28.11.23.
//

import Foundation
import UIKit

class NewsPresenter: Presenter {
    var model: Model//news model
    var upcomingMatchesModel: Model//upcomingMatches model
    var viewToPresent: View
    
    init(newsModel model: Model,upcomingMatchesModel: Model,viewToPresent: View) {
        self.model = model
        self.upcomingMatchesModel = upcomingMatchesModel
        self.viewToPresent = viewToPresent
    }
    
    //обновить все новости
    func getNews() {
        getNewsModel().getNews()
    }
    
    //обновить все ближайшие матчи
    func getUpcomingMatches() {
        getMatchesModel().updateUpcomingMatches()
    }
    
    //заполнить ячейку таблицы с новостями
    func fillNewsCell(cellToFill: UITableViewCell,cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = cellToFill as! NewsCell
        
        if let article = getNewsModel().news?.data?[indexPath.row] {
            cell.articleHeaderLabel.text = article.title ?? "Article header"
        }
        
        return cell
    }
    
    //заполнить ячейку таблицы с ближайшими матчами
    func fillUpcomingMatchCell(cellToFill: UICollectionViewCell,cellForRowAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = cellToFill as! UpcomingMatchCell
        
        if let match = getMatchesModel().upcomingCsMatches?[indexPath.row] {
            cell.homeTeamNameLabel.text = match.homeTeam?.name ?? "unknown team"
            cell.awayTeamNameLabel.text = match.awayTeam?.name ?? "unkown team"
        }
        
        return cell
    }
    
    //получить колличество новостей
    func getNewsCount() -> Int {
        getNewsModel().news?.data?.count ?? 0
    }
    
    //получить колличество ближайших матчей
    func getUpcomingCount() -> Int {
        getMatchesModel().upcomingCsMatches?.count ?? 0
    }
    
    //обновить таблицу с новостями
    func updateNewsCells() {
        getNewsVC().newsSpinnerStopAnimating()
        
        if let news = getNewsModel().news?.data,
            news.count > 0
        {
            reloadNewsData()
        }
    }
    
    //обновить коллекцию ближайших матчей
    func updateUpcomingMatchesCells() {
        getNewsVC().matchesSpinnerStopAnimating()
        
        if let upcomingMatches = getMatchesModel().upcomingCsMatches,
            upcomingMatches.count > 0
        {
            getNewsVC().upcomingMatchesCollectionView.reloadData()
        }
    }
    
    //возвращает Model типа NewsModel,сделано чтобы не приводить искуственно при каждой надобности использовать
    func getNewsModel() -> NewsModel {
        model as! NewsModel
    }
    
    //возвращает Model типа MatchesModel,сделано чтобы не приводить искуственно при каждой надобности использовать
    func getMatchesModel() -> MatchesInfoModel {
        upcomingMatchesModel as! MatchesInfoModel
    }
    
    //возвращает View типа View статистики ставок,сделано чтобы не приводить искуственно при каждой надобности использовать
    func getNewsVC() -> NewsVC {
        viewToPresent as! NewsVC
    }
    
    //reloadData вызывает заново у TableView мтетоды подсчёта колличества рядов и создание каждой ячейки
    func reloadNewsData() {
        getNewsVC().newsTableView.reloadData()
    }
    
    //reloadData вызывает заново у TableView мтетоды подсчёта колличества рядов и создание каждой ячейки
    func reloadUpcomingMatchesData() {
        getNewsVC().upcomingMatchesCollectionView.reloadData()
    }
}
