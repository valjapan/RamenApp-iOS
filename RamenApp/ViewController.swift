//
//  ViewController.swift
//  RamenApp
//
//  Created by 鍋島 由輝 on 2019/02/25.
//  Copyright © 2019 ValJapan. All rights reserved.
//

import UIKit
import Firebase
import Kingfisher

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var firestore: Firestore!
    var cellCount: Int!
    var cell: UITableViewCell!
    var urlString: String!
    var chosenCount: Int!
    var ramenArray: [Ramen] = []
    @IBOutlet var table: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        table.dataSource = self
        let settings = FirestoreSettings()
        Firestore.firestore().settings = settings
        firestore = Firestore.firestore()
        getCollection()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ramenArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ListTableViewCell
        let nowIndexPathDictionary = ramenArray[indexPath.row]
        cell.titleLabel.text = nowIndexPathDictionary.title
        cell.detailLabel.text = nowIndexPathDictionary.detail
        urlString = nowIndexPathDictionary.url
        let url = URL(string: urlString)
        cell.ramenImageView.kf.indicatorType = .activity
        cell.ramenImageView.kf.setImage(with: url)
        return cell
    }

    // セルが選択された時に呼ばれる
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 選択されたcellの番号を記憶
        chosenCount = indexPath.row
        // 画面遷移の準備
        performSegue(withIdentifier: "toSubViewController", sender: nil)
        print(chosenCount)
    }

    // Segue 準備
    override func prepare(for segue: UIStoryboardSegue, sender: Any!) {
        if segue.identifier == "toSubViewController" {
            // 遷移先のViecControllerのインスタンスを生成
            let secVC: DetailViewController = (segue.destination as? DetailViewController)!
            // secondViewControllerのgetCellに選択された画像を設定する
            let nowIndexPathDictionary = ramenArray[chosenCount]
            secVC.titleString = nowIndexPathDictionary.title
            secVC.detailString = nowIndexPathDictionary.detail
            secVC.urlPassString = nowIndexPathDictionary.url
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        getCollection()
    }

    private func getCollection() {
        firestore.collection("collection").getDocuments() {
            (querySnapshot, err) in

            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                self.ramenArray = []
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                    self.ramenArray.append(Ramen.init(url: document.data()["downloadURL"]as! String, tiele: document.data()["title"] as! String, detail: document.data()["detail"] as! String))
                }
            }
            DispatchQueue.main.async {
                self.table.reloadData()
            }
        }
    }
}

