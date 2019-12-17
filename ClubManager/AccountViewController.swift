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
        }
          Utilities.styleFilledButton(backButton)

      }
//    func setLabel() {
//        db.collection("admin").getDocuments { (querySnapshot, error) in
//                 for acc in querySnapshot!.documents{
//                     if (acc.documentID == self.mail){
//                        self.firstNameLabel.text  = "ADMIN"
//                        self.lastNameLabel.textColor = #colorLiteral(red: 0.9487857223, green: 0.240226537, blue: 0.1816714108, alpha: 1)
//                        self.lastNameLabel.text = "nil"
//                        self.idLabel.textColor = #colorLiteral(red: 0.9487857223, green: 0.240226537, blue: 0.1816714108, alpha: 1)
//                        self.idLabel.text = "nil"
//                        self.phoneLabel.textColor = #colorLiteral(red: 0.9487857223, green: 0.240226537, blue: 0.1816714108, alpha: 1)
//                        self.phoneLabel.text = "nil"
//                        self.emailLabel.text = self.mail
//                        self.editButton.alpha = 0
//                     }
//                     else {
//                          guard let uid = Auth.auth().currentUser?.uid else { return }
//                        self.db.collection("user").whereField("uid", isEqualTo: uid).getDocuments { (snapshot, err) in
//                                if let err = err {
//                                    print(err.localizedDescription)
//                                }
//                                else {
//                                    for document in (snapshot?.documents)! {
//                                        if let firstName = document.data()["firstName"] as? String {
//                                            self.firstNameLabel.text = firstName
//                                        }
//                                        if let lastName = document.data()["lastName"] as? String {
//                                            self.lastNameLabel.text = lastName
//                                        }
//                                        if let phone = document.data()["phone"] as? String {
//                                            self.phoneLabel.text = phone
//                                        }
//                                        if let email = document.data()["email"] as? String {
//                                            self.emailLabel.text = email
//                                        }
//                                        if let ID = document.data()["ID"] as? String {
//                                            self.idLabel.text = ID                }
//                                        }
//                                    }
//                                }
//                     }
//            }
//        }
//    }
//
   
    func setLabel(){
        print(fName)
        firstNameLabel.text = fName
        lastNameLabel.text = lName
        idLabel.text = ID
        emailLabel.text = email
        phoneLabel.text = phone
    
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
