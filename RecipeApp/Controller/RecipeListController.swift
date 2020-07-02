//
//  RecipeListController.swift
//  RecipeApp
//
//  Created by Saiful Afiq  on 29/06/2020.
//  Copyright © 2020 Fourtitude. All rights reserved.
//


/*
Hands-On Test – Create a Recipe App
- Create an xml file with recipe types data (recipetypes.xml), use that to populate the recipe types into a UIPickerView control /
- Create a listing page to list out all recipes (filterable by recipe types from recipetypes.xml) /
- Pre-populate your own sample recipes data complying with recipetypes.xml /
- Create an Add Recipe page BASED ON AVAILABLE RECIPE TYPE with picture, ingredients and steps and update the existing list /
- Create a Recipe Detail page that display the recipe’s image along with the ingredients and steps. This page should include update (all displaying items should be editable) and delete feature /
- Use at least one type of persistence method available in iOS to store data (need to use userdefault -- the easiest)
- Upload the project into any public Git hosting services and ensure that your project is buildable
*/


import UIKit

class RecipeListController: UITableViewController, XMLParserDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    static var availableRecipes: [Recipe] = [Recipe(id: 0), Recipe(id: 1), Recipe(id: 2), Recipe(id: 3), Recipe(id: 4)]
    fileprivate var recipeListByRecipeType = [String : [Recipe]]()  //Dictionary
    
    fileprivate var currentUniqueId: Int = 4
    fileprivate var recipeTypes: [String]?
    fileprivate var elementName: String = String()
    fileprivate var chosenRecipeTypeName: String?
    fileprivate var pickerViewIsActive = false
    
    //MARK: Properties
    @IBOutlet weak var recipeTypesPickerView: UIPickerView!
    @IBOutlet weak var recipeTypeNameLabel: UILabel!
    
    //MARK: Action
    
    @IBAction func unwindFromAddRecipeController(_ segue: UIStoryboardSegue) {
        //Need to update the available recipe list
        if let addRecipeController = segue.source as? AddRecipeController, addRecipeController.recipeName != nil {
            currentUniqueId += 1
            let newRecipe = Recipe(id: currentUniqueId, name: addRecipeController.recipeName, recipeType: addRecipeController.recipeType, imageUrl: addRecipeController.imageUrl, ingredients: addRecipeController.ingredients, steps: addRecipeController.steps)
            RecipeListController.availableRecipes.append(newRecipe)
            
            recipeListByRecipeType[addRecipeController.recipeType!]?.append(newRecipe)
            tableView.reloadData()
        }
    }
    
    @IBAction func unwindFromRecipeDetailsController(_ segue: UIStoryboardSegue) {
        //Need to update the available recipe list and the dictionary
        if let recipeDetailsController = segue.source as? RecipeDetailsController {
            updateRecipeInfoByRecipeType(availableRecipeList: RecipeListController.availableRecipes, recipeTypeToFilter: recipeDetailsController.recipe!.recipeType?.lowercased())
        }
        tableView.reloadData()
    }
    
    //MARK: LifeCycle
    override func viewDidLoad() {
        
        //Set the delegate
        self.recipeTypesPickerView.delegate = self
        self.recipeTypesPickerView.dataSource = self
        
        //Read the data from the recipetypes.xml
        if let path = Bundle.main.url(forResource: "recipetypes", withExtension: "xml") {
            if let parser = XMLParser(contentsOf: path) {
                parser.delegate = self
                parser.parse()
            }
        }
        
        tableView.register(UINib(nibName: "SingleRecipeCell", bundle: nil), forCellReuseIdentifier: "SingleRecipeCell")
        tableView.register(UINib(nibName: "AddRecipeListCell", bundle: nil), forCellReuseIdentifier: "AddRecipeListCell")
        
        //Set current unique id
        //UserDefaults.standard.set(currentUniqueId, forKey: "")  //Integer
    }
    
    
    //MARK: TableView Delegate
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 300
        }
        return UITableView.automaticDimension
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0.001
        }
        return UITableView.automaticDimension
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if section == 0 {
            let imageView: UIImageView = UIImageView()
            imageView.clipsToBounds = true
            imageView.contentMode = .scaleAspectFill
            imageView.image =  UIImage(named: "recipe_image")!
            return imageView
        }
        return nil
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 && indexPath.row == 1 {
            //Picker row
            if pickerViewIsActive {
                return 217
            } else {
                return 0
            }
        }  else if indexPath.section == 1 {
            if chosenRecipeTypeName != nil {
                if let recipeList = self.recipeListByRecipeType[chosenRecipeTypeName!] {
                    if indexPath.row != recipeList.count {
                        return 100
                    }
                }
            } else {
                if RecipeListController.availableRecipes.count > 0 {
                    return 100
                }
            }
        }
        return UITableView.automaticDimension
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            if pickerViewIsActive {
                return 2
            } else {
                return 1
            }
        } else {
            if chosenRecipeTypeName != nil {
                return recipeListByRecipeType[chosenRecipeTypeName!]!.count + 1
            } else {
                return RecipeListController.availableRecipes.count
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 1 {
            let singleRecipeCell = tableView.dequeueReusableCell(withIdentifier: "SingleRecipeCell", for: indexPath) as! SingleRecipeCell
            if chosenRecipeTypeName != nil {
                if let recipeList = self.recipeListByRecipeType[chosenRecipeTypeName!] {
                    if indexPath.row == recipeList.count {
                        let cell = tableView.dequeueReusableCell(withIdentifier: "AddRecipeListCell", for: indexPath)
                        return cell
                    } else {
                        singleRecipeCell.bindData(recipeInfo: recipeList[indexPath.row])
                    }
                } else {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "AddRecipeListCell", for: indexPath)
                    return cell
                }
            } else {
                singleRecipeCell.bindData(recipeInfo: RecipeListController.availableRecipes[indexPath.row])
            }
            singleRecipeCell.accessoryType = .disclosureIndicator
            return singleRecipeCell
        } else {
            return super.tableView(tableView, cellForRowAt: indexPath)
        }
    }
    
    //Need this when using dynamic table section in static tableview
    override func tableView(_ tableView: UITableView, indentationLevelForRowAt indexPath: IndexPath) -> Int {
        if indexPath.section == 1 {
            return super.tableView(tableView, indentationLevelForRowAt: IndexPath(row: 0, section: 1))
        }
        
        return super.tableView(tableView, indentationLevelForRowAt: indexPath)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 0 && indexPath.row == 0 {
            //Date of birth row tapped
            pickerViewIsActive = true
            //Show date picker
            tableView.reloadData()
        } else if indexPath.section == 1 {
            if chosenRecipeTypeName != nil {
                if let recipeList = self.recipeListByRecipeType[chosenRecipeTypeName!] {
                    if indexPath.row == recipeList.count {
                        //Add recipe list
                        showAddRecipeScreen(chosenRecipeType: chosenRecipeTypeName!)
                    } else {
                        //Go to details Screen
                        showRecipeDetailsScreen(recipeInfo: recipeList[indexPath.row])
                    }
                } else {
                    //Add recipe list
                    showAddRecipeScreen(chosenRecipeType: chosenRecipeTypeName!)
                }
            } else {
                showRecipeDetailsScreen(recipeInfo: RecipeListController.availableRecipes[indexPath.row])
            }
        }
        
    }
    
    //MARK: PickerView Delegate
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return recipeTypes?.count ?? 0
    }
    
    // The data to return for the row and component (column) that's being passed in
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return recipeTypes?[row] ?? "No Choice"
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        recipeTypeNameLabel.text =  recipeTypes?[row]
        chosenRecipeTypeName = recipeTypes?[row].lowercased()
        //need to filter at this moment
        for recipe in RecipeListController.availableRecipes {
            filterRecipeType(recipe: recipe, typeToFilter: chosenRecipeTypeName!)
        }
        pickerViewIsActive = false
        tableView.reloadData()
    }
    
    //MARK: XMLParser
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        self.elementName = elementName
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        let data = string.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        if (!data.isEmpty) {
            if self.elementName == "name" {
                if recipeTypes == nil {
                    recipeTypes = [data]
                } else {
                    recipeTypes?.append(data)
                }
            }
        }
    }
    
    //MARK: Private function
    
    /// Show recipe details screen.
    ///
    /// - Parameter recipeInfo: Info containing image, name and, ingredients
    func showRecipeDetailsScreen(recipeInfo: Recipe) {
        let recipeDetailsController = self.storyboard?.instantiateViewController(withIdentifier: "RecipeDetailsController") as! RecipeDetailsController
        recipeDetailsController.recipe = recipeInfo
        let nc = UINavigationController(rootViewController: recipeDetailsController)
        nc.modalPresentationStyle = .overFullScreen
        self.present(nc, animated: true, completion: nil)
        //navigationController?.pushViewController(recipeDetailsController, animated: true)
    }
    
    /// Show add new recipe screen.
    ///
    /// - Parameter chosenRecipeType: Recipe type
    func showAddRecipeScreen(chosenRecipeType: String) {
        let addRecipeController = self.storyboard?.instantiateViewController(withIdentifier: "AddRecipeController") as! AddRecipeController
        addRecipeController.recipeType = chosenRecipeType
        addRecipeController.currentUniqueId = currentUniqueId
        let nc = UINavigationController(rootViewController: addRecipeController)
        nc.modalPresentationStyle = .overFullScreen
        self.present(nc, animated: true, completion: nil)
        
    }
    
    /// Filter recipe based on recipe type.
    ///
    /// - Parameter recipe: Recipe Object
    /// - Parameter typeToFilter: Recipe type
    func filterRecipeType(recipe: Recipe, typeToFilter: String) {
        if recipe.recipeType != nil {
            if recipe.recipeType!.lowercased() == typeToFilter.lowercased() {
                if recipeListByRecipeType[typeToFilter.lowercased()] == nil {
                    recipeListByRecipeType[typeToFilter.lowercased()] = [recipe]
                } else {
                    //prevent from putting redundant recipe in the dictionary
                    if !recipeListByRecipeType[typeToFilter.lowercased()]!.contains(where: { $0.id == recipe.id }) {
                        recipeListByRecipeType[typeToFilter.lowercased()]!.append(recipe)
                    }
                    
                }
            }
        }
    }
    
    /// update recipe info when coming back from updating the details.
    ///
    /// - Parameter availableRecipeList: Array of Recipe Objectss
    /// - Parameter recipeTypeToFilter: Recipe type
    func updateRecipeInfoByRecipeType(availableRecipeList: [Recipe]?, recipeTypeToFilter: String?) {
        if availableRecipeList != nil && !availableRecipeList!.isEmpty && recipeTypeToFilter != nil {
            var updatedRecipeListForParticularType: [Recipe]?
            for recipe in availableRecipeList! {
                if recipe.recipeType != nil && recipe.recipeType!.lowercased() == recipeTypeToFilter!.lowercased() {
                    if updatedRecipeListForParticularType == nil {
                        updatedRecipeListForParticularType = [recipe]
                    } else {
                        //prevent from putting redundant recipe in the dictionary
                        if !updatedRecipeListForParticularType!.contains(where: { $0.id == recipe.id }) {
                            updatedRecipeListForParticularType!.append(recipe)
                        }
                        
                    }
                    
                }
            }
            
            if updatedRecipeListForParticularType != nil {
                self.recipeListByRecipeType.updateValue(updatedRecipeListForParticularType!, forKey: recipeTypeToFilter!)
            } else {
                self.recipeListByRecipeType[recipeTypeToFilter!] = []
            }
        }
    }
    
}


