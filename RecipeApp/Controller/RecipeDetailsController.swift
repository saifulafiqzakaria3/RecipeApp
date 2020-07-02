//
//  RecipeDetailsController.swift
//  RecipeApp
//
//  Created by Saiful Afiq  on 30/06/2020.
//  Copyright © 2020 Fourtitude. All rights reserved.
//

import UIKit
import Photos
import MobileCoreServices
import PKHUD

class RecipeDetailsController: UIViewController {
    
    var recipe: Recipe?
    fileprivate var imagePicker =  UIImagePickerController() //Image picker view

    //MARK: Properties
    @IBOutlet weak var detailsContentScrollView: UIScrollView!
    @IBOutlet weak var recipeNameLabel: UILabel!
    @IBOutlet weak var recipeNameTextView: UITextView!
    @IBOutlet weak var recipeImageView: UIImageView!
    @IBOutlet weak var attachImageButton: UIButton!
    @IBOutlet weak var ingredientsTextView: UITextView!
    @IBOutlet weak var stepsTextView: UITextView!
    @IBOutlet weak var deleteRecipeButton: UIButton!
    @IBOutlet weak var updateRecipeButton: UIButton!
    
    //MARK: Action
    @IBAction func updateRecipeButtonTapped(_ sender: Any) {
        
        //Dont allow update if recipe name is empty
        if !recipeNameTextView.text.isEmpty {
            var imagePath: String?
            if recipeImageView.image != nil {
                PKHUD.sharedHUD.contentView = PKHUDProgressView(title: "Processing")
                PKHUD.sharedHUD.show()
                let imageName = "\(recipe!.id)_\(recipe!.name)" // your image name here
                imagePath = "\(NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0])/\(imageName).png"
                let imageUrl: URL = URL(fileURLWithPath: imagePath!)
                
                //Store Image
                try? recipeImageView.image!.pngData()?.write(to: imageUrl)
            }
            let updatedRecipe = Recipe(id: recipe!.id, name: recipeNameTextView.text, recipeType: recipe!.recipeType, imageUrl: imagePath, ingredients: ingredientsTextView.text, steps: stepsTextView.text)
            if let indexRecipeToRemove = RecipeListController.availableRecipes.firstIndex(where: {$0.id == recipe!.id }) {
                RecipeListController.availableRecipes.remove(at: indexRecipeToRemove)
                RecipeListController.availableRecipes.insert(updatedRecipe, at: indexRecipeToRemove)
                PKHUD.sharedHUD.hide()
                self.performSegue(withIdentifier: "unwindFromRecipeDetailsController", sender: self)
            }
        }
    }
    @IBAction func deleteRecipeButtonTapped(_ sender: Any) {
        if let indexRecipeToRemove = RecipeListController.availableRecipes.firstIndex(where: {$0.id == recipe!.id }) {
            RecipeListController.availableRecipes.remove(at: indexRecipeToRemove)
            self.performSegue(withIdentifier: "unwindFromRecipeDetailsController", sender: self)
        }
    }
    
    @IBAction func attachImageButtonTapped(_ sender: Any) {
        openGallery()
    }
    @IBAction func cancelButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func dismissKeyboard(_ sender: Any) {
        view.endEditing(true)
    }
    
    //MARK: LifeCycle
    override func viewDidLoad() {
        
        //Dismiss the keyboard when tap around the scroll view
        let hideKeyboardTapGesture = UITapGestureRecognizer(target: self, action: #selector(RecipeDetailsController.dismissKeyboard))
        detailsContentScrollView.addGestureRecognizer(hideKeyboardTapGesture)
        
        setupViews()
    }
    
    //MARK: Private Function
    
    /// Setup Initial View
    func setupViews() {
        recipeImageView.image = UIImage(named: "default_food_image")
        self.detailsContentScrollView.frame = CGRect(x: 0, y: self.navigationController!.navigationBar.frame.height, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        self.detailsContentScrollView.contentSize = CGSize(width: self.detailsContentScrollView.frame.width, height: UIScreen.main.bounds.height)
        
        updateRecipeButton.setTitleColor(.white, for: .normal)
        updateRecipeButton.backgroundColor = UIColor.blue
        updateRecipeButton.layer.masksToBounds = true
        
        deleteRecipeButton.setTitleColor(.white, for: .normal)
        deleteRecipeButton.backgroundColor = UIColor.red
        deleteRecipeButton.layer.masksToBounds = true
        
        if recipe != nil {
            if recipe!.name != nil {
                recipeNameTextView.text = recipe!.name
            }
            if recipe!.ingredients != nil {
                ingredientsTextView.text = recipe!.ingredients
            }
            if recipe!.steps != nil {
                stepsTextView.text = recipe!.steps
            }
            if recipe!.imageUrl != nil {
                //Do the lengthty process of converting data to image in the background
                DispatchQueue.global(qos: .background).async {
                    let imageUrl: URL = URL(fileURLWithPath: self.recipe!.imageUrl!)
                    guard FileManager.default.fileExists(atPath: self.recipe!.imageUrl!) else {
                         return // No image found!
                    }
                    if let imageData: Data = try? Data(contentsOf: imageUrl) {
                        DispatchQueue.main.async {
                            self.recipeImageView.image = UIImage(data: imageData)
                        }
                    }
                }
            }
        }
    }
}

//MARK: Image Picker Delegate

extension RecipeDetailsController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
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
            recipeImageView.image = originalImage
        }
    }
}
