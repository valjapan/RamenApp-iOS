//
//  CameraViewController.swift
//  RamenApp
//
//  Created by 鍋島 由輝 on 2019/03/02.
//  Copyright © 2019 ValJapan. All rights reserved.
//

import UIKit

class CameraViewController: UIViewController {

    @IBOutlet var cameraImageView: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func takephoto(_ sender: Any) {
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        //Cancel
        return true
    }


}
