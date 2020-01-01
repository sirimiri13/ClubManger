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
    override func viewDidLoad() {
        super.viewDidLoad()
        
 db.collection("admin").getDocuments { (querySnap, err) in
            if querySnap?.count  == 0 {
               let vc = self.storyboard!.instantiateViewController(withIdentifier: "CreateNewClubViewController") as! CreateNewClubViewController
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: false)
            }
            else{
                let vc = self.storyboard!.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: false)
               
            }
        }

    }

    

}

