//
//  SignUpViewController.swift
//  ClubManager
//
//  Created by Lam Huong on 12/5/19.
//  Copyright © 2019 Lam Huong. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase
import SCLAlertView


class SignUpViewController: UIViewController {
    let db = Firestore.firestore()
    let acc = Auth.auth().currentUser?.email
    var passUser = ""
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var signupButton: UIButton!
   
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var IDTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var firstNameTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpElement()
          self.HiddenKeyBoard()
        let uid = Auth.auth().currentUser?.uid
        db.collection("admin").whereField("uid", isEqualTo: uid).getDocuments { (snapshot, err) in
        if let err = err {
            print(err.localizedDescription)
        }
        else {
            for document in (snapshot?.documents)! {
                if let password = document.data()["pass"] as? String {
                    self.passUser = password
                    }
                }
            }
        }
    }
    @objc func dissmissKeyboard() {
               view.endEditing(true)
           }
    func setUpElement(){
        errorLabel.alpha = 0
        Utilities.styleTextField(firstNameTextField)
        Utilities.styleTextField(lastNameTextField)
        Utilities.styleTextField(IDTextField)
        Utilities.styleTextField(emailTextField)
        Utilities.styleTextField(phoneTextField)
      
        Utilities.styleFilledButton(signupButton)
        Utilities.styleHollowButton(cancelButton)
    }

   
    
    func  validateField() -> String? {
        if (firstNameTextField.text == "" || lastNameTextField.text == "" || IDTextField.text == "" || phoneTextField.text == "" || emailTextField.text == ""){
            return "Please complete all info"
        }
        return nil
    }
    @IBAction func signupTapped(_ sender: Any) {
        let error = validateField()
        if (error != nil){
            showError(message: error!)
        }
        else{
            let firstName = firstNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let lastName = lastNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let ID = IDTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let phone = phoneTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
          //  let pass = passTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
    
            Auth.auth().createUser(withEmail: email , password: email) { (result, err) in
                if  err != nil {
                    self.showError(message: "* Error creating user")
                }
                else{
                   let db =  Firestore.firestore()
                    db.collection("user").document(email).setData(["firstName": firstName, "lastName" : lastName,"ID" : ID ,"email" : email, "phone" : phone, "uid" : result?.user.uid ?? ""])  {(error) in
                    if error != nil {
                        self.showError(message: "* Error saving user")
                    }
                    else {
                        let alert = SCLAlertView()
                        alert.showSuccess("The account is created!", subTitle: "The password is email")
                        self.lastNameTextField.text = ""
                        self.firstNameTextField.text = ""
                        self.IDTextField.text = ""
                        self.phoneTextField.text = ""
                        self.emailTextField.text = ""
                        self.errorLabel.alpha = 0
                        try! Auth.auth().signOut()
                        try! Auth.auth().signIn(withEmail: self.acc!, password: self.passUser){ (result,error) in
                        }

                    }
                }
            }
        }
    }
        
    }
    
    func showError(message: String){
        errorLabel.text = message
        errorLabel.alpha = 1
    }
    func transitionHone(){
        let mainView = storyboard?.instantiateViewController(identifier: Constants.StoryBoard.mainView) as? MainViewController
        view.window?.rootViewController = mainView
        view.window?.makeKeyAndVisible()
    }
}

extension SignUpViewController{
    func HiddenKeyBoard(){
        
        let Tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(textDismissKeyboard))
        view.addGestureRecognizer(Tap)
    }
    @objc func textDismissKeyboard(){
        view.endEditing(true)
    }
}
