//
//  AddViewController.swift
//  RamenApp
//
//  Created by 鍋島 由輝 on 2019/03/02.
//  Copyright © 2019 ValJapan. All rights reserved.
//

import UIKit
import Firebase

class AddViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    var db: Firestore!
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
    
    // カメラロールから写真を選択する処理
    @IBAction func choosePicture() {
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
    
    @IBAction func photo(_ sender: Any) {
        
        // 1
        let optionMenu = UIAlertController(title: nil, message: "Choose Option", preferredStyle: .actionSheet)
        
        // 2
        let cameraRollAction = UIAlertAction(title: "カメラロールから選択", style: .default)
        let takeCameraAction = UIAlertAction(title: "写真を撮る", style: .default)
        
        // 3
        let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel)
        
        // 4
        optionMenu.addAction(cameraRollAction)
        optionMenu.addAction(takeCameraAction)
        optionMenu.addAction(cancelAction)
        
        // 5
        self.present(optionMenu, animated: true, completion: nil)
        
    }
//    private func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
//        // 選択した写真を取得する
//        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
//        // ビューに表示する
//        self.imageView.image = image
//        // 写真を選ぶビューを引っ込める
//        self.dismiss(animated: true)
//    }
    
    // 写真をリセットする処理
    @IBAction func resetPicture() {
        
    }
    
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
