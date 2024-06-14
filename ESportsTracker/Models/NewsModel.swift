//
//  NewsModel.swift
//  ESportsTracker
//
//  Created by f1nch on 13.5.24.
//

import Foundation

class NewsModel: Model {
    static var shared = NewsModel()
    var presenter: Presenter?
    
    var news: News?
    
    private init(){}
    
    //установить презентер,связанный с моделью на данный момент
    func setPresenter(newPresenter: Presenter) {
        self.presenter = newPresenter
    }
    
    //обновить все новости асинхронно + обновить таблицу новостей в главном потоке, после подгрузки
    func getNews() {
        DispatchQueue.global().async {
            let headers = [
                "X-RapidAPI-Key": "af06df5541msh49a64a9df42bb9cp153137jsn4398a4d33471",
                "X-RapidAPI-Host": "useful-csgo-counter-strike.p.rapidapi.com"
            ]
            
            let request = NSMutableURLRequest(url: NSURL(string: "https://useful-csgo-counter-strike.p.rapidapi.com/reddit/hot")! as URL,
                                              cachePolicy: .useProtocolCachePolicy,
                                              timeoutInterval: 10.0)
            request.httpMethod = "GET"
            request.allHTTPHeaderFields = headers
            
            let session = URLSession.shared
            let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
                if (error != nil) {
                    print(error as Any)
                } else {
                    do {
                        self.news = try JSONDecoder().decode(News.self, from: data ?? Data())

                        DispatchQueue.main.sync {
                            self.updateNewsCells()
                        }
                    } catch let error as NSError {
                        print(error.localizedDescription)
                    }
                }
            })
            
            dataTask.resume()
        }
    }
    
    //метод обновления таблицы новостей
    func updateNewsCells() {
        if let presenter = presenter as? NewsPresenter {
            presenter.updateNewsCells()
        }
    }
}
