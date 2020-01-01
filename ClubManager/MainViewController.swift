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
import SCLAlertView

var collect : String = ""
class MainViewController: UIViewController {
    var fundTextField : UITextField?
    let db = Firestore.firestore()
    var mail = Auth.auth().currentUser?.email
    var id : String = ""
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
                                self.id = snapshot?.data()!["ID"] as! String
                            
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
    @IBAction func postTapped(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "PostTableViewController") as! PostTableViewController
        vc.forwardView = "Post"
        let navController = UINavigationController(rootViewController: vc)
        navController.modalPresentationStyle = .fullScreen
        self.present(navController, animated: false)
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
        
    @IBAction func fundTapped(_ sender: Any) {
   
        db.collection("fund").getDocuments { (querySnapshot, err) in
            
            if querySnapshot?.count  != 0 {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "FundsViewController") as! FundsViewController
                let navigation = UINavigationController(rootViewController: vc)
                navigation.modalPresentationStyle = .fullScreen
                self.present(navigation, animated: true)
                //self.transitionHome()
            }
            else {
                if (self.idLabel.text == "ADMIN"){
                    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                    let okAction = UIAlertAction(title: "Ok", style: .default, handler: self.createNewFund)
                    let alert = UIAlertController(title: "", message: "You haven't had the funds before. Would you like to create a new one?", preferredStyle: .alert)
                    alert.addAction(cancelAction)
                    alert.addAction(okAction)
                    self.present(alert, animated: false)
                }
                else {
                    let alert = SCLAlertView()
                    alert.showNotice("", subTitle: "The fund does not exist")
                }
            }
        }
    }
    
    func createNewFund(alert: UIAlertAction){
        let anotherAlert = UIAlertController(title: "Create New Fund", message: "Please enter the amount of funds you currently have", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let createAction = UIAlertAction(title: "Create", style: .default, handler: self.addFund(alert:))
        anotherAlert.addAction(cancelAction)
        anotherAlert.addAction(createAction)
        anotherAlert.addTextField { (fundTextField) in
            self.getFund(textField: fundTextField)
        }
        present(anotherAlert, animated:  false)
    }
    
    func getFund(textField: UITextField){
        fundTextField = textField
        fundTextField?.placeholder = "Enter amount of money"
    }
    
    func addFund(alert: UIAlertAction){
        var amount = fundTextField?.text
        db.collection("fund").document("total").setData(["reason" : "", "amount" : amount,"timePost": "" ]) {(err) in
            let anotherAlert = SCLAlertView()
            anotherAlert.showSuccess("", subTitle: "The fund is created")
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "FundsViewController") as! FundsViewController
           let navigation = UINavigationController(rootViewController: vc)
            navigation.modalPresentationStyle = .fullScreen
            self.present(navigation, animated: true)
           // self.transitionHome()
        }
    }
    
    @IBAction func albumTapped(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "AlbumTableViewController") as! AlbumTableViewController
        let navController = UINavigationController(rootViewController: vc)
        navController.modalPresentationStyle = .fullScreen
        self.present(navController,animated: false)
        
    }
    
    
    @IBAction func attendanceTapped(_ sender: Any) {
       // print (self.id)
        if (idLabel.text == "ADMIN") {
            let vc = storyboard?.instantiateViewController(withIdentifier: "AttendanceTableViewController") as! AttendanceTableViewController
            let navController = UINavigationController(rootViewController: vc)
                   navController.modalPresentationStyle = .fullScreen
                   self.present(navController,animated: false)
        }
        else {
            let vc = storyboard?.instantiateViewController(withIdentifier: "ListAttendanceTableViewController") as! ListAttendanceTableViewController
            vc.id = self.id
            let navController = UINavigationController(rootViewController: vc)
            navController.modalPresentationStyle = .fullScreen
            
            self.present(navController,animated: false)
        }
    }
    
    

    
   
    func transitionHome(){
        let mainView = storyboard?.instantiateViewController(identifier: Constants.StoryBoard.fundView) as? FundsViewController
        view.window?.rootViewController = mainView
        view.window?.makeKeyAndVisible()
    }
}
