//
//  NewsVC.swift
//  ESportsTracker
//
//  Created by f1nch on 28.11.23.
//

import UIKit

class NewsVC: UIViewController,UITableViewDataSource,View {
    var presenter: Presenter?
    @IBOutlet weak var newsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = NewsPresenter(model: NewsModel.shared,viewToPresent: self)
        (presenter as! NewsPresenter).setModelPresenter(newPresenter: presenter!)
        (presenter as! NewsPresenter).getNews()
        newsTableView.dataSource = self
        
        newsTableView.rowHeight = 50
    }

    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        (presenter as? NewsPresenter)?.getBetsCount() ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "NewsCell", for: indexPath)
        //заполняем созданную ячейку внутри презентера лайв матчей,
        //тк у view нет доступа кнапрямую к модели
        if let newsPresenter = (presenter as? NewsPresenter) {
            cell = newsPresenter.fillNewsCell(cellToFill: cell, cellForRowAt: indexPath)
        }
        
        cell = (presenter as! NewsPresenter).fillNewsCell(cellToFill: cell, cellForRowAt: indexPath)
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowFullArticle" {
            if let indexPath = newsTableView.indexPathForSelectedRow {
                let detailVC = segue.destination as! NewsDetailsVC
                detailVC.articleSelectedRowIndex = indexPath
            }
        }
    }
}
