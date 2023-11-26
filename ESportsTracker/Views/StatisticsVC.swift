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
    
    var filterBeginningDate: Date?
    var filterEndingDate: Date?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = StatisticsPresenter(model: MyBetsModel.shared,viewToPresent: self)
        (presenter as! StatisticsPresenter).setModelPresenter(newPresenter: presenter!)
        (presenter as! StatisticsPresenter).fetchBets()
        statisticBetsTableView.rowHeight = 230
        statisticBetsTableView.dataSource = self
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //колличество строк в TableView == колличеству лайв кс матчей в модели
        print((presenter as! StatisticsPresenter).getBetsCount())
        return (presenter as! StatisticsPresenter).getBetsCount()
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "MyBetCell", for: indexPath)
        //заполняем созданную ячейку внутри презентера лайв матчей,
        //тк у view нет доступа кнапрямую к модели
        
        cell = (presenter as! StatisticsPresenter).fillStatisticCellMatch(cellToFill: cell, cellForRowAt: indexPath)
        return cell
    }
    
    func findSelectedBets() {
        if let beginDate = filterBeginningDate,
           let endDate = filterEndingDate {
            (presenter as! StatisticsPresenter).findSelectedBets(inDates: DateInterval(start: beginDate, end: endDate))
            statisticBetsTableView.reloadData()
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
 
    @IBAction func changedBeginFilterDate(_ sender: UIDatePicker) {
        self.filterBeginningDate = sender.date
        self.findSelectedBets()
    }
    
    @IBAction func changedEndFilterDate(_ sender: UIDatePicker) {
        self.filterEndingDate = sender.date
        self.findSelectedBets()
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
