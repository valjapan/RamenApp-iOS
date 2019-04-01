//
//  SubViewController.swift
//  RamenApp
//
//  Created by 鍋島 由輝 on 2019/03/13.
//  Copyright © 2019 ValJapan. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher
import Firebase

class DetailViewController: UIViewController {
    var urlPassString: String?
    var titleString: String?
    var detailString: String?
    var urlString: String!
    var reportString: String!
    var firestore: Firestore!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailTextView: UITextView!


    override func viewDidLoad() {
        super.viewDidLoad()

        urlString = urlPassString!
        titleLabel.text = titleString
        detailTextView.text = detailString

        let url = URL(string: urlString)
        imageView.kf.indicatorType = .activity
        imageView.kf.setImage(with: url)

        let settings = FirestoreSettings()
        Firestore.firestore().settings = settings
        firestore = Firestore.firestore()

    }

    @IBAction func reportButton(_ sender: Any) {
        let alert: UIAlertController = UIAlertController(title: "アラート表示", message: "報告してもよろしいですか？", preferredStyle: UIAlertController.Style.alert)
        let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {
            (action: UIAlertAction!) -> Void in

            let controller = UIAlertController(title: "報告",
                message: "報告する内容を記入してください",
                preferredStyle: .alert)

            controller.addTextField { textField in
                self.reportString = textField.text!
                print(self.reportString)
            }

            let cancelAction = UIAlertAction(title: "キャンセル",
                style: .cancel,
                handler: nil)

            let reportAction = UIAlertAction(title: "報告する",
                style: .default) { action in

                let documentRef = self.firestore.collection("report").document()
                documentRef.setData([
                    "repoatImageURL": self.urlString,
                    "title": self.titleString,
                    "detail": self.detailString,
                    "report": self.reportString
                    ])

                let alert = UIAlertController(title: "報告", message: "管理者に報告が完了しました", preferredStyle: UIAlertController.Style.alert)
                let okayButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil)
                alert.addAction(okayButton)
                self.present(alert, animated: true, completion: nil)

            }

            controller.addAction(cancelAction)
            controller.addAction(reportAction)

            self.present(controller, animated: true, completion: nil)

        })
        let cancelAction: UIAlertAction = UIAlertAction(title: "キャンセル", style: UIAlertAction.Style.cancel, handler: {
            (action: UIAlertAction!) -> Void in
        })
        alert.addAction(cancelAction)
        alert.addAction(defaultAction)
        present(alert, animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
