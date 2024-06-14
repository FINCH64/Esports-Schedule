//
//  MyBetsVC.swift
//  ESportsTracker
//
//  Created by f1nch on 15.4.24.
//

import UIKit

class LiveBetsVC: UIViewController,UITableViewDataSource,View {
    var presenter: Presenter?
    
    @IBOutlet weak var betsTableView: UITableView!
    @IBOutlet var spinner: UIActivityIndicatorView?
    @IBOutlet var noLiveBetsLabel: UILabel?
    
    //при загрузке включим спинер,отображающийся пока подгружаются ставки пользователя
    override func loadView() {
        super.loadView()
        
        spinner = UIActivityIndicatorView(style: .medium)
        self.betsTableView.backgroundView = spinner
        self.spinnerStartAnimating()
        
        noLiveBetsLabel = UILabel(frame: CGRect(x: 41, y: 383, width: 310, height: 76))
        noLiveBetsLabel!.font = UIFont.boldSystemFont(ofSize: 25)
        noLiveBetsLabel!.text = "No live bets 🥳"
        noLiveBetsLabel!.textAlignment = NSTextAlignment.center
        noLiveBetsLabel!.textColor = UIColor.white
        noLiveBetsLabel!.isHidden = true
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
        return getLiveBetsCount()
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "MyBetCell", for: indexPath)

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
        self.betsTableView.backgroundView = noLiveBetsLabel
        spinner!.stopAnimating()
        spinner!.isHidden = true
    }
    
    //показать сообщение если нет активных матчей
    func showNoBetsMessage() {
        noLiveBetsLabel?.isHidden = false
        self.betsTableView.backgroundView = noLiveBetsLabel
    }
    
    //скрыть сообщение если матчи появились
    func hideNoBetsMessage() {
        noLiveBetsLabel?.isHidden = true
        self.betsTableView.backgroundView = spinner
    }
    
    //возвращает презентер типа презентера лайв ставок,сделано чтобы не приводить искуственно при каждой надобности использовать презентер
    func getLiveBetsPresenter() -> LiveBetsPresenter {
        presenter as! LiveBetsPresenter
    }

    //обновить данные о ставках пользователя
    func fetchBets() {
        hideNoBetsMessage()
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
