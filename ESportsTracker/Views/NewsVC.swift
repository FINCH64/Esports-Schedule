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
    
    //при загрузке включим 2 спинера,отображающиеся пока подгружаются новости и ближайшие матчи
    override func loadView() {
        super.loadView()
        
        newsLoadingSpinner = UIActivityIndicatorView(style: .medium)
        self.newsTableView.backgroundView = newsLoadingSpinner
        
        matchesLoadingSpinner = UIActivityIndicatorView(style: .medium)
        self.upcomingMatchesCollectionView.backgroundView = matchesLoadingSpinner
        
        self.matchesSpinnerStartAnimating()
        self.newsSpinnerStartAnimating()
    }
    
    //после загрузки обновим новости и ближайшие матчи,указано что источником данных обоих списков будет этот класс
    //установим высоту ряда таблицы всех матчей,сделано тк оно неверно считывало её со сториборда и ломалась,
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = NewsPresenter(newsModel: NewsModel.shared, upcomingMatchesModel: MatchesInfoModel.shared, viewToPresent: self)
        getNews()
        getUpcomingMatches()
        
        newsTableView.dataSource = self
        upcomingMatchesCollectionView.dataSource = self
        
        newsTableView.rowHeight = 50
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        getNewsCount()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "NewsCell", for: indexPath)
        cell = fillNewsCell(cellToFill: cell, cellForRowAt: indexPath)

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        getUpcomingCount()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell = upcomingMatchesCollectionView.dequeueReusableCell(withReuseIdentifier: "UpcomingMatchCell", for: indexPath)
        cell = fillUpcomingMatchCell(cellToFill: cell, cellForRowAt: indexPath)
        
        return cell
    }
    
    //включить крутилку означающую загрузку данных о ближайших матчах
    func matchesSpinnerStartAnimating() {
        matchesLoadingSpinner!.startAnimating()
        matchesLoadingSpinner!.isHidden = false
    }
    
    //выключить крутилку означающую загрузку данных о ближайших матчах
    func matchesSpinnerStopAnimating() {
        matchesLoadingSpinner!.stopAnimating()
        matchesLoadingSpinner!.isHidden = true
    }
    
    //включить крутилку означающую загрузку данных о новостях
    func newsSpinnerStartAnimating() {
        newsLoadingSpinner!.startAnimating()
        newsLoadingSpinner!.isHidden = false
    }
    
    //выключить крутилку означающую загрузку данных о новостях
    func newsSpinnerStopAnimating() {
        newsLoadingSpinner!.stopAnimating()
        newsLoadingSpinner!.isHidden = true
    }
    
    //при нажатии на новость передадим её индекс в модели(совпадает с индексом ряда) во view с её деталями
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowFullArticle" {
            if let indexPath = newsTableView.indexPathForSelectedRow {
                let detailVC = segue.destination as! NewsDetailsVC
                detailVC.articleSelectedRowIndex = indexPath
            }
        }
    }
    
    //возвращает презентер типа презентера новостей,сделано чтобы не приводить искуственно при каждой надобности использовать презентер
    func getNewsPresenter() -> NewsPresenter {
        presenter as! NewsPresenter
    }
    
    //метод обновления новостей
    func getNews() {
        getNewsPresenter().getNews()
    }
    
    //метод обновления будущих матчей
    func getUpcomingMatches() {
        getNewsPresenter().getUpcomingMatches()
    }
    
    //получить колличество новостей в модели
    func getNewsCount() -> Int {
        getNewsPresenter().getNewsCount()
    }
    
    //заполнить ячейку TableView с новостью
    func fillNewsCell(cellToFill: UITableViewCell, cellForRowAt: IndexPath) -> UITableViewCell {
        getNewsPresenter().fillNewsCell(cellToFill: cellToFill, cellForRowAt: cellForRowAt)
    }
    
    //получить колличество ближайших матчей в модели
    func getUpcomingCount() -> Int {
        getNewsPresenter().getUpcomingCount()
    }
    
    //заполнить ячейку CollectionView c ближайшими матчами
    func fillUpcomingMatchCell(cellToFill: UICollectionViewCell, cellForRowAt: IndexPath) -> UICollectionViewCell {
        getNewsPresenter().fillUpcomingMatchCell(cellToFill: cellToFill, cellForRowAt: cellForRowAt)
    }
}
