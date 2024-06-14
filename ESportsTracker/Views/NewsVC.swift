//
//  NewsVC.swift
//  ESportsTracker
//
//  Created by f1nch on 11.5.24.
//

import UIKit

class NewsVC: UIViewController,UITableViewDataSource,UICollectionViewDataSource ,View {
    
    var presenter: Presenter?
    @IBOutlet weak var newsTableView: UITableView!
    @IBOutlet weak var upcomingMatchesCollectionView: UICollectionView!
    @IBOutlet var newsLoadingSpinner: UIActivityIndicatorView?
    @IBOutlet var matchesLoadingSpinner: UIActivityIndicatorView?
    @IBOutlet var noNewsLabel: UILabel?
    @IBOutlet var noUpcomingMatchesLabel: UILabel?
    
    //при загрузке включим 2 спинера,отображающиеся пока подгружаются новости и ближайшие матчи
    override func loadView() {
        super.loadView()
        
        noNewsLabel = UILabel(frame: CGRect(x: 41, y: 383, width: 310, height: 76))
        noNewsLabel!.font = UIFont.boldSystemFont(ofSize: 25)
        noNewsLabel!.text = "No discussions 🧐"
        noNewsLabel!.textAlignment = NSTextAlignment.center
        noNewsLabel!.textColor = UIColor.white
        noNewsLabel!.isHidden = true
        
        noUpcomingMatchesLabel = UILabel(frame: CGRect(x: 41, y: 383, width: 310, height: 76))
        noUpcomingMatchesLabel!.font = UIFont.boldSystemFont(ofSize: 25)
        noUpcomingMatchesLabel!.text = "No matches tommorow 👀"
        noUpcomingMatchesLabel!.textAlignment = NSTextAlignment.center
        noUpcomingMatchesLabel!.textColor = UIColor.white
        noUpcomingMatchesLabel!.isHidden = true
        
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
    
    //показать сообщение если нет ближайщих матчей
    func showNoMatchesMessage() {
        noUpcomingMatchesLabel?.isHidden = false
        self.upcomingMatchesCollectionView.backgroundView = noUpcomingMatchesLabel
    }
    
    //скрыть сообщение если матчи появились
    func hideNoMatchesMessage() {
        noUpcomingMatchesLabel?.isHidden = true
        self.upcomingMatchesCollectionView.backgroundView = matchesLoadingSpinner
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
    
    //показать сообщение если нет новостей
    func showNoNewsMessage() {
        noNewsLabel?.isHidden = false
        self.newsTableView.backgroundView = noNewsLabel
    }
    
    //скрыть сообщение если новости появились
    func hideNoNewsMessage() {
        noNewsLabel?.isHidden = true
        self.newsTableView.backgroundView = newsLoadingSpinner
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
