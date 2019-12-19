//
//  LoginViewController.swift
//  ClubManager
//
//  Created by Lam Huong on 12/5/19.
//  Copyright © 2019 Lam Huong. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase
var view = UIView()
class LoginViewController: UIViewController {
   
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpElement()
          self.HiddenKeyBoard()
        // Do any additional setup after loading the view.
       // view.backgroundColor = .blue
    }
    @objc func dissmissKeyboard() {
               view.endEditing(true)
           }
    
    func setUpElement(){
        emailTextField.backgroundColor = .white
        emailTextField.borderStyle = .roundedRect
        passTextField.backgroundColor = .white
        passTextField.borderStyle = .roundedRect
        errorLabel.alpha = 0
        Utilities.styleTextField(emailTextField)
        Utilities.styleTextField(passTextField)
        Utilities.styleFilledButton(loginButton)
        Utilities.styleHollowButton(backButton)
       
    }

    @IBAction func backTapped(_ sender: Any) {
         dismiss(animated: true, completion: nil)
//        let vc = storyboard?.instantiateViewController(withIdentifier: "ViewController") as! ViewController
//        present(vc, animated: false)
    }
    
    @IBAction func loginTapped(_ sender: Any) {
        let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let pass = passTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        Auth.auth().signIn(withEmail: email, password: pass){ (result,error) in
            if error != nil{
                self.errorLabel.text = "* \(error!.localizedDescription)"  
                self.errorLabel.alpha = 1
            }
            else{
                self.transitionHone()
                
            }
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
    
    func transitionHone(){
        let mainView = storyboard?.instantiateViewController(identifier: Constants.StoryBoard.mainView ) as? MainViewController
        view.window?.rootViewController = mainView
        view.window?.makeKeyAndVisible()
    }
}
extension LoginViewController{
    func HiddenKeyBoard(){
        
        let Tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(textDismissKeyboard))
        view.addGestureRecognizer(Tap)
    }
    @objc func textDismissKeyboard(){
        view.endEditing(true)
    }
}
