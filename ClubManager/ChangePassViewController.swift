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

    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var confirmPassTextField: UITextField!
    @IBOutlet weak var newPassTextField: UITextField!
    @IBOutlet weak var oldPassTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        errorLabel.alpha = 0
        // Do any additional setup after loading the view.
    }
    func setUpElement(){
        Utilities.styleFilledButton(backButton)
        Utilities.styleHollowButton(saveButton)
        errorLabel.alpha = 0
    }
    @IBAction func backButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func saveTapped(_ sender: Any) {
        
        if (oldPassTextField.text == password)
        {
            if (Utilities.isPasswordValid(newPassTextField.text!) == false)
            {
                errorLabel.text =  "Please check your password is least 8 characters, contains a special character and a number"
                errorLabel.alpha = 1
            }
            else {
            if (newPassTextField.text == confirmPassTextField.text){
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
            else{
                errorLabel.text = "* Password is not match"
                errorLabel.alpha = 1
            }
                
            }
        }
            else {
            errorLabel.text = "Current password is wrong"
            errorLabel.alpha = 1
                }
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
