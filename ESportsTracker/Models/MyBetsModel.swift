//
//  MyBetsModel.swift
//  ESportsTracker
//
//  Created by f1nch on 14.4.24.
//

import Foundation
import CoreData
import UIKit
//модель хранения данных о ставках,загружаются из CoreData
class MyBetsModel: Model {
    static var shared = MyBetsModel()
    
    private init(){
        viewContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    }
    
    var presenter: Presenter?
    var myLiveBets = [Bet]()
    var allMyBets = [Bet]()
    var betsInSelectedRange = [Bet]()
    let viewContext: NSManagedObjectContext
    
    //установить презентер,связанный с моделью на данный момент
    func setPresenter(presenter: Presenter) {
        self.presenter = presenter
    }
    
    //функция для загрузки всех ставок из CoreData,асинхронно
    func fetchBets() {
        DispatchQueue.global(qos: .userInteractive).async(flags: .barrier) {
            let fetchRequest: NSFetchRequest<Bet> = Bet.fetchRequest()
            
            if let results = try? self.viewContext.fetch(fetchRequest) {
                self.allMyBets = results
                
                let finishedBets = results.filter{bet in
                    if bet.isLive == false {
                        return true
                    }
                    return false
                }
                
                //для всех завершённых матчей проверки результата ставки
                for bet in finishedBets {
                    self.getBetResult(bet: bet)
                }
                
                //при обновлении матчей поиск идущих,для отображения на соответственном экране
                let liveBets = results.filter{bet in
                    if bet.isLive == true {
                        return true
                    }
                    return false
                }
                
                self.myLiveBets = liveBets
            }
            
            //проверка результатов ставок изменяет данные CoreData,сохраняем их в главном потоке + обновим таблицу ставок презентера
            DispatchQueue.main.sync{
                do {
                    try self.viewContext.save()
                } catch let error as NSError {
                    print(error.localizedDescription)
                }
                
                self.updateViewCells()
            }
        }
    }
    
    //метод асинхронной проверки ставки,если матч закончился,то ставку в CoreData завменим копией с доп информацией на основе того кто победил в матче,ставки и суммы
    func getBetResult(bet: Bet) {
        let decoder = JSONDecoder()
        if let event = try? decoder.decode(Event.self, from: bet.matchEvent ?? Data()),
           let eventId = event.id
        {
            let headers = [
                "X-RapidAPI-Key": "af06df5541msh49a64a9df42bb9cp153137jsn4398a4d33471",
                "X-RapidAPI-Host": "esportapi1.p.rapidapi.com"

            ]
            
            let request = NSMutableURLRequest(url: NSURL(string: "https://esportapi1.p.rapidapi.com/api/esport/event/\(eventId)")! as URL,
                                              cachePolicy: .useProtocolCachePolicy,
                                              timeoutInterval: 10.0)
            request.httpMethod = "GET"
            request.allHTTPHeaderFields = headers
            
            let session = URLSession.shared
            let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
                if (error != nil) {
                    print(error as Any)
                } else {
                    if let finishedEvent = try? JSONDecoder().decode(finishedEvent.self, from: data!),
                       let eventToCheck = finishedEvent.event {
                        if eventToCheck.status?.type ?? "unknown" == "finished" {
                        
                            let checkedResultBet = bet
                            let teamBettedOn = checkedResultBet.teamBetOn
                            let betOdd = checkedResultBet.matchOdd
                            let betAmmount = checkedResultBet.betAmount
                            let betProfit = (betOdd * betAmmount) - betAmmount
                            
                            if eventToCheck.status?.type != "finished" {
                                checkedResultBet.isLive = true
                            } else {
                                checkedResultBet.isLive = false
                            }
                            
                            if teamBettedOn ?? "none" == TeamType.home.rawValue {
                                if eventToCheck.winnerCode ?? 3 == 1 {
                                    checkedResultBet.betWon = true
                                    checkedResultBet.betProfit = betProfit
                                } else if eventToCheck.winnerCode ?? 3 == 2 {
                                    checkedResultBet.betWon = false
                                    checkedResultBet.betProfit = 0 - betAmmount
                                }
                            }else if teamBettedOn ?? "none" == TeamType.away.rawValue {
                                if eventToCheck.winnerCode ?? 3 == 1 {
                                    checkedResultBet.betWon = false
                                    checkedResultBet.betProfit = 0 - betAmmount
                                } else if eventToCheck.winnerCode ?? 3 == 2 {
                                    checkedResultBet.betWon = true
                                    checkedResultBet.betProfit = betProfit
                                }
                            }
                            
                            self.myLiveBets.replace([bet], with: [checkedResultBet])
                        }
                    }
                }
                    
            })
            
            dataTask.resume()
        }
    }
    
    //найти ставки в диапазоне фильтра по времени + обновить таблицу статистики
    func findSelectedBets(inDates dateInterval: DateInterval? = nil) {
        if let dateInterval = dateInterval {
            betsInSelectedRange = allMyBets.filter { bet in
                if let matchDate = bet.datePlayed,
                   dateInterval.contains(matchDate)
                {
                    return true
                }
                return false
            }
        }
        else {
            betsInSelectedRange = allMyBets
        }
        
        updateViewCells()
    }
    
    //обновить таблицу View после подгрузки и обновления данных
    func updateViewCells() {
        if let liveMatchPresenter = self.presenter as? LiveBetsPresenter {
            liveMatchPresenter.updateMyBetsCells()
        } else if let statisticsMatchPresenter = self.presenter as? StatisticsPresenter {
            statisticsMatchPresenter.updateMyBetsCells()
        }
    }
    
    //добавить созданную ставку в массив ставок
    func addCreatedBet(newBet: Bet) {
        myLiveBets.append(newBet)
    }
}
