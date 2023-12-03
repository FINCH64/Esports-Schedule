//
//  MyBetsVC.swift
//  ESportsTracker
//
//  Created by f1nch on 21.11.23.
//

import UIKit

class LiveBetsVC: UIViewController,UITableViewDataSource,View {
    var presenter: Presenter?
    
    @IBOutlet weak var betsTableView: UITableView!
    @IBOutlet var spinner: UIActivityIndicatorView?
    
    //при загрузке включим спинер,отображающийся пока подгружаются ставки пользователя
    override func loadView() {
        super.loadView()
        
        spinner = UIActivityIndicatorView(style: .medium)
        self.betsTableView.backgroundView = spinner
        self.spinnerStartAnimating()
    }
    
    //установим высоту ряда таблицы всех матчей,сделано тк оно неверно считывало её со сториборда и ломалась,
    //укажем что этот класс и есть источник данных таблицы идущих ставок
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = LiveBetsPresenter(model: MyBetsModel.shared,viewToPresent: self)
        fetchBets()
        betsTableView.rowHeight = 230
        betsTableView.dataSource = self
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //колличество строк в TableView == колличеству лайв ставок в модели
        return getLiveBetsCount()
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "MyBetCell", for: indexPath)
        //заполняем созданную ячейку внутри презентера лайв матчей,
        //тк у view нет доступа кнапрямую к модели
        
        cell = fillCellLiveMatch(cellToFill: cell, cellForRowAt: indexPath)
        return cell
    }
    
    //включить крутилку означающую загрузку данных о матчах
    func spinnerStartAnimating() {
        spinner!.startAnimating()
        spinner!.isHidden = false
    }
    
    //выключить крутилку означающую загрузку данных о матчах
    func spinnerStopAnimating() {
        spinner!.stopAnimating()
        spinner!.isHidden = true
    }
    
    //возвращает презентер типа презентера лайв ставок,сделано чтобы не приводить искуственно при каждой надобности использовать презентер
    func getLiveBetsPresenter() -> LiveBetsPresenter {
        presenter as! LiveBetsPresenter
    }

    //обновить данные о ставках пользователя
    func fetchBets() {
        getLiveBetsPresenter().fetchBets()
    }
    
    //получить колличество идущих ставок
    func getLiveBetsCount() -> Int {
        getLiveBetsPresenter().getLiveBetsCount()
    }
    
    //заполнить ячейку таблицы с идущими ставками
    func fillCellLiveMatch(cellToFill: UITableViewCell, cellForRowAt: IndexPath) -> UITableViewCell {
        getLiveBetsPresenter().fillCellLiveMatch(cellToFill: cellToFill, cellForRowAt: cellForRowAt)
    }
}
