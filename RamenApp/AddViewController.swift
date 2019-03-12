//
//  AddViewController.swift
//  RamenApp
//
//  Created by 鍋島 由輝 on 2019/03/02.
//  Copyright © 2019 ValJapan. All rights reserved.
//

import UIKit
import Firebase

class AddViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var db: Firestore!
    var storage: Storage!
    var image: UIImage!
    var imageUrl: URL!

//    var storageRef: StorageReference!

    @IBOutlet var imageView: UIImageView!
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

//        storage = Storage.storage()


//       storageRef = Storage.storage().reference()
        // Do any additional setup after loading the view.
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        //Cancel
        return true
    }
    
    
    @IBAction func photo(_ sender: Any) {
        
        // 1
        let optionMenu = UIAlertController(title: nil, message: "Choose Option", preferredStyle: .actionSheet)
        
        // 2
        let cameraRollAction = UIAlertAction(title: "カメラロールから選択", style: .default, handler: {
            (action: UIAlertAction!)in
            self.choosePicture()
            
        })
        let takeCameraAction = UIAlertAction(title: "写真を撮る", style: .default, handler: {
            (action: UIAlertAction!)in
            
        })
        
        // 3
        let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel)
        
        // 4
        optionMenu.addAction(cameraRollAction)
        optionMenu.addAction(takeCameraAction)
        optionMenu.addAction(cancelAction)
        
        // 5
        self.present(optionMenu, animated: true, completion: nil)
        
    }


    @IBAction func addPhoto(_ sender: Any) {
//
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
        
        // STORAGEにアップロードする
        //        let storageRef = storage.reference()
        //
        //        let picRef = storageRef.child("images/\(ref!.documentID)")
        //
        //        let uploadTask = picRef.putFile(from: imageUrl, metadata: nil) { metadata, error in
        //            guard let metadata = metadata else {
        //                // Uh-oh, an error occurred!
        //                return
        //            }
        //            // Metadata contains file metadata such as size, content-type.
        //            let size = metadata.size
        //            // You can also access to download URL after upload.
        //            storageRef.downloadURL { (url, error) in
        //                guard url != nil else {
        //                    // Uh-oh, an error occurred!
        //                    return
        //                }
        //            }
        //        }
        
        self.dismiss(animated: true, completion: nil)

    }

    // カメラロールから写真を選択する処理
    func choosePicture() {
        // カメラロールが利用可能か？
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            // 写真を選ぶビュー
            let pickerView = UIImagePickerController()

            // 写真の選択元をカメラロールにする
            // 「.camera」にすればカメラを起動できる
            pickerView.sourceType = .photoLibrary
            // デリゲート
            pickerView.delegate = self
            // ビューに表示
            self.present(pickerView, animated: true)

        }
    }

    //写真が選択された時の処理
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {

        //選択された画像を保存
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {

            //比率を変えずに画像を表示する
            imageView.contentMode = UIView.ContentMode.scaleAspectFit

            //画像を設定
            imageView.image = image
            
            // Storageにアップロードするときにパスで送ったほうがいいらしい
//            imageUrl = info[UIImagePickerController.InfoKey.referenceURL] as? URL
//            print(imageUrl)
        }

        //写真ライブラリを閉じる
        dismiss(animated: true, completion: nil)

    }


    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
