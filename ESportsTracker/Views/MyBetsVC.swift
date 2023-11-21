//
//  MyBetsVC.swift
//  ESportsTracker
//
//  Created by f1nch on 21.11.23.
//

import UIKit

class MyBetsVC: UIViewController,View {
    var presenter: Presenter?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = MyBetsPresenter(model: MatchesInfoModel.shared,viewToPresent: self)
        (presenter as! MyBetsPresenter).fetchBets()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
