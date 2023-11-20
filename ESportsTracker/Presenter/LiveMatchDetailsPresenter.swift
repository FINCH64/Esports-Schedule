//
//  LiveMatchDetailsPresenter.swift
//  ESportsTracker
//
//  Created by f1nch on 20.11.23.
//

import Foundation

class LiveMatchDetailsPresenter: Presenter {
    var model: Model
    var viewToPresent: View
    
    init(model: Model, viewToPresent: View) {
        self.model = model
        self.viewToPresent = viewToPresent
    }
    
    //возвращает выбранный идущий кс матч
    func getSelectedMatch(forIndex index: Int) -> Event {
        (model as! MatchesInfoModel).liveCsMatchesInfo![index]
    }
    
    func updateData() {
        MatchesInfoManager.shared.updateAllCurrentLiveMatches(updateAllMatchesTable: true)
    }
}
