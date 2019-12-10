//
//  EditAccountViewController.swift
//  ClubManager
//
//  Created by Lam Huong on 12/3/19.
//  Copyright © 2019 Lam Huong. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase
import SCLAlertView
class EditAccountViewController: UIViewController {
    let db = Firestore.firestore()
    @IBOutlet weak var saveButton: UIButton!
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var phoneTextField: UITextField!

    @IBOutlet weak var emailTextField: UILabel!
    @IBOutlet weak var idTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var firstNameTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupElement()
        setTextField()
        // Do any additional setup after loading the view.
    }
    
    
    func setupElement(){
        Utilities.styleHollowButton(saveButton)
        Utilities.styleFilledButton(backButton)
    }
    
    func setTextField(){
        guard let uid = Auth.auth().currentUser?.uid else { return }
        db.collection("user").whereField("uid", isEqualTo: uid).getDocuments { (snapshot, err) in
            if let err = err {
                print(err.localizedDescription)
            }
            else {
                for document in (snapshot?.documents)! {
                    if let firstName = document.data()["firstName"] as? String {
                        self.firstNameTextField.placeholder = firstName
                    }
                    if let lastName = document.data()["lastName"] as? String {
                        self.lastNameTextField.placeholder = lastName
                    }
                    if let phone = document.data()["phone"] as? String {
                        self.phoneTextField.placeholder = phone
                    }
                    if let email = document.data()["email"] as? String {
                        self.emailTextField.text = email
                    }
                    if let ID = document.data()["ID"] as? String {
                        self.idTextField.placeholder = ID                }
                    }
                }
            }
    }
    @IBAction func saveTapped(_ sender: Any) {
        var fName = firstNameTextField.placeholder!
        var lName = lastNameTextField.placeholder!
        var ID = idTextField.placeholder!
        var email = emailTextField.text!
        var phoneNumber = phoneTextField.placeholder!
        
        if (firstNameTextField.text != ""){
            fName = firstNameTextField.text!
        }
        if (lastNameTextField.text != ""){
            lName = lastNameTextField.text!
        }
        if (idTextField.text != ""){
            ID = idTextField.text!
        }
        if (phoneTextField.text != "")
        {
            phoneNumber = phoneTextField.text!
        }
      
        let mailAcc = Auth.auth().currentUser?.email
        let account = db.collection("user").document(mailAcc!)
        account.updateData(["firstName": fName, "lastName" : lName, "ID" : ID , "phone" : phoneNumber]) { (error) in
            if let error = error
            {
                let alert = SCLAlertView()
                alert.showError("", subTitle: error.localizedDescription)
            }
            else{
                self.transitionHone()
                //self.dismiss(animated: true, completion: nil)
                let alert = SCLAlertView()
                alert.showSuccess("", subTitle: "Your Info is Updated")
            }
        }
    }
    
    @IBAction func backTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    func transitionHone(){
           let mainView = storyboard?.instantiateViewController(identifier: Constants.StoryBoard.mainView ) as? MainViewController
           view.window?.rootViewController = mainView
           view.window?.makeKeyAndVisible()
       }

}
