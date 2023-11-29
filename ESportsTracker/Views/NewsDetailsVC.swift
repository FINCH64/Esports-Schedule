//
//  NewsDetailsVC.swift
//  ESportsTracker
//
//  Created by f1nch on 28.11.23.
//

import UIKit
import SafariServices

class NewsDetailsVC: UIViewController,View,SFSafariViewControllerDelegate {
    var presenter: Presenter?
    var articleToShow: Article?
    
    var articleSelectedRowIndex: IndexPath?
    var safariVC: SFSafariViewController?
    
    @IBOutlet weak var articleHeaderLabel: UILabel!
    @IBOutlet weak var articleBodyLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        presenter = NewsDetailsPresenter(model: NewsModel.shared,viewToPresent: self)
        articleToShow = (presenter as? NewsDetailsPresenter)?.getArticle(forSelectedIndex: articleSelectedRowIndex)
        articleHeaderLabel.text = articleToShow!.title ?? "No title"
        articleBodyLabel.text = articleToShow!.text ?? "No description"
    }
    
    @IBAction func checkDiscussionButton(_ sender: UIButton) {
        openSafari(stringUrl: articleToShow?.url)
    }
    
    func openSafari(stringUrl: String?) {
        if let url = URL(string: stringUrl ?? "") {
            safariVC = SFSafariViewController(url: url)
            present(safariVC!, animated: true)
        } else {
            let alertController = UIAlertController(title: "Wrong url", message: "Discussion have incorrect url adress", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
            alertController.addAction(cancelAction)
            present(alertController, animated: true)
        }
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
