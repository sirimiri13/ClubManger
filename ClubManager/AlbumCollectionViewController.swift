//
//  AlbumCollectionViewController.swift
//  ClubManager
//
//  Created by Lam Huong on 12/24/19.
//  Copyright © 2019 Lam Huong. All rights reserved.
//

import UIKit
import Photos
import Firebase
import BSImagePicker
import SCLAlertView


//private let reuseIdentifier = "Cell"
class cellAlbum: UICollectionViewCell{
    @IBOutlet weak var imageView: UIImageView!
}


class AlbumCollectionViewController: UICollectionViewController,UIImagePickerControllerDelegate , UINavigationControllerDelegate{

    
   
    var count = 0
    let db = Firestore.firestore()
    var albumName : String = ""
    let storageRef = Storage.storage().reference()
    var selectAssets = [PHAsset]()
    var listImage : [UIImage] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        //setListImage()
        collectionView.reloadData()
        print(albumName)
        
        
    }
    
    @IBAction func openLibrary(_ sender: Any) {
       
        let vc = BSImagePickerViewController()
        self.bs_presentImagePickerController(vc, animated: false, select: { (assets: PHAsset) in
        }, deselect: { (assets: PHAsset) in

        }, cancel: {(assets: [PHAsset]) in        }, finish: { (assets: [PHAsset]) in
            for i in 0..<assets.count{
                self.selectAssets.append(assets[i])}
            self.converAssestToImage()
            //self.collectionView.reloadData()
        }, completion: nil)

    }
    
    func converAssestToImage() {
        if selectAssets.count != 0{
            for i in 0..<selectAssets.count{
                let manager = PHImageManager.default()
                let option = PHImageRequestOptions()
                var thumbnail = UIImage()
                option.isSynchronous = true
                manager.requestImage(for: selectAssets[i], targetSize: CGSize(width: 60, height: 60), contentMode: .aspectFill, options: option, resultHandler:  { (result, info) in
                    thumbnail = result!
                })
                let data = thumbnail.jpegData(compressionQuality: 1)
                //let newImage = UIImage(data: data!)
                let storageRef = Storage.storage().reference().child("\(self.albumName)/photo\(String(i))")
              //  let uploadImageRef = storageRef.child(albumName)
                let photoURL = "photoURL" + String(i)
                let photo = "photo" + String(i)
                db.collection("album").document(albumName).updateData(["count": selectAssets.count])
                
                db.collection("album").document(albumName).updateData([photoURL: "gs://loginclubmanager.appspot.com/\(albumName)/\(photo)" ])
                
                let uploadImage = storageRef.putData(data!, metadata: nil) { (metadata, err) in
                    print("upload task finished")
                    print(err ?? "no err")
                    print(metadata ?? "no meta")
                }
                uploadImage.observe(.progress){(snapShot) in
                    print(snapShot.progress ?? "no more progress")
                }
                uploadImage.resume()

            }
           print(" ---- completed \(self.listImage)")
        self.collectionView.reloadData()
        }

    }
    
    func setListImage(){
        db.collection("album").document(albumName).getDocument { (querySnap, err) in
            if err != nil {
                print("Error")
            }
            else {
                self.count = querySnap!.data()!["count"] as! Int
                for i in 0..<self.count {
                    let index = "photoURL" + String(i)
                    print(index)
                    let img = querySnap?.data()![index] as! String
                    print(img)
                    //let newImage = UIImage(data: img)
                    let ref = Storage.storage().reference(forURL: img)
                    ref.getData(maxSize: 1*1024*1024) { (Data, err) in
                        if err != nil {
                            print("Error")
                        }
                        else {
                            let newImg = UIImage(data: Data!)
                            // print("--\(String(describing: newImg))")
                            self.listImage.append(newImg!)
                            print(self.listImage)
                            // self.collectionView.reloadData()
                        }
                    }
                }
                
            }
        }
        print("---\(self.listImage)")
        self.collectionView.reloadData()
    }

    


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        db.collection("album").document(albumName).getDocument { (querySnap, err) in
            if err != nil {
                print("Error")
            }
            else {
                self.count = querySnap!.data()!["count"] as! Int
            }
        }
        return self.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
         let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellAlbum", for: indexPath)
        db.collection("album").document(albumName).getDocument { (querySnap, err) in
            let index = "photoURL" + String(indexPath.row)
            //print(index)
            let img = querySnap?.data()![index] as! String
            //print(img)
            //let newImage = UIImage(data: img)
            let ref = Storage.storage().reference(forURL: img)
            ref.getData(maxSize: 1*1024*1024) { (Data, err) in
                if err != nil {
                    print("Error")
                }
                else {
                    cell.backgroundView?.largeContentImage = UIImage(data: Data!)
                    // print("--\(String(describing: newImg))")
                    //self.listImage.append(newImg!)
                   // print(self.listImage)
                    // self.collectionView.reloadData()
                }
            }
        }
        
       
        // Configure the cell
       // cell.imageView.image =  listImage[indexPath.row]
       cell.backgroundColor = .red
        return cell
    }


}
