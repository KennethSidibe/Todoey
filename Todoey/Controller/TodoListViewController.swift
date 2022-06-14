//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import RealmSwift

class TodoListViewController: UITableViewController {
    
    var todoItems:Results<Item>?
    
    let realm = try! Realm()
    
    var selectedCategory: Category? {
        //        didSet allows us to add a func as soon as our variable is set
        
        didSet {
            loadItems()
        }
    }
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        Permet a plusieurs celulles d'etre cliquable en meme temps
        tableView.allowsMultipleSelection = true
        
    }
    
    //MARK: - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: K.CellIdentifier, for: indexPath)
        
        if let item = todoItems?[indexPath.row] {
            
            cell.textLabel!.text = item.title
            cell.selectionStyle = .none
            
            //        Ternary operator
            //        value = condition ? valueIfTrue : valueIfFalse
            cell.accessoryType = item.done == true ? .checkmark : .none
            
        } else {
            cell.textLabel!.text = "No items added"
        }
        
        return cell
    }
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = self.tableView.cellForRow(at: indexPath)
        
        
        if let item = todoItems?[indexPath.row] {
            
            do {
                //        Save data in persistent container
                
                try realm.write({
                    
//                    Assign the inverse of the done property to the done property of the current object
                    
                    item.done = !item.done

                    
//                    to delete
//                    realm.delete(item)
                })
            } catch {
                print("Error updating the data, \(error)")
            }
        }
        
        tableView.reloadData()
        
        
        
    }
    
    //MARK: - Add new items to list
    
    @IBAction func addButtonPressed(_ sender: Any)  {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new todoey Item : ", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            // What will happen when the add button is pressed
            
            if let currentCategory = self.selectedCategory {
                
                do  {
                    try self.realm.write({
                        let newItem = Item()
                        newItem.title = textField.text!
                        newItem.dateCreated = Date()
                        
                        currentCategory.items.append(newItem)
                    })
                } catch {
                    print("Error saving items, \(error)")
                }
            }
            
            self.tableView.reloadData()
            
        }
        
        alert.addTextField { alertTextField in
            textField = alertTextField
            
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: - Save items
    
    //    func saveItems() {
    //
    //        do {
    //            try context.save()
    //        } catch {
    //            print("Error saving context !, \(error)")
    //        }
    //
    //        self.tableView.reloadData()
    //
    //    }
    
    //MARK: - Load data
    
    func loadItems(){
        
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true).sorted(byKeyPath: "dateCreated", ascending: true)
        
        tableView.reloadData()
        
    }
}

extension TodoListViewController: UISearchBarDelegate {
    
    //MARK: - Search Bar Methods
    
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



