//
//  SubViewController.swift
//  RamenApp
//
//  Created by 鍋島 由輝 on 2019/03/13.
//  Copyright © 2019 ValJapan. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher

class DetailViewController: UIViewController {
    var myUrl: String?
    var titleString: String?
    var detailString: String?

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailTextView: UITextView!
   
    
    override func viewDidLoad() {
        super.viewDidLoad()

        var urlString: String = myUrl!
        
        titleLabel.text = titleString
        detailTextView.text = detailString
        
        let url = URL(string: urlString)
        imageView.kf.indicatorType = .activity
        imageView.kf.setImage(with: url)
        
    }
    @IBAction func reportButton(_ sender: Any) {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
