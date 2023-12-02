//
//  MatchesInfoModel.swift
//  ESportsTracker
//
//  Created by f1nch on 17.11.23.
//

import Foundation
import UIKit

enum TeamType: String,Codable {
    case home = "homeTeam"
    case away = "awayTeam"
}

enum BetType: String,Codable {
    case map = "map"
    case match = "match"
}

//модель данных где хранится вся информация об идущих матчах
//у модели с этими данными может меняться презентер при переходах на другой экран,
//для этого есть setPresenterForModel у свойства shared у модели
class MatchesInfoModel: Model {
    static var shared = MatchesInfoModel()
    
    private init(){}
    
    var presenter: Presenter?
    
    var liveMatchesInfo: LiveMatches?
    var liveCsMatchesInfo : [Event]?
    var upcomingCsMatches : [UpcomingEvent]?
    
    func updateAllCurrentLiveMatches() {
        //должен делать запрос к апи за текущими матчами,загружает данные асинхронно
        //при окончании создает в главном потоке задачу обновления UITableView и всех ячеек

        DispatchQueue.global(qos: .userInteractive).async(flags: .barrier) {
            let headers = [
                "X-RapidAPI-Key": "af06df5541msh49a64a9df42bb9cp153137jsn4398a4d33471",
                "X-RapidAPI-Host": "esportapi1.p.rapidapi.com"
            ]
            
            let request = NSMutableURLRequest(url: NSURL(string: "https://esportapi1.p.rapidapi.com/api/esport/matches/live")! as URL,
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
                        print(response as? HTTPURLResponse ?? "no server response")
                        self.liveMatchesInfo = try JSONDecoder().decode(LiveMatches.self, from: data!)
                        let a = self.liveMatchesInfo
                        self.setLiveCSMatches(from: self.liveMatchesInfo?.events)
                        DispatchQueue.main.sync {
                            self.updateTVLiveMatchesCells()
                        }
                    } catch let parsingError as NSError {
                        print(parsingError.localizedDescription)
                    }
                }
            })
            dataTask.resume()
        }
    }
    
    func updateUpcomingMatches() {
        DispatchQueue.global(qos: .userInteractive).async(flags: .barrier) {
            let headers = [
                "X-RapidAPI-Key": "af06df5541msh49a64a9df42bb9cp153137jsn4398a4d33471",
                "X-RapidAPI-Host": "esportapi1.p.rapidapi.com"
            ]
            let tomorrowDate = Date(timeInterval: 86400.0, since: Date())
            let tomorrowDateComponents = Calendar.current.dateComponents([.month, .day, .year], from: tomorrowDate)
            let tomorrowDayInt = tomorrowDateComponents.day ?? 0
            let tomorrowMonthInt = tomorrowDateComponents.month ?? 0
            let tomorrowYearInt = tomorrowDateComponents.year ?? 0
            
            let request = NSMutableURLRequest(url: NSURL(string: "https://esportapi1.p.rapidapi.com/api/esport/matches/\(tomorrowDayInt)/\(tomorrowMonthInt)/\(tomorrowYearInt)")! as URL,
                                                    cachePolicy: .useProtocolCachePolicy,
                                                timeoutInterval: 10.0)
            request.httpMethod = "GET"
            request.allHTTPHeaderFields = headers

            let session = URLSession.shared
            let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
                if (error != nil) {
                    print(error as Any)
                } else {
                    let httpResponse = response as? HTTPURLResponse
                    print(httpResponse)
                    do {
                        let upcomingMatches = try JSONDecoder().decode(UpcomingMatches.self, from: data ?? Data())
                        self.setUpcomingCsMatches(upcomingMatches: upcomingMatches)
                        if let upcomingCsMatches = self.upcomingCsMatches
                        {
                            DispatchQueue.main.sync {
                                self.updateCVUpcomingMatchesCells()
                            }
                        }
                    } catch let parsingError as NSError {
                        print(parsingError.localizedDescription)
                    }
                }
            })

            dataTask.resume()
        }
    }
    
    //метод подгрузки лэйбла команды(картинки) по её id,внутренности будут работать и будут закомменчены чтобы не тратить запросы
    //indexPath нужен чтобы было понятно в каком ряду искать UIImage для вставки загруженных картинок
    func getTeamImage(teamId id: Int,indexPath: IndexPath,teamType: TeamType) {
        DispatchQueue.global(qos: .default).async {
            let headers = [
                "X-RapidAPI-Key": "af06df5541msh49a64a9df42bb9cp153137jsn4398a4d33471",
                "X-RapidAPI-Host": "esportapi1.p.rapidapi.com"
            ]
            
            let request = NSMutableURLRequest(url: NSURL(string: "https://esportapi1.p.rapidapi.com/api/esport/team/\(id)/image")! as URL,
                                              cachePolicy: .useProtocolCachePolicy,
                                              timeoutInterval: 10.0)
            request.httpMethod = "GET"
            request.allHTTPHeaderFields = headers
            
            let session = URLSession.shared
            let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
                if (error != nil) {
                    print(error as Any)
                } else {
                    print(response as? HTTPURLResponse ?? "no server response")
                    var imageData = UIImage(named: "QuestionMark")!.pngData()
                    
                    if data != nil,
                       !data!.isEmpty {
                        imageData = data!
                    }
                    
                    if teamType == .home {
                        self.liveCsMatchesInfo?[indexPath.row].homeTeam?.teamLogoData = imageData
                    } else if teamType == .away {
                        self.liveCsMatchesInfo?[indexPath.row].awayTeam?.teamLogoData = imageData
                    }
                    
                    DispatchQueue.main.sync {
                        self.updateRows(rowsToUpdate: indexPath)
                    }
                }
            })
            
            dataTask.resume()
        }
    }
    
    //метод вызывающий через модель-презентер-вью обновление всех ячеек,вызывается после асинхронной загрузки данных о матчах
    private func setLiveCSMatches(from matches: [Event]?) {
        //выбирает все матчи по кс и записывает в переменную внутри модели
        if let matches = matches {
            self.liveCsMatchesInfo = matches.filter{$0.tournament?.category?.flag == "csgo"}
            var matchIndex = 0 //нужен чтобы понимать в каком ряду будет отрисована ячейка с этим матчем,тк отрисовка идёт для всех кс матчей,то это будет сделано в таком же порядке
                               //как и перебор снизу
            self.liveCsMatchesInfo?.forEach { match in
                //self.getTeamImage(teamId: match.homeTeam?.id ?? 0, indexPath: IndexPath(item: matchIndex, section: 0), teamType: .home)
                //self.getTeamImage(teamId: match.awayTeam?.id ?? 0, indexPath: IndexPath(item: matchIndex, section: 0), teamType: .away)
                matchIndex += 1
            }
        }
    }
    
    func setUpcomingCsMatches(upcomingMatches: UpcomingMatches?) {
        if let upcomingMatches = upcomingMatches {
            let upcomingCsMatches = upcomingMatches.events?.filter {upcomingEvent in
                if upcomingEvent.tournament?.category?.slug?.rawValue == "csgo" {
                    return true
                }
                return false
            }
            
            self.upcomingCsMatches = upcomingCsMatches
        }
    }
    
    //установить презентер пользующийся моделью на данный момент
    func setPresenterForModel(newPresenter: Presenter) {
        self.presenter = newPresenter
    }
    
    //после загрузки данных вызывается для обновления UITableView ячеек,но только если презентер модели в данный момент это TableView
    //вызывается из менджера матчей,вызывает метод обновления в presenter
    func updateTVLiveMatchesCells() {
        if let presenter = presenter as? LiveMatchPresenter {
            presenter.updateLiveMatchesTVCells()
        }
    }
    
    //после подшрузки картинки вызывает метод обновления у презенткра,ограничения такие же как у updateTVLiveMatchesCells()
    func updateRows(rowsToUpdate indexPath: IndexPath) {
        if let presenter = presenter as? LiveMatchPresenter {
            presenter.updateRows(rowsToUpdate: indexPath)
        }
    }
    
    //вернет по порядковому номеру ячейки идущий матч по кс,с таким же порядковым номером ячейки массива
    func getSelectedCsMatch(forIndex index: Int) -> Event{
        liveCsMatchesInfo![index]
    }
    
    func updateCVUpcomingMatchesCells() {
        if let presenter = presenter as? NewsPresenter {
            presenter.updateUpcomingMatchesCells()
        }
    }
}
