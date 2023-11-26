//
//  MyBetsVC.swift
//  ESportsTracker
//
//  Created by f1nch on 21.11.23.
//

import UIKit

class MyBetsVC: UIViewController,UITableViewDataSource,View {
    var presenter: Presenter?
    
    @IBOutlet weak var betsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = MyBetsPresenter(model: MyBetsModel.shared,viewToPresent: self)
        (presenter as! MyBetsPresenter).setModelPresenter(newPresenter: presenter!)
        (presenter as! MyBetsPresenter).fetchBets()
        betsTableView.rowHeight = 230
        betsTableView.dataSource = self
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //колличество строк в TableView == колличеству лайв кс матчей в модели
        print((presenter as! MyBetsPresenter).getLiveBetsCount())
        return (presenter as! MyBetsPresenter).getLiveBetsCount()
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "MyBetCell", for: indexPath)
        //заполняем созданную ячейку внутри презентера лайв матчей,
        //тк у view нет доступа кнапрямую к модели
        
        cell = (presenter as! MyBetsPresenter).fillCellLiveMatch(cellToFill: cell, cellForRowAt: indexPath)
        return cell
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
