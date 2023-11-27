//
//  NewsDetailsVC.swift
//  ESportsTracker
//
//  Created by f1nch on 28.11.23.
//

import UIKit

class NewsDetailsVC: UIViewController,View {
    var presenter: Presenter?
    var articleToShow: Article?
    
    var articleSelectedRowIndex: IndexPath? {
        didSet {
            articleToShow = (presenter as? NewsDetailsPresenter)?.getArticle(forSelectedIndex: articleSelectedRowIndex!)
        }
    }
    
    @IBOutlet weak var articleHeaderLabel: UILabel!
    @IBOutlet weak var articleBodyLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        presenter = NewsDetailsPresenter(model: NewsModel.shared,viewToPresent: self)
        articleHeaderLabel.text = articleToShow!.title ?? "No title"
        articleBodyLabel.text = articleToShow!.text ?? "No description"
    }
    
    @IBAction func checkDiscussionButton(_ sender: UIButton) {
        
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
