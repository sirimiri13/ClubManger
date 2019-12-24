//
//  FundsViewController.swift
//  ClubManager
//
//  Created by Lam Huong on 12/3/19.
//  Copyright © 2019 Lam Huong. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase
import SCLAlertView

struct Funds{
    var amount : String
    var reason: String
    var timePost: String
}

class cellFund: UITableViewCell {
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var reasonLabel: UILabel!
 
}

class FundsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
   
    
    
    @IBOutlet weak var addFundButton: UIBarButtonItem!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var fundTableView: UITableView!
    
    var listFund : [Funds] = []
    var collect = ""
    let db = Firestore.firestore()
    let mail = Auth.auth().currentUser?.email
    override func viewDidLoad() {
        super.viewDidLoad()
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
        
        
       
        db.collection("fund").document("total").getDocument { (querySnapshot, err) in
            self.amountLabel.text = querySnapshot?.data()!["amount"] as! String
        }
        setLabel()
        fundTableView.reloadData()
        // Do any additional setup after loading the view.
    }
    
  
    @IBAction func addFunTapped(_ sender: Any) {
        if (collect == "admin"){
            transitionHome()
        }
        else {
            let alert = SCLAlertView()
            alert.showError("", subTitle: "You can not create new fund")
        }
    }
    
    func setLabel(){
        db.collection("fund").getDocuments { (querySnapshot, err) in
            for fund in querySnapshot!.documents{
                if (fund.documentID != "total"){
                    var amount = fund.data()["amount"]
                    var reason = fund.data()["reason"]
                    var timePost = fund.data()["timePost"]
                    let newFund = Funds(amount: amount as! String, reason: reason as! String, timePost: timePost as! String)
                    self.listFund.append(newFund)
                    for i in 0..<self.listFund.count - 1 {
                                    for j in 1..<self.listFund.count {
                                        var dateStringI = self.listFund[i].timePost
                                        var dateStringJ = self.listFund[j].timePost
                                        var dateI = self.stringToDate(string: dateStringI)
                                        var dateJ = self.stringToDate(string: dateStringJ)
                                        if (dateI < dateJ){
                                            self.listFund.swapAt(i, j)
                                        }
                                    }
                                }
                    
                    self.fundTableView.reloadData()
                }
                
            }
        }
    
    }
   
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listFund.count
       }
       
       func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           let cell = fundTableView.dequeueReusableCell(withIdentifier: "cellFund", for: indexPath) as! cellFund
        cell.amountLabel.text = listFund[indexPath.row].amount
        cell.reasonLabel.text = listFund[indexPath.row].reason
           return cell
       }
    
   func transitionHome(){
    let mainView = storyboard?.instantiateViewController(identifier: Constants.StoryBoard.createFundView ) as? CreateFundViewController
          view.window?.rootViewController = mainView
          view.window?.makeKeyAndVisible()
      }
    
    func stringToDate(string: String) -> Date{
           let dateFormatter = DateFormatter()
           dateFormatter.dateFormat = "HH:mm E, d MMM y"
           let date = dateFormatter.date(from: string)
           return date!
       }
}
