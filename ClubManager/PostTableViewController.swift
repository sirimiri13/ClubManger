//
//  PostTableViewController.swift
//  ClubManager
//
//  Created by Lam Huong on 12/3/19.
//  Copyright © 2019 Lam Huong. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase
import SCLAlertView


struct Posts {
    var title: String
    var time : String
    var address : String
    var content: String
    var timePost: String
}



class PostTableViewController: UITableViewController {
   // var arrayTime : [Date] = []
    var forwardView : String = ""
    var listPost : [Posts] = []
    var collect = ""
  //  var post = Firestore.firestore().collection("post")
    let db = Firestore.firestore()
    let user = Auth.auth().currentUser?.email 
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.reloadData()
         db.collection("user").getDocuments { (querySnapshot, error) in
                                  for acc in querySnapshot!.documents{
                                      if (acc.documentID == self.user){
                                         self.collect = "user"}
                             }
                         }
                         if (collect == "")
                             {
                                 collect = "admin"
                             }
        
       setPost()
    }

    @IBAction func addPostTapped(_ sender: Any) {
        if (collect == "admin"){
           transitionHome()
        }
        else {
            let alert = SCLAlertView()
            alert.showError("", subTitle: "You can not create new post")
        }
        
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return listPost.count
    }
    
   
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellPost", for: indexPath)
        
        cell.textLabel!.text = listPost[indexPath.row].title
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "PostViewController") as! PostViewController
        let post = listPost[indexPath.row]
        vc.titlePost = post.title
        vc.contentPost = post.content
        vc.addressPost = post.address
        vc.timePost = post.time
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: false)
    }
    
    func setPost(){
        db.collection("post").getDocuments { (querySnapshot, err) in
            for user in querySnapshot!.documents{
               // print(user)
                let tempTitle = user.data()["title"]
                let tempTime = user.data()["time"]
                let tempAddress = user.data()["address"]
                let tempContent = user.data()["content"]
                let timePost = user.data()["timePost"]
                let newPost = Posts(title: tempTitle as! String, time: tempTime as! String, address: tempAddress as! String, content: tempContent as! String, timePost: timePost as! String)
                print(newPost)
                self.listPost.append(newPost)
                for i in 0..<self.listPost.count - 1 {
                    for j in 1..<self.listPost.count {
                        var dateStringI = self.listPost[i].timePost
                        var dateStringJ = self.listPost[j].timePost
                        var dateI = self.stringToDate(string: dateStringI)
                        var dateJ = self.stringToDate(string: dateStringJ)
                        if (dateI < dateJ){
                            self.listPost.swapAt(i, j)
                        }
                    }
                }
    
        
                }
               // print(self.listPost)
                self.tableView.reloadData()
            }
        }

    func stringToDate(string: String) -> Date{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm E, d MMM y"
        let date = dateFormatter.date(from: string)
        return date!
    }
    
    func transitionHome(){
           let mainView = storyboard?.instantiateViewController(identifier: Constants.StoryBoard.createPostView) as? CreatePostViewController
           view.window?.rootViewController = mainView
           view.window?.makeKeyAndVisible()
       }

   
}
