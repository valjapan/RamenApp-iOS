//
//  AddViewController.swift
//  RamenApp
//
//  Created by 鍋島 由輝 on 2019/03/02.
//  Copyright © 2019 ValJapan. All rights reserved.
//

import UIKit
import Firebase

class AddViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate ,UITextFieldDelegate{
    var firestore: Firestore!
    var storage: Storage!
    var uploadImage: UIImage!
    var imageUrl: URL!
    var passID: String!
    var downloadUrl: URL!
    var storageRef: StorageReference!
    var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var titleEditText: UITextField!{
        didSet{
            titleEditText.delegate = self 
        }
    }
    @IBOutlet var detailEditText: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
        let settings = FirestoreSettings()
        Firestore.firestore().settings = settings
        firestore = Firestore.firestore()
        storage = Storage.storage()

        let width = self.view.frame.width
        let height = self.view.frame.height
        activityIndicatorView = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        activityIndicatorView.center = CGPoint(x: width / 2, y: height / 2)
        activityIndicatorView.hidesWhenStopped = true
        activityIndicatorView.backgroundColor = UIColor.lightGray
        self.view.addSubview(activityIndicatorView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        self.configureObserver()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        self.removeObserver() // Notificationを画面が消えるときに削除
    }
    
    // Notificationを設定
    func configureObserver() {
        
        let notification = NotificationCenter.default
        notification.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        notification.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // Notificationを削除
    func removeObserver() {
        
        let notification = NotificationCenter.default
        notification.removeObserver(self)
    }
    
    // キーボードが現れた時に、画面全体をずらす。
    @objc func keyboardWillShow(notification: Notification?) {
        
        let rect = (notification?.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue
        let duration: TimeInterval? = notification?.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double
        UIView.animate(withDuration: duration!, animations: { () in
            let transform = CGAffineTransform(translationX: 0, y: -(rect?.size.height)!)
            self.view.transform = transform
            
        })
    }
    
    // キーボードが消えたときに、画面を戻す
    @objc func keyboardWillHide(notification: Notification?) {
        
        let duration: TimeInterval? = notification?.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? Double
        UIView.animate(withDuration: duration!, animations: { () in
            
            self.view.transform = CGAffineTransform.identity
        })
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder() // Returnキーを押したときにキーボードを下げる
        return true
    }

    @IBAction func photo(_ sender: Any) {
        let optionMenu = UIAlertController(title: nil, message: "Choose Option", preferredStyle: .actionSheet)

        if UIDevice.current.userInterfaceIdiom == .pad {
            optionMenu.popoverPresentationController?.sourceView = self.view
            let screenSize = UIScreen.main.bounds
            optionMenu.popoverPresentationController?.sourceRect = CGRect(x: screenSize.size.width / 2, y: screenSize.size.height, width: 0, height: 0)
        }

        let cameraRollAction = UIAlertAction(title: "カメラロールから選択", style: .default, handler: {
            (action: UIAlertAction!)in
            self.choosePicture()
        })
//        let takeCameraAction = UIAlertAction(title: "写真を撮る", style: .default, handler: {
//            (action: UIAlertAction!)in
//            self.takePictures()
//        })
        let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel)
        optionMenu.addAction(cameraRollAction)
//        optionMenu.addAction(takeCameraAction)
        optionMenu.addAction(cancelAction)
        self.present(optionMenu, animated: true, completion: nil)
    }

//    func takePictures() {
//        let alert = UIAlertController(title: "写真を撮る", message: "今後の実装に期待してください", preferredStyle: UIAlertController.Style.alert)
//        let okayButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil)
//        alert.addAction(okayButton)
//        alert.popoverPresentationController?.sourceView = self.view
//        present(alert, animated: true, completion: nil)
//    }

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

        activityIndicatorView.startAnimating()
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
                        self.activityIndicatorView.stopAnimating()
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

    @IBAction func tapScreen(sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }

    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
