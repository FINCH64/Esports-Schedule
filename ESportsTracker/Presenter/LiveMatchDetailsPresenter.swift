//
//  LiveMatchDetailsPresenter.swift
//  ESportsTracker
//
//  Created by f1nch on 20.11.23.
//

import Foundation
import CoreData
import UIKit

class LiveMatchDetailsPresenter: Presenter {
    var model: Model//модель идущих матчей
    var myBetsModel: Model//модель сделанных ставок
    var viewToPresent: View
    
    //список подходящих статусов карты матча,сделано для исключения необычных статусов,по типу паузы и переноса,пока матч не пропадёт из идущих
    var AcceptableStatusDescriptions = [
        "Second game",
        "Third game",
        "Fourth game",
        "Fifth game",
        "No map info"
    ]
    
    init(matchesModel: Model,betsModel: Model, viewToPresent: View) {
        self.model = matchesModel
        self.myBetsModel = betsModel
        self.viewToPresent = viewToPresent
    }
    
    //возвращает выбранный идущий кс матч
    func getSelectedMatch(forIndex index: Int) -> Event {
        getMatchesModel().liveCsMatchesInfo![index]
    }
    
    //функция сохранения данных о сделанной ставке,отработает только если все данные введены корректно
    func saveTask(betAmount amount: Double,betOdd odd: Double,forMatch match: Event,teamBetOn team: TeamType,betType: BetType) {
        let viewContext = getContext()
        guard let entity = NSEntityDescription.entity(forEntityName: "Bet", in: viewContext) else {return}
        
        let newBetObject = Bet(entity: entity, insertInto: viewContext)
        
        do {
            try newBetObject.matchEvent = JSONEncoder().encode(match)
            let betMap = match.status?.description ?? "No map info"
             
            newBetObject.teamBetOn = team.rawValue
            newBetObject.betAmount = amount
            newBetObject.datePlayed = Date(timeIntervalSince1970: TimeInterval(match.startTimestamp ?? Int(Date().timeIntervalSince1970)))
            newBetObject.isLive = match.status?.type == "inprogress" ? true : false
            newBetObject.matchOdd = odd
            newBetObject.betType = betType.rawValue
            newBetObject.mapBetPlacedOn = AcceptableStatusDescriptions.contains(betMap) ? betMap : "No map info"
        } catch {
            print("Cant save match")
        }
 
        do {
            try viewContext.save()
            
            getBetsModel().addCreatedBet(newBet: newBetObject)
            
            let alertController = UIAlertController(title: "Sucess", message: "Your bet saved.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default)
            alertController.addAction(okAction)
            
            getAsVC().present(alertController, animated: true)
        } catch let error as NSError{
            print(error.localizedDescription)
            
            let alertController = UIAlertController(title: "Error", message: "Your bet cant be saved.", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
            alertController.addAction(cancelAction)
            
            getAsVC().present(alertController, animated: true)
        }
    }
    
    //получить контекст для сохранения ставки
    private func getContext() -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    //возвращает Model типа MatchesInfoModel,сделано чтобы не приводить искуственно при каждой надобности использовать
    func getMatchesModel() -> MatchesInfoModel {
        model as! MatchesInfoModel
    }
    
    //возвращает Model типа MyBetsModel,сделано чтобы не приводить искуственно при каждой надобности использовать
    func getBetsModel() -> MyBetsModel {
        myBetsModel as! MyBetsModel
    }
    
    //получить View как UIViewController,сделано чтобы не приводить искуственно при каждой надобности использовать
    func getAsVC() -> UIViewController {
        (viewToPresent as! UIViewController)
    }
}
