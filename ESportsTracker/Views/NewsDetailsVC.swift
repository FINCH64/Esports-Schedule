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
    
    
    //после загрузки заполним экран данными о новости,на основание его индекса TableView и матча в модели
    override func viewDidLoad() {
        super.viewDidLoad()

        presenter = NewsDetailsPresenter(model: NewsModel.shared,viewToPresent: self)
        articleToShow = getArticle(forSelectedIndex: articleSelectedRowIndex)
        articleHeaderLabel.text = articleToShow?.title ?? "No title"
        articleBodyLabel.text = articleToShow?.text ?? "No description"
    }
    
    //при нажатии на кнопку откроется экран с полной информацией в сафари
    @IBAction func checkDiscussionButton(_ sender: UIButton) {
        openSafari(stringUrl: articleToShow?.url)
    }
    
    //создание View Safari для отображения полной новости,и показ его
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
    
    //возвращает презентер типа презентера деталей новостей,сделано чтобы не приводить искуственно при каждой надобности использовать презентер
    func getNewsDetailsPresenter() -> NewsDetailsPresenter {
        (presenter as! NewsDetailsPresenter)
    }
    
    //получить новость из модели по выбранному индексу в таблице
    func getArticle(forSelectedIndex: IndexPath?) -> Article? {
        getNewsDetailsPresenter().getArticle(forSelectedIndex: forSelectedIndex)
    }
}
