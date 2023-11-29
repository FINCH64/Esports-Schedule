//
//  NewsPresenter.swift
//  ESportsTracker
//
//  Created by f1nch on 28.11.23.
//

import Foundation
import UIKit

class NewsPresenter: Presenter {
    var model: Model
    var viewToPresent: View
    
    init(model: Model, viewToPresent: View) {
        self.model = model
        self.viewToPresent = viewToPresent
        setMatchesModelPresenter(newPresenter: self)
    }
    
    func setNewsModelPresenter(newPresenter: Presenter) {
        (model as! NewsModel).setPresenter(newPresenter: newPresenter)
    }
    
    func setMatchesModelPresenter(newPresenter: Presenter) {
        MatchesInfoModel.shared.setPresenterForModel(newPresenter: newPresenter)
    }
    
    func getNews() {
        if let model = model as? NewsModel {
            model.getNews()
        }
    }
    
    func fillNewsCell(cellToFill: UITableViewCell,cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = cellToFill as! NewsCell
        
        if let article = (model as? NewsModel)?.news?.data?[indexPath.row] {
            cell.articleHeaderLabel.text = article.title ?? "Article header"
        }
        
        return cell
    }
    
    func fillUpcomingMatchCell(cellToFill: UICollectionViewCell,cellForRowAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = cellToFill as! UpcomingMatchCell
        
        if let match = MatchesInfoModel.shared.upcomingCsMatches?[indexPath.row] {
            cell.homeTeamNameLabel.text = match.homeTeam?.name ?? "unknown team"
            cell.awayTeamNameLabel.text = match.awayTeam?.name ?? "unkown team"
        }
        
        return cell
    }
    
    func getBetsCount() -> Int {
        (model as! NewsModel).news?.data?.count ?? 0
    }
    
    func getUpcomingCount() -> Int {
        MatchesInfoModel.shared.upcomingCsMatches?.count ?? 0
    }
    
    func updateNewsCells() {
        if let view = viewToPresent as? NewsVC,
           let news = NewsModel.shared.news?.data,
           news.count > 0
        {
            view.newsTableView.reloadData()
        }
    }
    
    func updateUpcomingMatchesCells() {
        if let view = viewToPresent as? NewsVC,
           let upcomingMatches = MatchesInfoModel.shared.upcomingCsMatches,
           upcomingMatches.count > 0
        {
            view.upcomingMatchesCollectionView.reloadData()
        }
    }
}
