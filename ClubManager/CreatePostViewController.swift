//
//  CreatePostViewController.swift
//  ClubManager
//
//  Created by Lam Huong on 12/3/19.
//  Copyright © 2019 Lam Huong. All rights reserved.
//

import UIKit
import SCLAlertView
class CreatePostViewController: UIViewController {
    @IBOutlet weak var titlePost: UITextField!
    @IBOutlet weak var contentPost: UITextView!
    
    @IBAction func PostButton(_ sender: Any) {
        if (titlePost.text == "" || contentPost.text == ""){
            let alert = SCLAlertView()
            alert.showNotice("", subTitle: "Please complete infomation")
        }
        else
        {
            
        }
            
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        contentPost.layer.borderWidth = 1
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
