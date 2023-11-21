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
    
    private init(){}
    
    var presenter: Presenter?
    var myBets = [Bet]()
    
    //установить презентер,связанный с моделью на данный момент
    func setPresenter(presenter: Presenter) {
        self.presenter = presenter
    }
    
    //функция для загрузки всех ставок из CoreData
    func fetchBets() {
        DispatchQueue.global(qos: .userInteractive).async(flags: .barrier) {
            let viewContext = self.getContext()
            let fetchRequest: NSFetchRequest<Bet> = Bet.fetchRequest()
            
            if let results = try? viewContext.fetch(fetchRequest) {
                self.myBets = results
            }
            DispatchQueue.main.sync{
                (self.presenter as! MyBetsPresenter).updateMyBetsCells()
            }
        }
    }
    
    private func getContext() -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    func addCreatedBet(newBet: Bet) {
        myBets.append(newBet)
    }
}
