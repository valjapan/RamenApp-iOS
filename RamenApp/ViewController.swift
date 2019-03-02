//
//  ViewController.swift
//  RamenApp
//
//  Created by 鍋島 由輝 on 2019/02/25.
//  Copyright © 2019 ValJapan. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController {
    
    @IBOutlet var table:UITableView!
    
    // section毎の画像配列
    let imgArray: NSArray = [
        "img0","img1",
        "img2","img3",
        "img4","img5",
        "img6","img7"]
    
    let label2Array: NSArray = [
        "8/23/16:04","8/23/16:15",
        "8/23/16:47","8/23/17:10",
        "8/23/1715:","8/23/17:21",
        "8/23/17:33","8/23/17:41"]
    
    var imageNameArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
}

