//
//  AddViewController.swift
//  RamenApp
//
//  Created by 鍋島 由輝 on 2019/03/02.
//  Copyright © 2019 ValJapan. All rights reserved.
//

import UIKit
import Firebase

class AddViewController: UIViewController {
    var db: Firestore!
//    var storageRef: StorageReference!

    @IBOutlet var image: UIImageView!
    @IBOutlet var titleEditText: UITextField!
    @IBOutlet var detailEditText: UITextView!
    @IBOutlet var add: UIBarButtonItem!
    @IBOutlet var cancel: UIBarButtonItem!



    override func viewDidLoad() {
        super.viewDidLoad()

        // [START setup]
        let settings = FirestoreSettings()

        Firestore.firestore().settings = settings
        // [END setup]
        db = Firestore.firestore()



//       storageRef = Storage.storage().reference()
        // Do any additional setup after loading the view.
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        //Cancel
        return true
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func addPhoto(_ sender: Any) {
        print("押されたよ")

        var ref: DocumentReference? = nil

        let title: String = titleEditText.text!
        let detail: String = detailEditText.text!

        ref = db.collection("collection").addDocument(data: [
            "title": title,
            "detail": detail
            ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(ref!.documentID)")
            }
        }

        self.dismiss(animated: true, completion: nil)

    }
    
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
