//
//  ViewController.swift
//  ClubManager
//
//  Created by Lam Huong on 12/3/19.
//  Copyright © 2019 Lam Huong. All rights reserved.
//

import UIKit
import  SCLAlertView
import FirebaseAuth
import Firebase

class ViewController: UIViewController {
    
    var emailTextField : UITextField?
    var passTextField: UITextField?
    let db = Firestore.firestore()
    var count = 0
    @IBOutlet weak var createNewClubButton: UIButton!
    
    @IBOutlet weak var loginButton: UIButton!
    
   // @IBOutlet weak var signUpButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpElement()
        db.collection("admin").getDocuments(){(querySnapshot, err) in
        if let err = err {
            print("Error getting documents: \(err)");
        }
        else
        {
            for _ in querySnapshot!.documents {
                self.count += 1
            }
        }
        }
        

        
    }

    @IBAction func createNewClubTapped(_ sender: Any) {
         if (count != 0){
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            let createAction = UIAlertAction(title: "Create", style: .default, handler: self.createNewClub)
            let alert = UIAlertController(title: "Create New Club", message: "The club you are managing will be deleted?", preferredStyle: .alert)
            alert.addTextField { (emailTextField) in
                self.getEmailTextField(textField: emailTextField)
            }
            alert.addTextField { (passTextField) in
                self.getPassTextField(textField: passTextField)
            }
            alert.addAction(cancelAction)
            alert.addAction(createAction)
            self.present(alert, animated: false)
//
        }
        else {
           let vc = self.storyboard?.instantiateViewController(withIdentifier: "CreateNewClubViewController") as! CreateNewClubViewController
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: false)
        }
        
       
    }
    

    func getEmailTextField(textField: UITextField){
        emailTextField = textField
        emailTextField!.placeholder = "Enter admin's account"
    }
    
    func getPassTextField(textField: UITextField){
        passTextField =  textField
        passTextField!.placeholder = "Enter admin's password"
        passTextField?.isSecureTextEntry = true
    }
       
    func createNewClub(alert: UIAlertAction){
        db.collection("admin").getDocuments { (querySnapshot, err) in
            for admin in querySnapshot!.documents{
                let email = admin.data()["email"] as! String
                let pass = admin.data()["pass"] as! String
                if (email == self.emailTextField!.text! &&  pass == self.passTextField!.text){
                self.deleteAccount()
                       let vc = self.storyboard?.instantiateViewController(withIdentifier: "CreateNewClubViewController") as! CreateNewClubViewController
                       vc.modalPresentationStyle = .fullScreen
                       self.present(vc, animated: false)
                }
                else {
                    let anotherAlert = UIAlertController(title: "Something is wrong", message: "The account or password is wrong", preferredStyle: .alert)
                    let cancelAction = UIAlertAction(title: "Try Again!", style: .cancel, handler: nil)
                    anotherAlert.addAction(cancelAction)
                    self.present(anotherAlert, animated: false)
                }
            }
        }

    }
    
    
    func deleteData(collection: String){
        db.collection(collection).getDocuments()
               {
                   (querySnapshot, err) in
                       if let err = err
                       {
                           print("Error getting documents: \(err)");
                       }
                       else
                       {
                        for account in querySnapshot!.documents{
                            account.reference.delete();
                           
                        }
                }
        }
        
    }
    func deleteAccountCollection(collection: String){
        var acc : String = ""
        var pass: String = ""
        db.collection (collection).getDocuments{ (querySnapshot, err) in
            for user in querySnapshot!.documents{
                acc = user.documentID
                pass = user.data()["pass"] as! String
                Auth.auth().signIn(withEmail: acc, password: pass) { (result,error) in
                    Auth.auth().currentUser?.delete(completion: { (err) in
                        print("delect \(acc)")})
                }
            }
        }
        self.deleteData(collection: collection)
                                                      
//        db.collection(collection).getDocuments { (querySnap, err) in
//            for user in querySnap!.documents{
//                let acc = user.data()["email"] as! String
//                let pass = user.data()["pass"] as! String
//                print(acc)
//                print(pass)
//                Auth.auth().signIn(withEmail: acc, password: pass) { (res, err) in}
//                let currentUser = Auth.auth().currentUser
//                print(currentUser?.email)
//                currentUser?.delete(completion: { (err) in})
//            }
//        }
//        self.deleteData(collection: collection)
                                                
    }
    
    func deleteAccount(){
        deleteAccountCollection(collection: "user")
        deleteAccountCollection(collection: "admin")
        deleteData(collection: "post")
        deleteData(collection: "fund")
        deleteData(collection: "event")
        
    }
    
    func setUpElement(){
        Utilities.styleFilledButton(loginButton)
        Utilities.styleFilledButton(createNewClubButton)
      
    }
    func transitionHone(){
        let mainView = storyboard?.instantiateViewController(identifier: Constants.StoryBoard.createNewClubView ) as? CreateNewClubViewController
        view.window?.rootViewController = mainView
        view.window?.makeKeyAndVisible()
    }
}

