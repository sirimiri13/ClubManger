//
//  AccountViewController.swift
//  ClubManager
//
//  Created by Lam Huong on 12/3/19.
//  Copyright © 2019 Lam Huong. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase
class AccountViewController: UIViewController {
    var fName: String = ""
    var lName : String = ""
    var ID : String = ""
    var email : String = ""
    var phone : String = ""
    var mPoint : String = ""
    var collect = ""
    var forwardView : String = ""
    let db = Firestore.firestore()
    let mail = Auth.auth().currentUser?.email
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var changePassButton: UIButton!
    
    @IBOutlet weak var backButton: UIButton!
    
    @IBOutlet weak var firstNameLabel: UILabel!
    
    @IBOutlet weak var lastNameLabel: UILabel!
    
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    
    @IBOutlet weak var point: UILabel!
    @IBOutlet weak var pointLabel: UILabel!
    
    override func viewDidLoad() {
       
        super.viewDidLoad()
        setLabel()
        sepUpElement()
        
        
    }
   func sepUpElement(){
        if (forwardView == "MemberTableViewController")
        {
        editButton.alpha = 0
        changePassButton.alpha = 0
        }
        if (fName == "ADMIN"){
            editButton.alpha = 0
            lastNameLabel.textColor = .red
            idLabel.textColor = .red
            phoneLabel.textColor = .red
            pointLabel.alpha = 0
            point.alpha = 0
        }
          Utilities.styleFilledButton(backButton)

      }

   
    func setLabel(){
        print(fName)
        firstNameLabel.text = fName
        lastNameLabel.text = lName
        idLabel.text = ID
        emailLabel.text = email
        phoneLabel.text = phone
        pointLabel.text = mPoint
    
    }
    @IBAction func backTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
   
  

}
