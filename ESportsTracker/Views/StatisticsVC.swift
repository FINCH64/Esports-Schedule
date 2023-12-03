//
//  StatisticsVC.swift
//  ESportsTracker
//
//  Created by f1nch on 26.11.23.
//

import UIKit

class StatisticsVC: UIViewController,UITableViewDataSource,View {
    var presenter: Presenter?
    @IBOutlet weak var beginDateFilterPicker: UIDatePicker!
    @IBOutlet weak var endDateFilterPicking: UIDatePicker!
    @IBOutlet weak var betWonCounterLabel: UILabel!
    @IBOutlet weak var betLostCounterLabel: UILabel!
    @IBOutlet weak var overallIncomeLabel: UILabel!
    @IBOutlet weak var statisticBetsTableView: UITableView!
    @IBOutlet var statisticsView: UIView!
    @IBOutlet var spinner: UIActivityIndicatorView?
    
    var filterBeginningDate: Date?
    var filterEndingDate: Date?

    //при загрузке включим спинер,отображающийся пока подгружаются ставки пользователя
    override func loadView() {
        super.loadView()
        
        spinner = UIActivityIndicatorView(style: .medium)
        self.statisticBetsTableView.backgroundView = spinner
        self.spinnerStartAnimating()
    }
    
    //установим высоту ряда таблицы всех матчей,сделано тк оно неверно считывало её со сториборда и ломалась,
    //укажем что этот класс и есть источник данных таблицы ставок
    //считаем показатели фильтров по дате и установим нижнюю границу фильтра на текущую дату минус неделя,обновим данные ставок,найдём ставки за последнюю неделю
    override func viewDidLoad() {
        super.viewDidLoad()
        let weekIntervalInSeconds: Double = 604800
        let dateMinusWeekInSeconds = Date().timeIntervalSince1970 - weekIntervalInSeconds
        
        presenter = StatisticsPresenter(model: MyBetsModel.shared,viewToPresent: self)
        fetchBets()
        
        beginDateFilterPicker.date = Date(timeIntervalSince1970: dateMinusWeekInSeconds)
        filterBeginningDate = beginDateFilterPicker.date
        filterEndingDate = endDateFilterPicking.date
        
        statisticBetsTableView.rowHeight = 230
        statisticBetsTableView.dataSource = self
        
        findSelectedBets(beginSearcDate: filterBeginningDate, endSearchDate: filterEndingDate)
        statisticBetsTableView.reloadData()
        
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //колличество строк в TableView == колличеству ставок в диапазоне
        return getBetsInSelectedRange()
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "MyBetCell", for: indexPath)
        //заполняем созданную ячейку внутри презентера лайв матчей,
        //тк у view нет доступа кнапрямую к модели
        
        cell = fillStatisticCellMatch(cellToFill: cell, cellForRowAt: indexPath)
        return cell
    }
    
    //найти ставки в выбранном диапазоне,результат не возвращается но сохраняется в модели
    func findSelectedBets(beginSearcDate beginDate: Date?,endSearchDate endDate: Date?) {
        if let beginDate = filterBeginningDate,
           let endDate = filterEndingDate
        {
            if beginDate <= endDate {
                let searchInterval = DateInterval(start: beginDate, end: endDate)
                findSelectedBets(inDates: searchInterval)
                statisticBetsTableView.reloadData()
            } else {
                let alertController = UIAlertController(title: "Wrong input", message: "Selected filter dates are incorrect.", preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
                alertController.addAction(cancelAction)
                self.presentedViewController?.dismiss(animated: false)
                present(alertController, animated: true)
            }
        }
    }
    
    //установить колличество выигранных ставок
    func setBetsWon(wonCount: String?) {
        betWonCounterLabel.text = wonCount ?? "unknown"
    }
    
    //установить колличество проиграных ставок
    func setBetsLost(lostCount: String?) {
        betLostCounterLabel.text = lostCount ?? "unknown"
    }
    
    //установить общую прибыль от ставок
    func setOverallIncome(overallIncome: Double) {
        switch overallIncome >= 0 {
        case true:
            overallIncomeLabel.textColor = .systemGreen
        case false:
            overallIncomeLabel.textColor = .systemRed
        }
        
        overallIncomeLabel.text = "\(overallIncome)"
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
    
    //при зыкрытии обновлении границ поиска найти все ставки в этом диапазоне
    @IBAction func beginFilterDateClosed(_ sender: UIDatePicker) {
        self.filterBeginningDate = sender.date
        findSelectedBets(beginSearcDate: filterBeginningDate, endSearchDate: filterEndingDate)
    }
    
    @IBAction func endFilterDateClosed(_ sender: UIDatePicker) {
        self.filterEndingDate = sender.date
        findSelectedBets(beginSearcDate: filterBeginningDate, endSearchDate: filterEndingDate)
    }

    //возвращает презентер типа презентера статистики ставок,сделано чтобы не приводить искуственно при каждой надобности использовать презентер
    func getStatisticsPresenter() -> StatisticsPresenter {
        presenter as! StatisticsPresenter
    }
    
    //обновить данные о всех ставках
    func fetchBets() {
        getStatisticsPresenter().fetchBets()
    }
    
    //получить колличество ставок в диапазоне
    func getBetsInSelectedRange() -> Int {
        getStatisticsPresenter().getBetsInSelectedRange()
    }
    
    //заполнить ячейку таблицы со статистикой ставок
    func fillStatisticCellMatch(cellToFill: UITableViewCell, cellForRowAt: IndexPath) -> UITableViewCell {
        getStatisticsPresenter().fillStatisticCellMatch(cellToFill: cellToFill, cellForRowAt: cellForRowAt)
    }
    
    //найти все ставки в предоставленном диапазоне
    func findSelectedBets(inDates: DateInterval) {
        getStatisticsPresenter().findSelectedBets(inDates: inDates)
    }
}
