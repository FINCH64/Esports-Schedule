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
    
    override func loadView() {
        super.loadView()
        
        spinner = UIActivityIndicatorView(style: .medium)
        spinner!.isHidden = true
        self.tableView.backgroundView = spinner
        spinner!.startAnimating()
        
        presenter = LiveMatchPresenter(viewToPresent: self, matchesModel: MatchesInfoModel.shared)
        (presenter as! LiveMatchPresenter).setModelPresenter(newPresenter: presenter!)
        (presenter as! LiveMatchPresenter).updateCurrentLiveMatches()
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.rowHeight = 123
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //колличество строк в TableView == колличеству лайв кс матчей в модели
        print((presenter as! LiveMatchPresenter).getCsMatchesCount())
        return (presenter as! LiveMatchPresenter).getCsMatchesCount()
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "MatchCell", for: indexPath)
        //заполняем созданную ячейку внутри презентера лайв матчей,
        //тк у view нет доступа кнапрямую к модели
        
        cell = (presenter as! LiveMatchPresenter).fillCellLiveMatch(cellToFill: cell, cellForRowAt: indexPath)
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

    // MARK: - Navigation
    
    //проверка на переход к экрану с полной информацией и передача в него матча
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowMatchDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let detailVC = segue.destination as! LiveMatchDetailsVC
                detailVC.matchIndex = indexPath
            }
        }
    }
    

    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

}
