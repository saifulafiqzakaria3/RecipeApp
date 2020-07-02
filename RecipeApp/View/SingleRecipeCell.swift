//
//  SingleRecipeCell.swift
//  RecipeApp
//
//  Created by Saiful Afiq  on 30/06/2020.
//  Copyright © 2020 Fourtitude. All rights reserved.
//

import UIKit

class SingleRecipeCell: UITableViewCell {
    
    //MARK: Properties
    @IBOutlet weak var recipeImageView: UIImageView!
    @IBOutlet weak var recipeNameLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //self.layoutIfNeeded()
    }
    
    /// Bind recipe data.
    ///
    /// - Parameters:
    ///   - recipeInfo: Friend user profile
    func bindData(recipeInfo: Recipe) {
        if recipeInfo.name != nil {
            recipeNameLabel.text = recipeInfo.name
        }
        if recipeInfo.imageUrl != nil && !recipeInfo.imageUrl!.isEmpty {
            let imageUrl: URL = URL(fileURLWithPath: recipeInfo.imageUrl!)
            guard FileManager.default.fileExists(atPath: recipeInfo.imageUrl!) else {
                 return // No image found!
            }
            if let imageData: Data = try? Data(contentsOf: imageUrl) {
                recipeImageView.image = UIImage(data: imageData)
            }
        } else {
            recipeImageView.image = UIImage(named: "default_food_image")
        }
    }
}
