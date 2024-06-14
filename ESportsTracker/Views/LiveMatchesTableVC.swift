//
//  AllMatchesTableViewController.swift
//  ESportsTracker
//
//  Created by f1nch on 5.4.24.
//

import UIKit

class AllMatchesTableViewController: UITableViewController,MatchView {
        
    var presenter: Presenter?
    @IBOutlet var spinner: UIActivityIndicatorView?
    @IBOutlet var noLiveMatchesLabel: UILabel?
    
    
    //при загрузке установим крутилку пока матчи грузятся + установим презентер модели,
    override func loadView() {
        super.loadView()
        
        spinner = UIActivityIndicatorView(style: .medium)
        spinner!.isHidden = true
        
        spinnerStartAnimating()
        
        noLiveMatchesLabel = UILabel(frame: CGRect(x: 41, y: 383, width: 310, height: 76))
        noLiveMatchesLabel!.font = UIFont.boldSystemFont(ofSize: 25)
        noLiveMatchesLabel!.text = "Matches are missing 😔"
        noLiveMatchesLabel!.textAlignment = NSTextAlignment.center
        noLiveMatchesLabel!.textColor = UIColor.white
        noLiveMatchesLabel!.isHidden = true
        
        
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
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor.clear
    }
    
    //включить крутилку означающую загрузку данных о матчах
    func spinnerStartAnimating() {
        self.tableView.backgroundView = spinner
        spinner!.startAnimating()
        spinner!.isHidden = false
    }
    
    //выключить крутилку означающую загрузку данных о матчах
    func spinnerStopAnimating() {
        self.tableView.backgroundView = noLiveMatchesLabel
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
        hideNoMatchesMessage()
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
    
    //показать сообщение если нет активных матчей
    func showNoMatchesMessage() {
        noLiveMatchesLabel?.isHidden = false
        self.tableView.backgroundView = noLiveMatchesLabel
    }
    
    //скрыть сообщение если матчи появились
    func hideNoMatchesMessage() {
        noLiveMatchesLabel?.isHidden = true
        self.tableView.backgroundView = spinner
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
