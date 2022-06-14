//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Kenneth Sidibe on 2022-06-09.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryViewController: UITableViewController {
    
    var categories:Results<Category>?
    
    //    C'est le context un etat intermediaire entre la base de donnees et les donnees sauvegarde actuellement dans nos variables
    //    Elle se trouve dans notre AppDelegate code c'est pour ca qu'on downcast le delegate qu'on obtient a partir du singleton UIApplication.shared
    
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategories()
    }
    
    // MARK: - Tableview DataSource Method
    
    //    Cette methode retourne le nombre de cellules a generer
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
//        Nil coalescing operator
//        if property is not nil return property, else return ?? "int"
        return categories?.count ?? 1
    }
    
    //    Ici on gere ce que un clique sur une cellule fais
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: K.itemSegueIdentifer, sender: self)
    }
    
    func loadCategories() {

        categories = realm.objects(Category.self)

        tableView.reloadData()
    }
    
    func save(category: Category) {
        do {
            try realm.write({
                realm.add(category)
            })
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
            
            let newCategory = Category()
            newCategory.name = textField.text!
            
            self.save(category: newCategory)
            
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
        
        let category = categories?[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: K.CategoryCellIdentifier, for: indexPath)
        
        cell.textLabel?.text = category?.name ?? "no categories added yet"
        
        return cell
    }
    
    //MARK: - Tableview Delegate Method
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationViewController = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationViewController.selectedCategory = categories?[indexPath.row]
        }
    }
    
    //MARK: - Tableview Manipulation Method
    
    
    
    
    
}
