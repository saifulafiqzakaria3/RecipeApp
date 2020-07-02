//
//  RecipeTypesListController.swift
//  RecipeApp
//
//  Created by Saiful Afiq  on 30/06/2020.
//  Copyright © 2020 Fourtitude. All rights reserved.
//



import UIKit

struct RecipeInfo {
    var recipeType: String
    var recipeList: [String]?
}

class RecipeTypesListController: UIViewController, XMLParserDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UITableViewDelegate, UITableViewDataSource {
    
    fileprivate var recipeTypes: [String]?
    fileprivate var elementName: String = String()
    fileprivate var currentRecipeTypeNameDuringLoop: String?
    fileprivate var chosenRecipeTypeName: String?
    fileprivate var tapToDismiss: UITapGestureRecognizer!
    fileprivate var recipeListByRecipeType = [String : [String]]()  //Dictionary

    
    //MARK: Properties
    @IBOutlet weak var recipeTypesPickerView: UIPickerView!
    @IBOutlet weak var recipeListTableView: UITableView!
    @IBOutlet weak var recipeTypeLabel: UILabel!
    
    
    //MARK: Action
    @IBAction func dismissRecipeTypePickerView() {

    }
    
    
    //MARK: LifeCycle
    override func viewDidLoad() {
        
        // Connect data:
        self.recipeTypesPickerView.delegate = self
        self.recipeTypesPickerView.dataSource = self
        
        // Connect data:
        self.recipeListTableView.delegate = self
        self.recipeListTableView.dataSource = self
        
        //Read the data from the recipetypes.xml
        if let path = Bundle.main.url(forResource: "recipetypes", withExtension: "xml") {
            if let parser = XMLParser(contentsOf: path) {
                parser.delegate = self
                parser.parse()
            }
        }
        
        recipeListTableView.register(UINib(nibName: "SingleRecipeCell", bundle: nil), forCellReuseIdentifier: "SingleRecipeCell")
        recipeListTableView.register(UINib(nibName: "AddRecipeListCell", bundle: nil), forCellReuseIdentifier: "AddRecipeListCell")
        
        //Look for single tap to hide keyboard.
        tapToDismiss = UITapGestureRecognizer(target: self, action: #selector(RecipeTypesListController.dismissRecipeTypePickerView))
        tapToDismiss.cancelsTouchesInView = true
        tapToDismiss.isEnabled = false
        recipeListTableView.addGestureRecognizer(tapToDismiss)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

    }
        
    //MARK: PickerView Delegate
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return recipeListByRecipeType.count
    }
    
    // The data to return for the row and component (column) that's being passed in
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return Array(recipeListByRecipeType)[row].key
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        chosenRecipeTypeName = Array(recipeListByRecipeType)[row].key
        recipeTypeLabel.text = chosenRecipeTypeName
        recipeListTableView.reloadData()
    }
    
    
    //MARK: TableView Delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if chosenRecipeTypeName != nil {
            return recipeListByRecipeType[chosenRecipeTypeName!]!.count + 1
        } else {
            return 0
        }
    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        if chosenRecipeTypeName != nil {
//            if let recipeList = recipeListByRecipeType[chosenRecipeTypeName!] {
//                if indexPath.row != recipeList.count {
//                    return 130
//                }
//            }
//        }
//        return 44
//    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let singleRecipeCell = tableView.dequeueReusableCell(withIdentifier: "SingleRecipeCell", for: indexPath) as! SingleRecipeCell
        if chosenRecipeTypeName != nil {
            if let recipeList = recipeListByRecipeType[chosenRecipeTypeName!] {
                if indexPath.row == recipeList.count {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "AddRecipeListCell", for: indexPath)
                    return cell
                } else {
                    //singleRecipeCell.bindData(recipeName: recipeList[indexPath.row])
                }
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "AddRecipeListCell", for: indexPath)
                return cell
            }
        } else {
            //singleRecipeCell.bindData(recipeName: "Nothing to show...")
        }
        return singleRecipeCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if chosenRecipeTypeName != nil {
            if let recipeList = recipeListByRecipeType[chosenRecipeTypeName!] {
                if indexPath.row == recipeList.count {
                    //Add recipe list
                    showAddRecipeScreen()
                } else {
                    //Go to details Screen
                }
            } else {
                //Add recipe list
                showAddRecipeScreen()
            }
        }
    }
    
    //MARK: XMLParser
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        self.elementName = elementName
    }

    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
//        if elementName == "recipetype" {
//            let book = Book(bookTitle: bookTitle, bookAuthor: bookAuthor)
//            books.append(book)
//        }
    }


    func parser(_ parser: XMLParser, foundCharacters string: String) {
        let data = string.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)

        if (!data.isEmpty) {
            if self.elementName == "name" {
                self.currentRecipeTypeNameDuringLoop = data
            } else if self.elementName == "recipelist" {
                if currentRecipeTypeNameDuringLoop != nil {
                    if recipeListByRecipeType[currentRecipeTypeNameDuringLoop!] == nil {
                        recipeListByRecipeType[currentRecipeTypeNameDuringLoop!] = [data]
                    } else {
                        recipeListByRecipeType[currentRecipeTypeNameDuringLoop!]?.append(data)
                    }
                }
            }
        }
    }
    
    //MARK: Private function
    
    /// Show recipe details screen.
    ///
    /// - Parameter recipeInfo: Info containing image, name and, ingredients
    func showRecipeDetailsScreen(recipeInfo: String) {
        let recipeDetailsController = self.storyboard?.instantiateViewController(withIdentifier: "RecipeDetailsController") as! RecipeDetailsController
        //recipeDetailsController.friendAccountId = friendAccountId
        navigationController?.pushViewController(recipeDetailsController, animated: true)
    }
    
    func showAddRecipeScreen() {
        let addRecipeController = self.storyboard?.instantiateViewController(withIdentifier: "AddRecipeController") as! AddRecipeController
        let nc = UINavigationController(rootViewController: addRecipeController)
        nc.modalPresentationStyle = .overFullScreen
        self.present(nc, animated: true, completion: nil)
        
    }
}
