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
    var upcomingMatchesModel: Model//upcomingMatches model
    var viewToPresent: View
    
    init(newsModel model: Model,upcomingMatchesModel: Model,viewToPresent: View) {
        self.model = model
        self.upcomingMatchesModel = upcomingMatchesModel
        self.viewToPresent = viewToPresent
    }
    
    func getNews() {
        (model as! NewsModel).getNews()
    }
    
    func getUpcomingMatches() {
        (upcomingMatchesModel as! MatchesInfoModel).updateUpcomingMatches()
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
        
        if let match = (upcomingMatchesModel as! MatchesInfoModel).upcomingCsMatches?[indexPath.row] {
            cell.homeTeamNameLabel.text = match.homeTeam?.name ?? "unknown team"
            cell.awayTeamNameLabel.text = match.awayTeam?.name ?? "unkown team"
        }
        
        return cell
    }
    
    func getBetsCount() -> Int {
        (model as! NewsModel).news?.data?.count ?? 0
    }
    
    func getUpcomingCount() -> Int {
        (upcomingMatchesModel as! MatchesInfoModel).upcomingCsMatches?.count ?? 0
    }
    
    func updateNewsCells() {
        if let view = viewToPresent as? NewsVC {
            view.newsSpinnerStopAnimating()
            if let news = NewsModel.shared.news?.data,
               news.count > 0
            {
                view.newsTableView.reloadData()
            }
        }
    }
    
    func updateUpcomingMatchesCells() {
        if let view = viewToPresent as? NewsVC {
            view.matchesSpinnerStopAnimating()
            if let upcomingMatches = (upcomingMatchesModel as! MatchesInfoModel).upcomingCsMatches,
                upcomingMatches.count > 0
            {
                view.upcomingMatchesCollectionView.reloadData()
            }
        }
    }
}
