//
//  CreateNewClubViewController.swift
//  ClubManager
//
//  Created by Lam Huong on 12/14/19.
//  Copyright © 2019 Lam Huong. All rights reserved.
//

import UIKit
import FirebaseAuth
import  Firebase
import SCLAlertView

class CreateNewClubViewController: UIViewController {
    @IBOutlet weak var errorLabel: UILabel!
    
    @IBOutlet weak var createButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var confirmPassWordTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var newClubTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpElement()
        self.HiddenKeyBoard()
        // Do any additional setup after loading the view.
    }
    @objc func dissmissKeyboard() {
               view.endEditing(true)
           }
    
    func setUpElement(){
        Utilities.styleTextField(newClubTextField)
        Utilities.styleTextField(emailTextField)
        Utilities.styleTextField(passwordTextField)
        Utilities.styleTextField(confirmPassWordTextField)
        Utilities.styleFilledButton(createButton)
        Utilities.styleHollowButton(backButton)
        errorLabel.alpha = 0
    }
    @IBAction func backTapped(_ sender: Any) {
        dismiss(animated: false, completion: nil)
    }
    
    @IBAction func createTapped(_ sender: Any) {
        let error = validateField()
        if (error != nil){
            showError(message: error!)
        }
        else{
            
                let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
                let pass = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
                let club = newClubTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
                Auth.auth().createUser(withEmail: email , password: pass) { (result, err) in
                    if  err != nil {
                        self.showError(message: "* Error creating user")
                    }
                    else{
                       let db =  Firestore.firestore()
                        db.collection("admin").document(email).setData(["email" : email, "club" : club , "pass" : pass ,"uid"  : result?.user.uid ?? ""])  {(error) in
                        if error != nil {
                            self.showError(message: "* Error saving user")
                        }
                        else {
                            let alert = SCLAlertView()
                            alert.showSuccess("", subTitle: "YOUR CLUB IS CREATED")
                            self.transitionHone()
                            }
                    }
                }
            }
        }
            
        
    }
    
    
    func  validateField() -> String? {
        
        if (emailTextField.text == "" || newClubTextField.text == ""){
            return "Please complete all info"
        }
        if (passwordTextField.text != confirmPassWordTextField.text){
            return  "Password is not matched"
        }
        let pass = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        if (Utilities.isPasswordValid(pass) == false){
            return "Please check your password is least 8 characters, contains a special character and a number"
        }
        return nil
    }
    
    func showError(message: String){
        errorLabel.text = message
        errorLabel.alpha = 1
    }
    
    func transitionHone(){
           let mainView = storyboard?.instantiateViewController(identifier: Constants.StoryBoard.mainView ) as? MainViewController
           view.window?.rootViewController = mainView
           view.window?.makeKeyAndVisible()
       }
}
extension CreateNewClubViewController{
    func HiddenKeyBoard(){
        
        let Tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(textDismissKeyboard))
        view.addGestureRecognizer(Tap)
    }
    @objc func textDismissKeyboard(){
        view.endEditing(true)
    }
}
