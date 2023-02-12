//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Giovanni Zangue on 11/02/2023.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    
    let categoryArray = ["Home", "Work", "Personal","Food"]

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
        
        return cell
        
    }
    
    
    //MARK: - Data MAnipulation Methods
    
    
    //MARK: - Add New Categories

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        
        
    }
    
    //MARK: - TableView Delegate Methods

    
}
