//
//  MemberTableViewController.swift
//  ClubManager
//
//  Created by Lam Huong on 12/3/19.
//  Copyright © 2019 Lam Huong. All rights reserved.
//

import UIKit
import SCLAlertView
import FirebaseAuth
import Firebase

struct Member {
    var firstName: String
    var lastName : String
    var ID : String
    var email: String
    var phone : String
    var point : String
}
class MemberTableViewController: UITableViewController {
    var listMember : [Member] = []
    @IBOutlet weak var addMemberButton: UIBarButtonItem!
    //var member = Firestore.firestore().collection("user")
    var collect = ""
    var lastName : String = ""
    var firstName: String = ""
    let mail = Auth.auth().currentUser?.email
    let db = Firestore.firestore()
    override func viewDidLoad() {
        
        super.viewDidLoad()
        tableView.reloadData()
        db.collection("user").getDocuments { (querySnapshot, error) in
                           for acc in querySnapshot!.documents{
                               if (acc.documentID == self.mail){
                                  self.collect = "user"}
                      }
                  }
                  if (collect == "")
                      {
                          collect = "admin"
                      }
        setMemeber()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return listMember.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellMember", for: indexPath)
        let fName = listMember[indexPath.row].firstName
        let lName = listMember[indexPath.row].lastName
        cell.textLabel!.text = lName + " " + fName
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let viewController = storyboard?.instantiateViewController(withIdentifier: "AccountViewController") as? AccountViewController else { return }
            guard let indexPath = tableView.indexPathForSelectedRow else { return }
            let memberSelected = listMember[indexPath.row]
        viewController.fName = memberSelected.firstName
        viewController.lName = memberSelected.lastName
        viewController.ID = memberSelected.ID
        viewController.email = memberSelected.email
        viewController.phone = memberSelected.phone
        viewController.mPoint = memberSelected.point
        
        viewController.forwardView = "MemberTableViewController"
       // performSegue(withIdentifier: "unwindToAccountFromMember", sender: self)
        viewController.modalPresentationStyle = .fullScreen
        present(viewController, animated: false)
    }
    
   
    
    
    @IBAction func addMember(_ sender: Any) {
        if (collect == "admin"){
            transitionHone()
        }
        else {
            
            let alert = SCLAlertView()
            alert.showError("", subTitle: "You can not create new account")
    }
    }
    func setMemeber(){
        db.collection("user").getDocuments { (querySnapshot, err) in
            for user in querySnapshot!.documents{
                let fName = user.data()["firstName"]
                let lName = user.data()["lastName"]
                let ID = user.data()["ID"]
                let email = user.data()["email"]
                let phone = user.data()["phone"]
                let point = user.data()["point"]
                let member = Member(firstName: fName as! String, lastName: lName as! String, ID: ID as! String , email: email as! String, phone: phone as! String, point : point as! String)
                print(member)
                self.listMember.append(member)
//                for i in 0..<self.listMember.count - 1{
//                    for j in 1..<self.listMember.count {
//                        let pointI = self.listMember[i].point
//                        let pointJ = self.listMember[j].point
//                        let pointIInt = Int(pointI)!
//                        let pointJInt = Int(pointJ)!
//                        if (pointIInt < pointJInt) {
//                            self.listMember.swapAt(i,j)
//                        }
//                    }
//                }
//
            }
            self.tableView.reloadData()
        }
        
    }
    
    
    
    func transitionHone(){
           let mainView = storyboard?.instantiateViewController(identifier: Constants.StoryBoard.signUpView ) as? SignUpViewController
           view.window?.rootViewController = mainView
           view.window?.makeKeyAndVisible()
       }
}
