//
//  ViewController.swift
//  RamenApp
//
//  Created by 鍋島 由輝 on 2019/02/25.
//  Copyright © 2019 ValJapan. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController, UITableViewDataSource {

    var db: Firestore!

    var cellCount: Int!

    var cell: UITableViewCell!

    @IBOutlet var table: UITableView!

    var ramenArray: [Ramen] = []

    override func viewDidLoad() {
        super.viewDidLoad()

//        table.dataSource = self


        let settings = FirestoreSettings()

        Firestore.firestore().settings = settings

        db = Firestore.firestore()

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
        
        
        return cell

    }

    override func viewWillAppear(_ animated: Bool) {
        getCollection()
        
    }

    private func getCollection() {
        db.collection("collection").getDocuments() {
            (querySnapshot, err) in

            if let err = err {
                print("Error getting documents: \(err)");
            } else {
                for document in querySnapshot!.documents {
                    //                        self.cellCount += 1
                    print("\(document.documentID) => \(document.data())");

                    self.ramenArray.append(Ramen.init(tiele: document.data()["title"] as! String, detail: document.data()["detail"] as! String))


                }
                //                    print("Count = \(String(self.cellCount))");
            }
            
            DispatchQueue.main.async {
                self.table.reloadData()
            }

        }

    }

}

