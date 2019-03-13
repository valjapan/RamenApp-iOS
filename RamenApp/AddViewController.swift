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
    var uploadImage: UIImage!
    var imageUrl: URL!
    var passID: String!
    var downloadUrl: URL!

    var storageRef: StorageReference!

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

        storage = Storage.storage()


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

        let title: String = titleEditText.text!
        let detail: String = detailEditText.text!

//        let localFile = imageUrl
        let picRef = storage.reference(forURL: "gs://ramenoishii-e6deb.appspot.com").child("images")
        let data = uploadImage.pngData()!

        let documentRef = db.collection("collection").document()


        picRef.child("\(documentRef.documentID).png").putData(data, metadata: nil, completion: { [weak self] metadata, error in
            guard let self = self else { return }

            picRef.child("\(documentRef.documentID).png").downloadURL(completion: { url, error in
                self.downloadUrl = url
                print(url)
                print("nabe error: \(error)")
                documentRef.setData([
                    "downloadURL": url?.absoluteString ?? "",
                    "title": title,
                    "detail": detail
                    ]) { err in
                    if let err = err {
                        print("Error adding document: \(err)")
                    } else {
                        print("Document added with ID: \(documentRef.documentID)")
                        self.dismiss(animated: true, completion: nil)
                    }

                }
            })

        })

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

            uploadImage = image

            //  Storageにアップロードするときにパスで送ったほうがいいらしい
//            imageUrl = info[UIImagePickerController.InfoKey.imageURL] as! URL
//            print(imageUrl)
        }

        //写真ライブラリを閉じる
        dismiss(animated: true, completion: nil)

    }


    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
