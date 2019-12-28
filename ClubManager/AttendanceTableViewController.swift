//
//  AttendanceTableViewController.swift
//  ClubManager
//
//  Created by Lam Huong on 12/26/19.
//  Copyright © 2019 Lam Huong. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase
import SCLAlertView


class AttendanceTableViewController: UITableViewController {
    
    var count : Int = 0
    //var ID: String = ""
    var collect : String = ""
    var eventList : [String] = []
    var memList =  [MemberAttendance]()
    //var idList: [String] = []
    let db = Firestore.firestore()
    let mail = Auth.auth().currentUser?.email
    var idArray : [String] = []
    var eventTextField = UITextField()
    override func viewDidLoad() {
        super.viewDidLoad()
        checkCollection()
        setEventList()
        tableView.reloadData()
    }
    
    
    func checkCollection(){
        db.collection("user").getDocuments { (querySnapshot, error) in
                 for acc in querySnapshot!.documents{
                     if (acc.documentID == self.mail){
                        self.collect = "user"
                    }
            }
        }
        if (collect == "")
            {
                collect = "admin"
            }
        else {
            self.getID()
        }
    }
    
    func getID() -> String{
        var ID : String = ""
        db.collection("user").document(mail!).getDocument { (querySnapshot, err) in
           ID = querySnapshot?.data()!["ID"] as! String
        }
        return ID
    }
    
    @IBAction func addEvent(_ sender: Any) {
        if (collect != "admin"){
            let alert = SCLAlertView()
            alert.showError("", subTitle: "You can not create new event")
        }
        else {
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                   let createAction = UIAlertAction(title: "Create", style: .default, handler: self.createEvent(alert:))
                   let alert = UIAlertController(title: "Attendance", message: "Create new event?", preferredStyle: .alert)
                   alert.addTextField { (eventTextField) in
                       self.setEventTextField(textField: eventTextField)
                   }
                   alert.addAction(cancelAction)
                   alert.addAction(createAction)
                   self.present(alert, animated: false)
        }
       
        
    }
    
    func setEventTextField(textField: UITextField){
        eventTextField = textField
        eventTextField.placeholder = "Enter event's name"
    }
    func createEvent(alert: UIAlertAction){

        db.collection("event").document(eventTextField.text!).setData(["eventName": eventTextField.text, "count": "0"])
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "AttendanceViewController") as! AttendanceViewController
        vc.eventName = eventTextField.text!
        vc.modalPresentationStyle = .fullScreen
        self.present(vc,animated: false)
    }
    
    func setEventList(){
        db.collection("event").getDocuments { (querySnapshot, err) in
            for info in querySnapshot!.documents{
                let event = info.data()["eventName"]
                self.eventList.append(event as! String)
                self.tableView.reloadData()
            }
        }
    }
        
    
    func getIDList(event: String) -> [String]{
        var idList : [String] = []
        let vc = storyboard?.instantiateViewController(withIdentifier: "AttendanceViewController") as! AttendanceViewController
        var i = 0
               repeat {
                   var id = "ID" + String(i)
                   db.collection("event").document(event).getDocument { (querySnapshot, err) in
                       let idMemberAttendance = querySnapshot?.data()![id] as! String
                    idList.append(idMemberAttendance)
                        i += 1
                }
               } while (i <= vc.countMem)
        return idList
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return eventList.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellAtt", for: indexPath)
        if (collect == "admin"){
             cell.textLabel!.text = eventList[indexPath.row]
        }
//        else {
//            let uid = getID()
//            for event in eventList
//            {
//                getIDList(event: event)
//            }
//        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let event = eventList[indexPath.row]
        print(event)
        let vc = storyboard?.instantiateViewController(withIdentifier: "AttendanceViewController") as! AttendanceViewController
        vc.eventName = event
        //setInfoTable(eventName: event, count: vc.countMem)
       // vc.memInList = memList
        db.collection("event").document(event).getDocument { (querySnapshot, err) in
            vc.count = querySnapshot?.data()!["count"] as! Int
        }
//        for i in 0...vc.count{
//            let mem = pickMember(i: i, eventName: event)
//            vc.memberAttendance.append(mem)
//        }
        
        vc.forwardView = "AttendanceTableViewController"
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: false )
    }

    
//    func pickMember(i: Int, eventName: String) -> MemberAttendance{
//        var newMem : MemberAttendance? = nil
//        let index = "ID" + String(i)
//        db.collection("event").document(eventName).getDocument { (querySnapshot, err) in
//            let idMem = querySnapshot?.data()![index] as! String
//            self.db.collection("user").getDocuments { (querySnapshot_user, err) in
//                for info in querySnapshot_user!.documents{
//                    if idMem == info.data()["ID"] as! String {
//                        let fName = info.data()["firstName"] as! String
//                        let lName = info.data()["lastName"] as! String
//                        let name = lName + " " + fName
//                        newMem = MemberAttendance(name: name, id: idMem)
//                       // memberAttendance.append(newMem)
//                      //  self.tableAttendaceView.reloadData()
//                    }
//                }
//            }
//        }
//        return newMem!
//    }
    
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
