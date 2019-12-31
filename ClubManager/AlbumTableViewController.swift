//
//  AlbumTableViewController.swift
//  ClubManager
//
//  Created by Lam Huong on 12/24/19.
//  Copyright © 2019 Lam Huong. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase


class AlbumTableViewController: UITableViewController {
    var newAlbumTextField = UITextField()
    let storageRef = Storage.storage().reference()
    let db = Firestore.firestore()
    var listAlbum : [String] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        setListAlbum()
        tableView.reloadData()
        
    }

    @IBAction func addAlbum(_ sender: Any) {
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let createAction = UIAlertAction(title: "Create", style: .default, handler:self.createAlbumTapped(alert:))
        let alert = UIAlertController(title: "Create New Album", message: "", preferredStyle:.alert)
        alert.addTextField { (newAlbumTextField) in
            self.setNewAblumTextField(textField: newAlbumTextField)
        }
        alert.addAction(cancelAction)
        alert.addAction(createAction)
        self.present(alert, animated: false)
    }
    func setNewAblumTextField(textField : UITextField){
        newAlbumTextField = textField
        newAlbumTextField.placeholder = "Enter album's name"
    }
    
    func createAlbumTapped(alert: UIAlertAction){
        let album = newAlbumTextField.text
        db.collection("album").document(album!).setData(["albumName": album])
       // db.collection("album").documemnt(album).setData(["albumName" : album])
        //let imagesRef = storageRef.child(album!)
        let vc = storyboard?.instantiateViewController(withIdentifier: "AlbumCollectionViewController") as! AlbumCollectionViewController
        vc.albumName = album!
        let navController = UINavigationController(rootViewController: vc)
        navController.modalPresentationStyle = .fullScreen
        self.present(navController, animated: false)
        
    }
    
    
    func setListAlbum(){
        db.collection("album").getDocuments { (querySnap, err) in
            for album in querySnap!.documents{
                let albumName = album.data()["albumName"] as! String
                self.listAlbum.append(albumName)
                self.tableView.reloadData()
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
        return listAlbum.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "listAlbumCell", for: indexPath)
        cell.textLabel!.text = listAlbum[indexPath.row]
        return cell
    }


    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let album = listAlbum[indexPath.row]
        print("---\(album)")
        let vc = storyboard?.instantiateViewController(withIdentifier: "AlbumCollectionViewController") as! AlbumCollectionViewController
        vc.albumName = album
        let navController = UINavigationController(rootViewController: vc)
        navController.modalPresentationStyle = .fullScreen
        self.present(navController, animated: false)
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
