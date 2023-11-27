//
//  MyBetsModel.swift
//  ESportsTracker
//
//  Created by f1nch on 21.11.23.
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
    
    //функция для загрузки всех ставок из CoreData
    func fetchBets() {
        DispatchQueue.global(qos: .userInteractive).async(flags: .barrier) {
            
            let fetchRequest: NSFetchRequest<Bet> = Bet.fetchRequest()
            
            if let results = try? self.viewContext.fetch(fetchRequest) {
                self.allMyBets = results
                self.betsInSelectedRange = results
                
                let myBetsToCheckResult = results.filter{bet in
                    if bet.matchResultChecked == false {
                        return true
                    }
                    return false
                }
                
                for bet in myBetsToCheckResult {
                    self.getBetResult(bet: bet)
                }
                
                let liveBets = results.filter{bet in
                    if bet.isLive == true {
                        return true
                    }
                    return false
                }
                
                self.myLiveBets = liveBets
            }
            
            DispatchQueue.main.sync{
                do {
                    try self.viewContext.save()
                } catch let error as NSError {
                    print(error.localizedDescription)
                }
                if let liveMatchPresenter = self.presenter as? MyBetsPresenter {
                    liveMatchPresenter.updateMyBetsCells()
                } else if let statisticsMatchPresenter = self.presenter as? StatisticsPresenter {
                    statisticsMatchPresenter.updateMyBetsCells()
                }
            }
        }
    }
    
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
                            
                            checkedResultBet.isLive = false
                            checkedResultBet.matchResultChecked = true
                            
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
    }
    
    func addCreatedBet(newBet: Bet) {
        myLiveBets.append(newBet)
    }
}
