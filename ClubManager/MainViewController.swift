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

var collect : String = ""
class MainViewController: UIViewController {
    let db = Firestore.firestore()
    var mail = Auth.auth().currentUser?.email
    @IBOutlet weak var idLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
         db.collection("admin").getDocuments { (querySnapshot, error) in
                    for acc in querySnapshot!.documents{
                        if (acc.documentID == self.mail){
                            self.idLabel.text = "ADMIN"
                            self.idLabel.textColor = #colorLiteral(red: 0.07912478596, green: 0.09655424207, blue: 0.4037392437, alpha: 1)
                           
                        }
                        else {
                            self.db.collection("user").document(self.mail!).getDocument { (snapshot, err) in
                                let fName = snapshot!.data()!["firstName"] as! String
                                let lName = snapshot!.data()!["lastName"] as! String
                                let fullName = lName + " " + fName
                            self.idLabel.text = fullName
                            self.idLabel.textColor = #colorLiteral(red: 0.07912478596, green: 0.09655424207, blue: 0.4037392437, alpha: 1)
                            
                        }
               }
           }
        
    }
    }

    @IBAction func signOutTapped(_ sender: Any) {
        try! Auth.auth().signOut()
        //dismiss(animated: false, completion: nil)
        if let storyboard = self.storyboard {
            let vc = storyboard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion:  nil)
    }
}
    @IBAction func accountTapped(_ sender: Any) {
        let user = Auth.auth().currentUser?.email
        let vc = storyboard?.instantiateViewController(withIdentifier: "AccountViewController") as! AccountViewController
        db.collection("admin").getDocuments { (querySnapshot, error) in
                    for acc in querySnapshot!.documents{
                        if (acc.documentID == self.mail){
                            vc.fName = "ADMIN"
                            vc.lName = "nil"
                            vc.ID = "nil"
                            vc.email = user!
                            vc.phone = "nil"
                            vc.forwardView = "MainViewController"
                            vc.modalPresentationStyle = .fullScreen
                            self.present(vc, animated: false)
                           
                        }
                        else {
                            self.db.collection("user").document(user!).getDocument { (snapshot, err) in
                                vc.fName = snapshot?.data()!["firstName"] as! String
                                vc.lName = snapshot?.data()!["lastName"] as! String
                                vc.ID = snapshot?.data()!["ID"] as! String
                                vc.email = snapshot?.data()!["email"] as! String
                                vc.phone = snapshot?.data()?["phone"] as! String
                                vc.forwardView = "MainViewController"
                                vc.modalPresentationStyle = .fullScreen
                                self.present(vc, animated: false)
                                }
                                }
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

}
