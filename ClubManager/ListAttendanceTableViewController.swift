//
//  ListAttendanceTableViewController.swift
//  ClubManager
//
//  Created by Lam Huong on 12/30/19.
//  Copyright © 2019 Lam Huong. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase

class ListAttendanceTableViewController: UITableViewController {
    var id: String = ""
    let db = Firestore.firestore()
    var listAttendance : [String]  = []
    //var mail : String = ""
    var count = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//mail = (Auth.auth().currentUser?.email)!
        tableView.reloadData()
        setTable()
        print("....\(id)")
        print("+++++ \(listAttendance)")
    }
    
    
   
    func setTable(){
        db.collection("event").getDocuments { (querySnap_event, err) in
           // print("=== \(querySnap_event?.count)")
            for event in querySnap_event!.documents{
                   // print("====\(event.data()["count"])")
                    self.count = event.data()["count"] as! Int
                    for i in 0..<self.count {
                      //  print("=====\(event.documentID)")
                        let index = "ID" + String(i)
                      //  print("===== \(index)")
                        let newID = event.data()[index] as! String
                        //print("....\(newID)")
                        if (newID == self.id){
                            let evt = event.data()["eventName"] as! String
                            print(evt)
                        self.listAttendance.append(evt)
                            print("-------\(self.id)")
                        self.tableView.reloadData()
                        }
                    }

                }
            }
                  
        }
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return listAttendance.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "listAttendanceCell", for: indexPath)
        cell.textLabel!.text = listAttendance[indexPath.row]
        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
