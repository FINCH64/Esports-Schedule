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
    var model: Model
    var viewToPresent: View
    
    init(model: Model, viewToPresent: View) {
        self.model = model
        self.viewToPresent = viewToPresent
    }
    
    //возвращает выбранный идущий кс матч
    func getSelectedMatch(forIndex index: Int) -> Event {
        (model as! MatchesInfoModel).liveCsMatchesInfo![index]
    }
    
    //обновить данные о всех идущих матчах
    func updateData() {
        MatchesInfoManager.shared.updateAllCurrentLiveMatches(updateAllMatchesTable: true)
    }
    
    //функция сохранения данных о сделанной ставке,отработает только если все данные введены корректно
    func saveTask(betAmount amount: Double,betOdd odd: Double,forMatch match: Event,teamBetOn team: TeamType) {
        let viewContext = getContext()
        guard let entity = NSEntityDescription.entity(forEntityName: "Bet", in: viewContext) else {return}
        
        let newBetObject = Bet(entity: entity, insertInto: viewContext)
        
        do {
            try newBetObject.matchEvent = JSONEncoder().encode(match)
            newBetObject.teamBetOn = team.rawValue
            newBetObject.betAmount = amount
            newBetObject.datePlayed = Date(timeIntervalSince1970: TimeInterval(match.startTimestamp ?? Int(Date().timeIntervalSince1970)))
            newBetObject.isLive = match.status?.type == "inprogress" ? true : false
            newBetObject.matchOdd = odd
        } catch {
            print("Cant save match")
        }
 
        do {
            try viewContext.save()
            model = MyBetsModel.shared
            (model as! MyBetsModel).addCreatedBet(newBet: newBetObject)
            let alertController = UIAlertController(title: "Sucess", message: "You bet saved.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default)
            alertController.addAction(okAction)
            (viewToPresent as! UIViewController).present(alertController, animated: true)
        } catch let error as NSError{
            print(error.localizedDescription)
            let alertController = UIAlertController(title: "Error", message: "You bet cant be saved.", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
            alertController.addAction(cancelAction)
            (viewToPresent as! UIViewController).present(alertController, animated: true)
        }
    }
    
    private func getContext() -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
}
