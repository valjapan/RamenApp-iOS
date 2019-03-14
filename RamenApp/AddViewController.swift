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
    var firestore: Firestore!
    var storage: Storage!
    var uploadImage: UIImage!
    var imageUrl: URL!
    var passID: String!
    var downloadUrl: URL!
    var storageRef: StorageReference!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var titleEditText: UITextField!
    @IBOutlet var detailEditText: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
        let settings = FirestoreSettings()
        Firestore.firestore().settings = settings
        firestore = Firestore.firestore()
        storage = Storage.storage()
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        //Cancel
        return true
    }

    @IBAction func photo(_ sender: Any) {
        let optionMenu = UIAlertController(title: nil, message: "Choose Option", preferredStyle: .actionSheet)
        let cameraRollAction = UIAlertAction(title: "カメラロールから選択", style: .default, handler: {
            (action: UIAlertAction!)in
            self.choosePicture()
        })
        let takeCameraAction = UIAlertAction(title: "写真を撮る", style: .default, handler: {
            (action: UIAlertAction!)in
        })
        let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel)
        optionMenu.addAction(cameraRollAction)
        optionMenu.addAction(takeCameraAction)
        optionMenu.addAction(cancelAction)
        self.present(optionMenu, animated: true, completion: nil)
    }


    @IBAction func addContents() {
        let title: String = titleEditText.text!
        let detail: String = detailEditText.text!
        let picRef = storage.reference(forURL: "gs://ramenoishii-e6deb.appspot.com").child("images")
        if uploadImage == nil {
            let alert = UIAlertController(title: "画像の選択", message: "アップロードするための画像を選択してください", preferredStyle: UIAlertController.Style.alert)
            let okayButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil)
            alert.addAction(okayButton)
            
            alert.popoverPresentationController?.sourceView = self.view
            
            present(alert, animated: true, completion: nil)
            return
        }
        let data = uploadImage.pngData()!
        let documentRef = firestore.collection("collection").document()

        picRef.child("\(documentRef.documentID).png").putData(data, metadata: nil, completion: { [weak self] metadata, error in
            guard let self = self else { return }
            picRef.child("\(documentRef.documentID).png").downloadURL(completion: { url, error in
                self.downloadUrl = url
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
        }
        //写真ライブラリを閉じる
        dismiss(animated: true, completion: nil)
    }

    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
