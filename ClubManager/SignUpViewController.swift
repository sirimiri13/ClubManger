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

    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var passTextField: UITextField!
    @IBOutlet weak var confirmPassTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var IDTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var firstNameTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpElement()

        // Do any additional setup after loading the view.
    }
    
    func setUpElement(){
        errorLabel.alpha = 0
        
        Utilities.styleTextField(firstNameTextField)
        Utilities.styleTextField(lastNameTextField)
        Utilities.styleTextField(IDTextField)
        Utilities.styleTextField(emailTextField)
        Utilities.styleTextField(phoneTextField)
        Utilities.styleTextField(passTextField)
        Utilities.styleTextField(confirmPassTextField)
        Utilities.styleFilledButton(signupButton)
        Utilities.styleHollowButton(cancelButton)
    }

    @IBAction func cancelTapped(_ sender: Any) {
      //  dismiss(animated: true, completion: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    func  validateField() -> String? {
        if (firstNameTextField.text == "" || lastNameTextField.text == "" || IDTextField.text == "" || phoneTextField.text == "" || emailTextField.text == ""){
            return "Please complete all info"
        }
        if (passTextField.text != confirmPassTextField.text){
            return  "Password is not matched"
        }
        let pass = passTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        if (Utilities.isPasswordValid(pass) == false){
            return "Please check your password is least 8 characters, contains a special character and a number"
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
            let pass = passTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
    
            Auth.auth().createUser(withEmail: email , password: pass) { (result, err) in
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
                        alert.showSuccess("", subTitle: "Your account is created!")
                        }
                }
                self.transitionHone()
            }
        }
    }
    }
    
    func showError(message: String){
        errorLabel.text = message
        errorLabel.alpha = 1
    }
    func transitionHone(){
        let mainView = storyboard?.instantiateViewController(identifier: Constants.StoryBoard.loginView ) as? LoginViewController
        view.window?.rootViewController = mainView
        view.window?.makeKeyAndVisible()
    }
}
