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
    
    let db = Firestore.firestore()
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var changePassButton: UIButton!
    
    @IBOutlet weak var backButton: UIButton!
    
    @IBOutlet weak var firstNameLabel: UILabel!
    
    @IBOutlet weak var lastNameLabel: UILabel!
    
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sepUpElement()
        setLabel()
        // Do any additional setup after loading the view.
    }
   func sepUpElement(){
    Utilities.styleHollowButton(backButton)
          Utilities.styleFilledButton(changePassButton)
          Utilities.styleHollowButton(editButton)
      }
    func setLabel() {
        let mail = Auth.auth().currentUser?.email
        if (mail == "admin@123.com"){
            firstNameLabel.text  = "ADMIN"
            lastNameLabel.text = "nil"
            idLabel.text = "nil"
            phoneLabel.text = "nil"
            emailLabel.text = mail
            editButton.alpha = 0
        }
        else{
    guard let uid = Auth.auth().currentUser?.uid else { return }
    db.collection("user").whereField("uid", isEqualTo: uid).getDocuments { (snapshot, err) in
        if let err = err {
            print(err.localizedDescription)
        }
        else {
            for document in (snapshot?.documents)! {
                if let firstName = document.data()["firstName"] as? String {
                    self.firstNameLabel.text = firstName
                }
                if let lastName = document.data()["lastName"] as? String {
                    self.lastNameLabel.text = lastName
                }
                if let phone = document.data()["phone"] as? String {
                    self.phoneLabel.text = phone
                }
                if let email = document.data()["email"] as? String {
                    self.emailLabel.text = email
                }
                if let ID = document.data()["ID"] as? String {
                    self.idLabel.text = ID                }
                }
            }
        }
        }
    }
    @IBAction func backTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
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
