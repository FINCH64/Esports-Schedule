//
//  TabBarNavigationController.swift
//  ESportsTracker
//
//  Created by f1nch on 2.12.23.
//

import UIKit

class TabBarNavigationController: UITabBarController,UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
    }
    
    //при переключении по вкладкам вызывает обновление данных,отображаемых на выбранной странице и вызывает метод установки презентера у модели
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        switch viewController {
            case let destinationVC as AllMatchesTableViewController:
            
                if let matchesModel = setModelsPresenter(presenterOfView: destinationVC) as? MatchesInfoModel {
                    matchesModel.updateAllCurrentLiveMatches()
                }

            case let destinationVC as NewsVC:
            
                if let newsPresenter = destinationVC.presenter as? NewsPresenter,
                   let matchesModel = newsPresenter.upcomingMatchesModel as? MatchesInfoModel,
                   let newsModel = newsPresenter.model as? NewsModel {
                        
                        matchesModel.presenter = newsPresenter
                        newsModel.presenter = newsPresenter
                        
                        matchesModel.updateUpcomingMatches()
                        newsModel.getNews()
                }
            
            case let destinationVC as LiveBetsVC:
            
                if let betsModel = setModelsPresenter(presenterOfView: destinationVC) as? MyBetsModel {
                    betsModel.fetchBets()
                }
            
            case let destinationVC as StatisticsVC:
            
                if let betsModel = setModelsPresenter(presenterOfView: destinationVC) as? MyBetsModel {
                    betsModel.fetchBets()
                }
            
        default:
            print("Wrong navigator destination")
        }
    }
    
    //при переходе на экран View устанавливает у нужных этому экрану моделей соответсвующий презентер,отвечающий за этот экран
    func setModelsPresenter(presenterOfView view: View) -> Model?{
        if let presenter = view.presenter {
            presenter.model.presenter = presenter
            return presenter.model
        }
        return nil
    }
}
