//
//  TabBarNavigationController.swift
//  ESportsTracker
//
//  Created by f1nch on 2.12.23.
//

import UIKit

class TabBarNavigationController: UITabBarController,UITabBarControllerDelegate {

    override func loadView() {
        super.loadView()
        self.selectedIndex = 3
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        // Do any additional setup after loading the view.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    //override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    //}
    
    //при переключении по вкладкам вызывает обновление данных,отображаемых на выбранной странице
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        switch viewController {
            case let destinationVC as AllMatchesTableViewController:
                if let matchesModel = setModelsPresenter(presenterOfView: destinationVC) as? MatchesInfoModel {
                    matchesModel.updateAllCurrentLiveMatches()
                }
                print("LiveMatches")
            case let destinationVC as NewsVC:
                if let newsPresenter = destinationVC.presenter as? NewsPresenter {
                    if let matchesModel = newsPresenter.upcomingMatchesModel as? MatchesInfoModel,
                       let newsModel = newsPresenter.model as? NewsModel {
                        
                        matchesModel.presenter = newsPresenter
                        newsModel.presenter = newsPresenter
                        
                        matchesModel.updateUpcomingMatches()
                        newsModel.getNews()
                        print("News")
                    }
                }
            case let destinationVC as LiveBetsVC:
                if let betsModel = setModelsPresenter(presenterOfView: destinationVC) as? MyBetsModel {
                    betsModel.fetchBets()
                    print("unfinished bets")
                }
            case let destinationVC as StatisticsVC:
                if let betsModel = setModelsPresenter(presenterOfView: destinationVC) as? MyBetsModel {
                    betsModel.fetchBets()
                    print("Stats")
                }
        default:
            print("Wrong navigator destination")
        }
    }
    
    func setModelsPresenter(presenterOfView view: View) -> Model?{
        if let presenter = view.presenter {
            presenter.model.presenter = presenter
            return presenter.model
        }
        return nil
    }
}
