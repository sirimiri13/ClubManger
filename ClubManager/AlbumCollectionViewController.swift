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


//private let reuseIdentifier = "Cell"
class cellAlbum: UICollectionViewCell{
    @IBOutlet weak var imageView: UIImageView!
}


class AlbumCollectionViewController: UICollectionViewController,UIImagePickerControllerDelegate , UINavigationControllerDelegate {

    var albumName : String = ""
    let storageRef = Storage.storage().reference()
    var selectAssets = [PHAsset]()
    var listImage = [UIImage]()
    override func viewDidLoad() {
        super.viewDidLoad()
        storageRef.child(albumName).getData(maxSize: Int64.init()) { (Data, err) in
           if let pic = UIImage(data: Data!) {
            self.listImage.append(pic)
            }
        }
        collectionView.reloadData()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
       // self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
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
//       let picker = UIImagePickerController()
//        picker.sourceType = .photoLibrary
//        //picker.delegate = self
//        self.present(picker, animated: false)
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
                let data = thumbnail.jpegData(compressionQuality: 0.7)
                //let newImage = UIImage(data: data!)
                let uploadImageRef = storageRef.child(albumName)
                let uploadImage = uploadImageRef.putData(data!, metadata: nil) { (metadata, err) in
                    print("upload task finished")
                    print(err ?? "no err")
                    print(metadata ?? "no meta")
                }
                uploadImage.observe(.progress){(snapShot) in
                    print(snapShot.progress ?? "no more progress")
                }
                uploadImage.resume()
                //self.storageNow.child(newImage)
//                var img = UIImageView()
//                img.image = newImage
                
                //self.listImage.append(newImage!)

            }
            print(" ---- completed \(self.listImage)")
          //  self.collectionView.reloadData()
        }

    }
    
    
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
//        listImage.append(image)
//        picker.dismiss(animated: true, completion: nil)
//        self.collectionView.insertItems(at: [IndexPath(item: listImage.count, section: 0)])
//    }
//
//
//
//    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
//        picker.dismiss(animated: true, completion: nil)
//    }


    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return listImage.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellAlbum", for: indexPath) as! cellAlbum
        // Configure the cell
        cell.imageView.image =  listImage[indexPath.row]
        cell.backgroundColor = .red
        return cell
    }


}
