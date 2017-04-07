//
//  SpotBusinessViewController.swift
//  Trispective
//
//  Created by USER on 2017/4/2.
//  Copyright © 2017年 Trispective. All rights reserved.
//

import UIKit

class SpotBusinessViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIImagePickerControllerDelegate,UINavigationControllerDelegate{

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.titleTextAttributes=[NSFontAttributeName: UIFont(name: "Helvetica",size: 24)!]
        
        collectionView.delegate=self
        collectionView.dataSource=self
        collectionView.backgroundColor=view.backgroundColor
        let proportion:CGFloat=0.0265
        collectionView.contentInset=UIEdgeInsets(top: view.frame.width*proportion, left: view.frame.width*proportion, bottom: view.frame.width*proportion, right: view.frame.width*proportion)
        let layout=collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.minimumLineSpacing=view.frame.width*proportion
        layout.minimumInteritemSpacing=view.frame.width*proportion
    }

    @IBOutlet weak var collectionView: UICollectionView!
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return DemoImage.imageName.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell=collectionView.dequeueReusableCell(withReuseIdentifier: "pendingCollectionCell", for: indexPath) as! PendingCollectionViewCell
        cell.image.image=UIImage(named: DemoImage.imageName[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width/2*0.92, height: view.frame.height*0.562/2*0.92)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.row)
    }

    @IBAction func showCamera(_ sender: UIButton) {
        
        let alertSheet=UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        alertSheet.addAction(UIAlertAction(title: "Photo Library", style: .default){ _ in
            self.libraryAction()
        })
        
        alertSheet.addAction(UIAlertAction(title: "Camera", style: .default){ _ in
            self.cameraAction()
        })
        
        alertSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel){ _ in
            
        })
        
        self.present(alertSheet,animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            switch(identifier){
            case "showCamera" :
                let upComing=segue.destination as! CameraViewController
                upComing.image=image
                
            default:
                break
            }
        }
    }
    
    func cameraAction() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera){
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera;
            imagePicker.allowsEditing = false
            self.present(imagePicker,animated: true, completion: nil)
        }
        
        
    }
    
    func libraryAction() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary){
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary;
            imagePicker.allowsEditing = false
            self.present(imagePicker,animated: true, completion: nil)
        }
    }
    var image=UIImage()
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let choosedImage = info[UIImagePickerControllerOriginalImage] as? UIImage
        //choosedImgae = choosedImgae?.normalizedImage()
        
        image = choosedImage!
        //self.dismiss(animated: true, completion: nil)
        
        self.performSegue(withIdentifier: "showCamera", sender: nil)
        
        self.dismiss(animated: true, completion: nil)
    }
    

}
