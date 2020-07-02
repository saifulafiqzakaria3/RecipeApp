//
//  Recipe.swift
//  RecipeApp
//
//  Created by Saiful Afiq  on 01/07/2020.
//  Copyright © 2020 Fourtitude. All rights reserved.
//

public class Recipe {

    public var id: Int
    public var name: String?
    public var recipeType: String?
    public var imageUrl: String?
    public var ingredients: String?
    public var steps: String?
    
    public init() {
        self.id = 0
    }
    
    public init(id: Int) {
        switch id {
        case 0:
            self.id = id
            self.name = "Vegetable Soup"
            self.recipeType = "Soup"
            self.imageUrl = nil
            self.ingredients = "1 tablespoon olive oil, 1 medium onion, finely chopped (about 1/2 cup)"
            self.steps = "1) Heat the oil in a 4-quart saucepan over medium-high heat. Add the onion and garlic and cook for 2 minutes or until tender-crisp, stirring often. Add the zucchini and red pepper and cook until tender-crisp. 2) Stir the broth, tomatoes and vinegar in the saucepan and heat to a boil. Reduce the heat to low. Cover and cook for 10 minutes or until the vegetables are tender. Season to taste. Sprinkle with the basil.  Top with the cheese, if desired."
        case 1:
            self.id = id
            self.name = "Fish Taco Salad"
            self.recipeType = "Salads"
            self.imageUrl = ""
            self.ingredients = "1 large avocado, peeled and pitted, 1 cup plain yogurt, 2 medium cloves garlic, chopped"
            self.steps = "Make the dressing by combining the avocado, yogurt, garlic, lime juice, honey, 1/2 teaspoon salt and 1/4 teaspoon pepper in a blender."
        case 2:
            self.id = id
            self.name = "Glazed Donuts"
            self.recipeType = "Dessert"
            self.imageUrl = ""
            self.ingredients = "Whole milk, Sugar, Instant Or Active Dry Yeast, Eggs, Unsalted butter"
            self.steps = ""
        case 3:
            self.id = id
            self.name = "Herbed Chicken Marsala"
            self.recipeType = "Main Dish"
            self.imageUrl = ""
            self.ingredients = ""
            self.steps = ""
        case 4:
            self.id = id
            self.name = "Apple Cinnamon Flavored Water"
            self.recipeType = "Drink"
            self.imageUrl = ""
            self.ingredients = "Apple, Cinnamon, Water"
            self.steps = "Stir until it works"
        default:
            self.id = id
        }
    }
    
    public init(id: Int, name: String?, recipeType: String?, imageUrl: String?, ingredients: String?, steps: String?) {
        self.id = id
        self.name = name
        self.recipeType = recipeType
        self.imageUrl = imageUrl
        self.ingredients = ingredients
        self.steps = steps
    }
    
}
