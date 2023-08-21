//
//  ImagePicker.swift
//  Ocory
//
//  Created by Arun Singh on 24/02/21.
//

import Foundation
import UIKit
import TOCropViewController

protocol ImagePickerDelegete {
    
    func disFinishPicking(imgData : Data, img : UIImage)
    
}

class ImagePickerViewControler : UIViewController,  UINavigationControllerDelegate {
    
    let imagePicker = UIImagePickerController()
    
    var imageData : Data!
    
    var imagePickerDelegete : ImagePickerDelegete?
    
    var presentedView = UIViewController()
    
    var cropViewController = TOCropViewController()
    
    var cropStyle:TOCropViewCroppingStyle?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
    }
    
    //MARK:- Show Image Picker Options
    func showImagePicker(viewController:UIViewController){
        
        self.presentedView = viewController
        
        let optionMenu = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        optionMenu.view.tintColor = UIColor.systemBlue
        
        let takePhoto_Action = UIAlertAction(title: "Take Photo", style: .default, handler: { (alert:UIAlertAction!) -> Void in
            
            self.camera()
            
        })
        
        //Picture coose from library
        let choosePhoto_Action = UIAlertAction(title: "Choose Photo", style: .default, handler: {(alert:UIAlertAction) -> Void in
            
            self.photolibrary()
            
        })
        
        //Check device has a camera or not
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            
            //Captrue picture uisng camera
            optionMenu.addAction(takePhoto_Action)
            //Captrue picture uisng library
            optionMenu.addAction(choosePhoto_Action)
            
        }else{
            
            optionMenu.addAction(choosePhoto_Action)
            
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        optionMenu.addAction(cancelAction)
        
        viewController.present(optionMenu, animated: true, completion: nil)
        
    }
    
    //Show Image Picker Only Library Options
    func showImageLibraryPicker(viewController:UIViewController){
        
        self.presentedView = viewController
        
        let optionMenu = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        optionMenu.view.tintColor = UIColor.systemBlue
        
        //Picture coose from library
        let choosePhoto_Action = UIAlertAction(title: "Choose Photo", style: .default, handler: {(alert:UIAlertAction) -> Void in
            
            self.photolibrary()
            
        })
        
        //Check device has a camera or not
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            
            //Captrue picture uisng camera
            // optionMenu.addAction(takePhoto_Action)
            //Captrue picture uisng library
            optionMenu.addAction(choosePhoto_Action)
            
        }else{
            
            optionMenu.addAction(choosePhoto_Action)
            
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        optionMenu.addAction(cancelAction)
        
        viewController.present(optionMenu, animated: true, completion: nil)
        
    }
    
    func camera(){
        
        self.imagePicker.sourceType = .camera
        self.imagePicker.delegate = self
        self.presentedView.present(imagePicker, animated: true, completion: nil)
        
    }
    
    func photolibrary(){
        
        self.imagePicker.sourceType = .photoLibrary
        self.imagePicker.delegate = self
        self.imagePicker.mediaTypes = ["public.image"]//, "public.movie"
        self.presentedView.present(imagePicker, animated: true, completion: nil)
        
    }
    
    
}

//MARK:- Image Picker Controller

extension ImagePickerViewControler : UIImagePickerControllerDelegate{
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        self.presentedView.dismiss(animated: true, completion: nil)
    }
    
}

//MARK:- Image Cropper

extension ImagePickerViewControler : TOCropViewControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        
        self.cropViewController.customAspectRatio = CGSize(width: self.view.frame.width, height: self.view.frame.width)
        
        self.cropStyle = TOCropViewCroppingStyle.default
        
        self.cropViewController = TOCropViewController(croppingStyle: self.cropStyle!, image: selectedImage)
        
        self.cropViewController.toolbar.clampButtonHidden = false
        
        cropViewController.toolbar.rotateClockwiseButtonHidden = false
        
        cropViewController.cropView.setAspectRatio(CGSize(width: self.view.frame.size.width, height: self.view.frame.width), animated: true)
        
        cropViewController.cropView.aspectRatioLockEnabled = false
        
        cropViewController.toolbar.rotateButton.isHidden = false
        
        cropViewController.toolbar.resetButton.isHidden = false
        
        cropViewController.delegate = self
        
        self.presentedView.dismiss(animated: true, completion: {
            self.presentedView.present(self.cropViewController, animated: true, completion: nil)
        })
        
        
        
    }
    
    func cropViewController(_ cropViewController: TOCropViewController, didCropTo image: UIImage, with cropRect: CGRect, angle: Int) {
        
        self.presentedView.dismiss(animated: true, completion: nil)
        
        self.imageData = (image.jpegData(compressionQuality: 0.1))
        
        self.imagePickerDelegete?.disFinishPicking(imgData: self.imageData, img: image)
        
        
    }
}
