//
//  ChangePassViewController.swift
//  ClubManager
//
//  Created by Lam Huong on 12/3/19.
//  Copyright © 2019 Lam Huong. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase
import SCLAlertView

class ChangePassViewController: UIViewController {
    let db = Firestore.firestore()
    var collect : String = ""
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var confirmPassTextField: UITextField!
    @IBOutlet weak var newPassTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
          self.HiddenKeyBoard()
        setUpElement()
        let user = Auth.auth().currentUser?.email
        db.collection("user").getDocuments { (querySnapshot, error) in
             for acc in querySnapshot!.documents{
                if (acc.documentID == user){
                    self.collect = "user"}
        }
    }
    if (collect == "")
        {
            collect = "admin"
        }
        
        print(collect)
    }
 
    func setUpElement(){
        Utilities.styleFilledButton(saveButton)
        Utilities.styleHollowButton(backButton)
        errorLabel.alpha = 0
    }
    @IBAction func backButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func saveTapped(_ sender: Any) {
       
            if (Utilities.isPasswordValid(newPassTextField.text!) == false)
            {
                errorLabel.text =  "Please check your password is least 8 characters, contains a special character and a number"
                errorLabel.alpha = 1
            }
            else {
            if (newPassTextField.text == confirmPassTextField.text){
              
                let user = Auth.auth().currentUser?.email
               // let collect = checkCollect(user: user!)
                let currentUser = db.collection(collect).document(user!)
                db.collection(collect).getDocuments{ (querySnapshot, error) in
                    for acc in querySnapshot!.documents{
                        if (acc.documentID == user ){
                            currentUser.updateData(["pass": self.newPassTextField.text!]) { (error) in
                                if error != nil {
                                self.errorLabel.text = error!.localizedDescription
                                self.errorLabel.alpha = 1
                            }
                            }
                        }
                           
                    }
                   
                }
                Auth.auth().currentUser?.updatePassword(to: newPassTextField.text!){(error) in
                    if error != nil {
                      self.errorLabel.text = error!.localizedDescription
                        self.errorLabel.alpha = 1
                    }
                    else
                    {
                        let alert = SCLAlertView()
                        alert.showSuccess("", subTitle: "Your password have been changed")
                        self.dismiss(animated: true, completion: nil)
                    }
                }
            }
                else {
                self.errorLabel.text = "* Password is not match"
                self.errorLabel.alpha = 1
                }
                
            }
 
    }


}
extension ChangePassViewController{
    func HiddenKeyBoard(){
        
        let Tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(textDismissKeyboard))
        view.addGestureRecognizer(Tap)
    }
    @objc func textDismissKeyboard(){
        view.endEditing(true)
    }
}
