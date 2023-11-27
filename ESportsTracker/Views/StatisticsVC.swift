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
    
    var filterBeginningDate: Date?
    var filterEndingDate: Date?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let weekIntervalInSeconds: Double = 604800
        let dateMinusWeekInSeconds = Date().timeIntervalSince1970 - weekIntervalInSeconds
        
        presenter = StatisticsPresenter(model: MyBetsModel.shared,viewToPresent: self)
        (presenter as! StatisticsPresenter).setModelPresenter(newPresenter: presenter!)
        (presenter as! StatisticsPresenter).fetchBets()
        beginDateFilterPicker.date = Date(timeIntervalSince1970: dateMinusWeekInSeconds)
        filterBeginningDate = beginDateFilterPicker.date
        filterEndingDate = endDateFilterPicking.date
        statisticBetsTableView.rowHeight = 230
        statisticBetsTableView.dataSource = self
        
        findSelectedBets(beginSearcDate: filterBeginningDate, endSearchDate: filterEndingDate)
        statisticBetsTableView.reloadData()
        
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //колличество строк в TableView == колличеству лайв кс матчей в модели
        return (presenter as! StatisticsPresenter).getBetsCount()
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "MyBetCell", for: indexPath)
        //заполняем созданную ячейку внутри презентера лайв матчей,
        //тк у view нет доступа кнапрямую к модели
        
        cell = (presenter as! StatisticsPresenter).fillStatisticCellMatch(cellToFill: cell, cellForRowAt: indexPath)
        return cell
    }
    
    func findSelectedBets(beginSearcDate beginDate: Date?,endSearchDate endDate: Date?) {
        if let beginDate = filterBeginningDate,
           let endDate = filterEndingDate
        {
            if beginDate <= endDate {
                let searchInterval = DateInterval(start: beginDate, end: endDate)
                (presenter as! StatisticsPresenter).findSelectedBets(inDates: searchInterval)
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
    
    func setBetsWon(wonCount: String?) {
        betWonCounterLabel.text = wonCount ?? "unknown"
    }
    
    func setBetsLost(lostCount: String?) {
        betLostCounterLabel.text = lostCount ?? "unknown"
    }
    
    func setOverallIncome(overallIncome: String?) {
        overallIncomeLabel.text = overallIncome ?? "unknown"
    }
 
    @IBAction func beginFilterDateClosed(_ sender: UIDatePicker) {
        self.filterBeginningDate = sender.date
        findSelectedBets(beginSearcDate: filterBeginningDate, endSearchDate: filterEndingDate)
    }
    
    @IBAction func endFilterDateClosed(_ sender: UIDatePicker) {
        self.filterEndingDate = sender.date
        findSelectedBets(beginSearcDate: filterBeginningDate, endSearchDate: filterEndingDate)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
