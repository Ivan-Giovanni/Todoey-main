//
//  ViewController.swift
//  Todoey
//
//  Created by Giovanni Zangue on 10/02/2023.
//

import UIKit
import RealmSwift
import ChameleonFramework

class ToDoListViewController: SwipeTableViewController{
    
    var todoItems : Results<Item>?
    let realm = try! Realm()
    
    @IBOutlet weak var SearchBar: UISearchBar!
    
    var selectedCategory : Category? {
        didSet {
            loadItems()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    //MARK: -Navigation bar background color
    
    override func viewWillAppear(_ animated: Bool) {
        
        title = selectedCategory?.name
        
        guard let colorHex = selectedCategory?.color else { fatalError()}
            
        updateNavBar(withHexCode: colorHex)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        guard let originalColor = UIColor(hexString: "#000000") else { fatalError()}
 
        updateNavBar(withHexCode: "#000000")
        
        changeStatusBarColor(color: "#000000")

    }
    
    //MARK: -Nav Bar Setup Methods
    
    func updateNavBar(withHexCode colorHexCode : String) {
        
        guard let navBar = navigationController?.navigationBar else {
            fatalError("Navigation controller does not exist!")
        }
        
        guard let navBarColor = UIColor(hexString: colorHexCode) else { fatalError()}
                
        navBar.backgroundColor = navBarColor
                
        SearchBar.barTintColor = navBarColor
                
        navBar.tintColor = UIColor.init(contrastingBlackOrWhiteColorOn: UIColor(hexString: colorHexCode
                                                                               ), isFlat: true)
                
        navBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.init(contrastingBlackOrWhiteColorOn: navBarColor, isFlat: true)]
        
        changeStatusBarColor(color: colorHexCode)
        
    }
        
    
    //MARK: - Tableview Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return todoItems?.count ?? 1
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let item = todoItems?[indexPath.row] {
            
            cell.textLabel?.text = item.title
            
            if let color = UIColor(hexString: selectedCategory!.color)?.darken(byPercentage:CGFloat(indexPath.row) / CGFloat(todoItems!.count)) {
                cell.backgroundColor = color
                cell.textLabel?.textColor = UIColor.init(contrastingBlackOrWhiteColorOn: color, isFlat: true)
            }

            //Ternary operator ==>
            //value = condition ? valueIfTrue : valueIfFalse
            
            cell.accessoryType = item.done ? .checkmark : .none
            
        }
        else {
            cell.textLabel?.text = "No Items Added"
        }
        
        return cell
        
    }
    
    //MARK: -Tableview Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = todoItems?[indexPath.row] {
            do {
                try realm.write {
                    item.done = !item.done
                }
            }
            catch {
                print("error updating items \(error)")
            }
        }
        
        tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    //MARK: -Add new items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todo Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in

            if let currentCategory = self.selectedCategory {
                do{
                    try self.realm.write {
                        
                        let newItem = Item()
                        newItem.title = textField.text!
                        newItem.dateCreated = Date()
                        currentCategory.items.append(newItem)
                        
                    }
                }
                catch {
                    print("Error saving Items \(error)")
                }
            }

            self.tableView.reloadData()
            
        }
        
        alert.addTextField { (alertTextField) in
            
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
            
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    //MARK: -Model Manipulation Method

    
        func loadItems() {
            
            todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)

            tableView.reloadData()
        }
    
    override func updateModel(at indexPath: IndexPath) {
        
        if let item = todoItems?[indexPath.row] {
            do {
                try realm.write {
                    realm.delete(item)
                }
            }
            catch {
                print("Error deleting Item \(error)")
            }
        }
        
    }
    
    func changeStatusBarColor(color : String) {
        
        let statusBar1 =  UIView()
        statusBar1.frame = UIApplication.shared.statusBarFrame
        statusBar1.backgroundColor = UIColor(hexString: color)
        UIApplication.shared.keyWindow?.addSubview(statusBar1)
        
    }
    
}
//MARK: -SearchBar methods

extension ToDoListViewController : UISearchBarDelegate {
    
    

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        
        tableView.reloadData()

   }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

        if searchBar.text?.count == 0 {

            loadItems()

            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }

        }

    }

}
