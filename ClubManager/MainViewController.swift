//
//  MainViewController.swift
//  ClubManager
//
//  Created by Lam Huong on 12/5/19.
//  Copyright © 2019 Lam Huong. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase


class MainViewController: UIViewController {
    var mail = Auth.auth().currentUser?.email
    @IBOutlet weak var idLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        if mail == "admin@123.com"{
            idLabel.text = "ADMIN"
        }
        else {
                idLabel.text = mail
        }
    }
    

    @IBAction func signOutTapped(_ sender: Any) {
        try! Auth.auth().signOut()
        /*if let storyboard = self.storyboard {
            let vc = storyboard.instantiateViewController(withIdentifier: "HomeView") as! ViewController
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion:  nil)*/
           let mainView = storyboard?.instantiateViewController(identifier: Constants.StoryBoard.loginView ) as? LoginViewController
           view.window?.rootViewController = mainView
           view.window?.makeKeyAndVisible()
        
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
