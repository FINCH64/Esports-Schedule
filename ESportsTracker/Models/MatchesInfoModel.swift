//
//  MatchesInfoModel.swift
//  ESportsTracker
//
//  Created by f1nch on 17.11.23.
//

import Foundation

//модель данных где хранится вся информация об идущих матчах
//у модели с этими данными может меняться презентер при переходах на другой экран,
//для этого есть setPresenterForModel у свойства shared у модели
class MatchesInfoModel: Model {

    static let shared = MatchesInfoModel()
    
    var presenter: Presenter?
    
    private init() {}
    
    
    var liveMatchesInfo: LiveMatches?
    var liveCsMatchesInfo : [Event]?
    var selectedLiveMatch: Event?
    
    func setPresenterForModel(newPresenter: Presenter) {
        self.presenter = newPresenter
    }
    
    //после загрузки данных вызывается для обновления UITableView ячеек,но только если презентер модели в данный момент это TableView
    //вызывается из менджера матчей,вызывает метод обновления в presenter
    func updateTVLiveMatchesCells() {
        if let presenter = presenter as? LiveMatchPresenter {
            presenter.updateLiveMatchesTVCells()
        }
    }
    
    //после подшрузки картинки вызывает метод обновления у презенткра,ограничения такие же как у updateTVLiveMatchesCells()
    func updateCellsTeamImages(imageData: Data,indexPath: IndexPath,logoTeamId: Int) {
        if let presenter = presenter as? LiveMatchPresenter {
            presenter.updateCellsTeamImages(imageData: imageData,indexPath: indexPath,logoTeamId: logoTeamId)
        }
    }
}
