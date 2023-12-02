//
//  NewsVC.swift
//  ESportsTracker
//
//  Created by f1nch on 28.11.23.
//

import UIKit

class NewsVC: UIViewController,UITableViewDataSource,UICollectionViewDataSource ,View {
    
    var presenter: Presenter?
    @IBOutlet weak var newsTableView: UITableView!
    @IBOutlet weak var upcomingMatchesCollectionView: UICollectionView!
    @IBOutlet var newsLoadingSpinner: UIActivityIndicatorView?
    @IBOutlet var matchesLoadingSpinner: UIActivityIndicatorView?
    
    override func loadView() {
        super.loadView()
        
        newsLoadingSpinner = UIActivityIndicatorView(style: .medium)
        self.newsTableView.backgroundView = newsLoadingSpinner
        
        matchesLoadingSpinner = UIActivityIndicatorView(style: .medium)
        self.upcomingMatchesCollectionView.backgroundView = matchesLoadingSpinner
        
        self.matchesSpinnerStartAnimating()
        self.newsSpinnerStartAnimating()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = NewsPresenter(newsModel: NewsModel.shared, upcomingMatchesModel: MatchesInfoModel.shared, viewToPresent: self)
        (presenter as! NewsPresenter).getNews()
        (presenter as! NewsPresenter).getUpcomingMatches()
        newsTableView.dataSource = self
        upcomingMatchesCollectionView.dataSource = self
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
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let count = (presenter as! NewsPresenter).getUpcomingCount()
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell = upcomingMatchesCollectionView.dequeueReusableCell(withReuseIdentifier: "UpcomingMatchCell", for: indexPath)
        //заполняем созданную ячейку внутри презентера лайв матчей,
        //тк у view нет доступа кнапрямую к модели
        if let newsPresenter = (presenter as? NewsPresenter) {
            cell = newsPresenter.fillUpcomingMatchCell(cellToFill: cell, cellForRowAt: indexPath)
        }
        
        return cell
    }
    
    func matchesSpinnerStartAnimating() {
        matchesLoadingSpinner!.startAnimating()
        matchesLoadingSpinner!.isHidden = false
    }
    
    //выключить крутилку означающую загрузку данных о матчах
    func matchesSpinnerStopAnimating() {
        matchesLoadingSpinner!.stopAnimating()
        matchesLoadingSpinner!.isHidden = true
    }
    
    func newsSpinnerStartAnimating() {
        newsLoadingSpinner!.startAnimating()
        newsLoadingSpinner!.isHidden = false
    }
    
    //выключить крутилку означающую загрузку данных о матчах
    func newsSpinnerStopAnimating() {
        newsLoadingSpinner!.stopAnimating()
        newsLoadingSpinner!.isHidden = true
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
