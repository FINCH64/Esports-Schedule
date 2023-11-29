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
    
    func getArticle(forSelectedIndex index: IndexPath?) -> Article? {
        if let index = index {
            let a = (model as? NewsModel)?.news?.data?[index.row]
            return a
        }
        return nil
    }
}
