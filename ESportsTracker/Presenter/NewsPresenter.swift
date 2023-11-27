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
    }
    
    func setModelPresenter(newPresenter: Presenter) {
        (model as! NewsModel).setPresenter(newPresenter: newPresenter)
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
    
    func getBetsCount() -> Int {
        (model as! NewsModel).news?.data?.count ?? 0
    }
    
    func updateNewsCells() {
        if let view = viewToPresent as? NewsVC,
           let news = (model as? NewsModel)?.news?.data,
           news.count > 0
        {
            view.newsTableView.reloadData()
        }
    }
}
