//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Kenneth Sidibe on 2022-06-09.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    
    var categoryArray = [Category]()
    //    C'est le context un etat intermediaire entre la base de donnees et les donnees sauvegarde actuellement dans nos variables
    //    Elle se trouve dans notre AppDelegate code c'est pour ca qu'on downcast le delegate qu'on obtient a partir du singleton UIApplication.shared
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategories()
    }
    
    // MARK: - Tableview DataSource Method
    
    //    Cette methode retourne le nombre de cellules a generer
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    //    Ici on gere ce que un clique sur une cellule fais
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: K.itemSegueIdentifer, sender: self)
    }
    
    func loadCategories(with request:NSFetchRequest<Category> = Category.fetchRequest()) {
        
        //        The sort descriptor is used to sort the array of data that will be loaded from our db. The property "key" is the "attribute" from the db that will be fetch to sort the data
        
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        request.sortDescriptors = [sortDescriptor]
        
        do {
            //            Here we fetch from the context which is an intermediate state between the database and the data hold in the current controller
            
            categoryArray = try context.fetch(request)
            
        } catch {
            print("Error while loading data from db, \(error)")
        }
        
        tableView.reloadData()
    }
    
    func saveData() {
        
        do {
            try context.save()
        } catch {
            print("Error while saving the data, \(error)")
        }
        
        tableView.reloadData()
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        //        On crée d'abord les elements de notre alerte
        //        Ici on cree juste un text input
        var textField = UITextField()
        
        
        //        On crée ensuite l'alerte avec son titre et son style
        let alert = UIAlertController(title: "Add new Category", message: "Please add a new category", preferredStyle: .alert)
        
        
        //        On crée ensuite l'action a faire lorsque l'on finis l'alerte ou on appuie entrer
        let action = UIAlertAction(title: "Add item", style: .default) { action in
            
            let newCategory = Category(context: self.context)
            newCategory.name = textField.text
            self.categoryArray.append(newCategory)
            
            self.saveData()
            
        }
        
        //        Ici on recupere les donnees de notre text field
        alert.addTextField { alertTextField in
            textField = alertTextField
        }
        
        //        On ajoute l'action a notre alerte
        alert.addAction(action)
        
        
        //        On presente l'alerte a l'utilisateur
        present(alert, animated: true)
    }
    
    
    //    Cette fonction est chargee de load chaque item contenu dans notre array de depart et retourne chaque cell. Elle est aussi appelle a chaque appel de la fonction tableView.reloadData()
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let category = categoryArray[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: K.CategoryCellIdentifier, for: indexPath)
        
        cell.textLabel?.text = category.name
        
        return cell
    }
    
    //MARK: - Tableview Delegate Method
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationViewController = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationViewController.selectedCategory = categoryArray[indexPath.row]
        }
    }
    
    //MARK: - Tableview Manipulation Method
    
    
    
    
    
}
