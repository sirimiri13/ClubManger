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
            let alert = SCLAlertView()
            alert.addButton("OK") {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "CreateNewClubViewController") as! CreateNewClubViewController
                vc.modalPresentationStyle = .fullScreen
                self.deleteAccount()
                self.present(vc, animated: false)
                
            }
            alert.showWarning("", subTitle: "The club you are managing will be deleted and created a new club ?")
            }
        else {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "CreateNewClubViewController") as! CreateNewClubViewController
                          vc.modalPresentationStyle = .fullScreen
                          self.present(vc, animated: false)
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
    db.collection (collection).getDocuments()
    {
        (querySnapshot,err) in
            if let err =  err{
                print(err.localizedDescription)
        }
        else {
                for user in querySnapshot!.documents{
                    acc = user.documentID
                    pass = user.data()["pass"] as! String
                    Auth.auth().signIn(withEmail: acc, password: pass) { (result,error) in
                        Auth.auth().currentUser?.delete(completion: { (err) in
                            print("delect \(acc)")
                            self.deleteData(collection: collection)
                        })
                    }
                }
            }
        
        }
    }
    
    func deleteAccount(){
        deleteAccountCollection(collection: "user")
       deleteAccountCollection(collection: "admin")
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

