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
    
    //установить презентер пользующийся моделью на данный момент
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
    func updateRows(rowsToUpdate indexPath: IndexPath) {
        if let presenter = presenter as? LiveMatchPresenter {
            presenter.updateRows(rowsToUpdate: indexPath)
        }
    }
    
    //вернет по порядковому номеру ячейки идущий матч по кс,с таким же порядковым номером ячейки массива
    func getSelectedCsMatch(forIndex index: Int) -> Event{
        liveCsMatchesInfo![index]
    }
}
