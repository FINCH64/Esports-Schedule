//
//  NewsDetailsPresenter.swift
//  ESportsTracker
//
//  Created by f1nch on 28.11.23.
//

import Foundation

class NewsDetailsPresenter: Presenter {
    var model: Model
    var viewToPresent: View
    
    init(model: Model, viewToPresent: View) {
        self.model = model
        self.viewToPresent = viewToPresent
    }
    
    //вернуть новсть по её индексу для отрисовки во View
    func getArticle(forSelectedIndex index: IndexPath?) -> Article? {
        if let index = index {
            return (model as? NewsModel)?.news?.data?[index.row]
        }
        return nil
    }
}
