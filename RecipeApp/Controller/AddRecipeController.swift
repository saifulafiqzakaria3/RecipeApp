//
//  AddRecipeController.swift
//  RecipeApp
//
//  Created by Saiful Afiq  on 01/07/2020.
//  Copyright © 2020 Fourtitude. All rights reserved.
//

import UIKit
import Photos
import MobileCoreServices
import PKHUD

class AddRecipeController: UIViewController {
    
    var currentUniqueId: Int?
    var recipeType: String?
    var recipeName: String?
    var ingredients: String?
    var steps: String?
    var imageUrl: String?
    fileprivate var imagePicker =  UIImagePickerController() //Image picker view
    
    //MARK: Properties
    @IBOutlet weak var addNewRecipeScrollView: UIScrollView!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var addButton: UIBarButtonItem!
    @IBOutlet weak var newRecipeImageView: UIImageView!
    @IBOutlet weak var recipeNameTextView: UITextView!
    @IBOutlet weak var ingredientsTextView: UITextView!
    @IBOutlet weak var stepsTextView: UITextView!
    @IBOutlet weak var attachImageButton: UIButton!
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addButtonTapped(_ sender: Any) {
        if recipeNameTextView.text != nil && !recipeNameTextView.text.isEmpty {
            //Show progress HUD
            PKHUD.sharedHUD.contentView = PKHUDProgressView(title: "Processing")
            PKHUD.sharedHUD.show()
            self.recipeName = recipeNameTextView.text
            self.ingredients = ingredientsTextView.text
            self.steps = stepsTextView.text
            var imagePath: String?
            if newRecipeImageView.image != nil {
                let imageName = "\(currentUniqueId! + 1)_\(recipeNameTextView.text)"
                imagePath = "\(NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0])/\(imageName).png"
                let imageUrl: URL = URL(fileURLWithPath: imagePath!)

                //Store Image
                try? newRecipeImageView.image!.pngData()?.write(to: imageUrl)
                self.imageUrl = imagePath
            }
            PKHUD.sharedHUD.hide()
            self.performSegue(withIdentifier: "unwindFromAddRecipeController", sender: self)
        }
    }
    
    @IBAction func attachImageButtonTapped(_ sender: Any) {
        openGallery()
    }
    
    @IBAction func dismissKeyboard(_ sender: Any) {
        view.endEditing(true)
    }
    
    //MARK: LifeCycle
    override func viewDidLoad() {
        self.recipeNameTextView.delegate = self
        self.ingredientsTextView.delegate = self
        self.stepsTextView.delegate = self
        
        //Dismiss the keyboard when tap around the scroll view
        let hideKeyboardTapGesture = UITapGestureRecognizer(target: self, action: #selector(AddRecipeController.dismissKeyboard))
        addNewRecipeScrollView.addGestureRecognizer(hideKeyboardTapGesture)
        
        setupViews()
        
    }
    
    //MARK: Private Function
    func setupViews() {
        addButton.title = "Add"
        newRecipeImageView.image = UIImage(named: "default_food_image")
        addNewRecipeScrollView.frame = CGRect(x: 0, y: self.navigationController!.navigationBar.frame.height, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        addNewRecipeScrollView.contentSize = CGSize(width: addNewRecipeScrollView.frame.width, height: UIScreen.main.bounds.height)
        
        //newRecipeImageView.frame.origin = CGPoint(x: addNewRecipeScrollView.frame.width/2 - newRecipeImageView.frame.width/2, y: 60)
        //attachImageButton.frame.origin = CGPoint(x: newRecipeImageView.frame.origin.x + newRecipeImageView.frame.width - 52, y: 60 + newRecipeImageView.frame.height - 52 )
    }
    
    
}

// MARK: - Input text view
extension AddRecipeController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        if !recipeNameTextView.text.isEmpty {
            addButton.isEnabled = true
        } else {
            addButton.isEnabled = false
        }
    }
    
}

// MARK: - Image Picker Delegate
extension AddRecipeController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    /// Open Gallery
    func openGallery() {
        PHPhotoLibrary.requestAuthorization({ status in
            DispatchQueue.main.async {
                if status == .authorized {
                    self.imagePicker.delegate = self        // UINavigationControllerDelegate
                    self.imagePicker.sourceType = .photoLibrary
                    self.present(self.imagePicker, animated: true, completion: nil)
                } else {
                    //Display permission has not granted to open Photos library
                }
            }
        })
    }
    
    /// Image picker controller only for gallery.
    ///
    /// - Parameters:
    ///   - picker: Image picker controller
    ///   - info: Image info
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        // Dismiss image picker
        imagePicker.dismiss(animated: true, completion: nil)
        if let originalImage = info[.originalImage] as? UIImage {
            newRecipeImageView.image = originalImage
        }
    }
}


