//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Giovanni Zangue on 11/02/2023.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    
    var categoryArray = ["Home"]
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()

        
        
    }
    
    //MARK: -TableView DataSource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return categoryArray.count
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        cell.textLabel?.text = categoryArray[indexPath.row]
//        cell.textLabel?.textColor = .magenta
        
        return cell
        
    }
    
    
    //MARK: - Data Manipulation Methods
    
    func saveCategory() {
        do {
            try context.save()
            print("Save category successfully!")
        }
        catch {
            print("Error saving category \(error)")
        }
        tableView.reloadData()
    }
    
    
    //MARK: - Add New Categories

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add a New Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            
            let newCategory = Category(context: self.context)
            newCategory.name = textField.text!
            
            self.categoryArray.append(newCategory.name!)
            
            self.saveCategory()
            
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "New Category"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    //MARK: - TableView Delegate Methods

    
}
