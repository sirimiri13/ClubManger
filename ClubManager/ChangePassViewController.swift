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

class ChangePassViewController: UIViewController {
    let db = Firestore.firestore()

    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var confirmPassTextField: UITextField!
    @IBOutlet weak var newPassTextField: UITextField!
    @IBOutlet weak var oldPassTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    func setUpElement(){
        Utilities.styleFilledButton(backButton)
        Utilities.styleHollowButton(saveButton)
    }
    @IBAction func backButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func saveTapped(_ sender: Any) {
        
        /*self.showTextInputPrompt(withMessage: "New Password:") { (userPressedOK, userInput) in
          if let password = userInput {
            self.showSpinner {
              // [START change_password]
              Auth.auth().currentUser?.updatePassword(to: password) { (error) in
                // [START_EXCLUDE]
                self.hideSpinner {
                  self.showTypicalUIForUserUpdateResults(withTitle: self.kChangePasswordText, error: error)
                }
                // [END_EXCLUDE]
              }
              // [END change_password]
            }
          } else {
            self.showMessagePrompt("password can't be empty")
          }
        }*/
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
