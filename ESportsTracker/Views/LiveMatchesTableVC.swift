//
//  AllMatchesTableViewController.swift
//  ESportsTracker
//
//  Created by f1nch on 15.11.23.
//

import UIKit

class AllMatchesTableViewController: UITableViewController,MatchView {
        
    var presenter: Presenter?
    @IBOutlet var spinner: UIActivityIndicatorView?
    
    //при загрузке установим крутилку пока матчи грузятся + установим презентер модели,
    override func loadView() {
        super.loadView()
        
        spinner = UIActivityIndicatorView(style: .medium)
        spinner!.isHidden = true
        self.tableView.backgroundView = spinner
        spinner!.startAnimating()
        
        presenter = LiveMatchPresenter(viewToPresent: self, matchesModel: MatchesInfoModel.shared)
        setModelPresenter(newPresenter: presenter)
        updateCurrentLiveMatches()
    }
    
    //установим высоту ряда таблицы всех матчей,сделано тк оно неверно считывало её со сториборда и ломалась
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.rowHeight = 123
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    //кол-во рядов таблицы = количеству лайв матчей кс в MatchesInfoModel
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //колличество строк в TableView == колличеству лайв кс матчей в модели
        return getLiveMatchPresenter().getCsMatchesCount()
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "MatchCell", for: indexPath)
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

    //возвращает презентер типа презентера лайв матчей,сделано чтобы не приводить искуственно при каждой надобности использовать презентер
    func getLiveMatchPresenter() -> LiveMatchPresenter {
        presenter as! LiveMatchPresenter
    }
    
    //установить презентер модели
    //он устанавливается только на этом экране,тк он выбран в TabBar controller по умолчанию,в дальнейшем презентеры моделей устанавливаются в классе навигатора
    func setModelPresenter(newPresenter: Presenter?) {
        getLiveMatchPresenter().setModelPresenter(newPresenter: newPresenter!)
    }
    
    //обновить список идущих матчей
    func updateCurrentLiveMatches() {
        getLiveMatchPresenter().updateCurrentLiveMatches()
    }
    
    //заполнить ячейку таблицы списка идущих матчей
    func fillCellLiveMatch(cellToFill: UITableViewCell, cellForRowAt: IndexPath) -> UITableViewCell{
        getLiveMatchPresenter().fillCellLiveMatch(cellToFill: cellToFill, cellForRowAt: cellForRowAt)
    }
    
    //функция обновления картинок в уже созданных ячейках матчей,вызывается по загрузке картинок с сервера
    func reloadRows(at: [IndexPath], with: UITableView.RowAnimation) {
        tableView.reloadRows(at: at, with: with)
    }
    
    //функий перерисовки всей таблицы лайв матчей,вызывается после загрузки лайв матчей
    func reloadData() {
        tableView.reloadData()
    }
    
    
    // MARK: - Navigation
    
    //проверка на переход к экрану с полной информацией и передача в него матча
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowMatchDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let detailVC = segue.destination as! LiveMatchDetailsVC
                detailVC.matchIndex = indexPath
            }
        }
    }
}
