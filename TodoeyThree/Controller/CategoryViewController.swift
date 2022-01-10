//
//  CategoryViewController.swift
//  TodoeyThree
//
//  Created by Keith Steffen on 1/10/22.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {

    // CoreData context
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    var categories: [TodoCategory] = []
    
    var selectedCategory: TodoCategory? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        if let name = categories[indexPath.row].name {
            cell.textLabel?.text = name
        }
        return cell
    }
    
//MARK: - Add Category button method
    
    @IBAction func addCategoryButtonPressed(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add New Category", message: nil, preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Category", style: .default) { action in
            if let text = alert.textFields?.first?.text, text != "" {
                let category = TodoCategory(context: self.context)
                category.name = text
                self.categories.append(category)
                self.saveCategories()
            }
        }
        alert.addAction(action)
        
        alert.addTextField { textField in
            textField.placeholder = "Create new category"
            
        }
        present(alert, animated: true, completion: nil)

    }
    
    //MARK: - TableView delegate method for row selected
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedCategory = categories[indexPath.row]
        performSegue(withIdentifier: "TodoListSegue", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListController
        destinationVC.category = selectedCategory
    }
    
//MARK: - Data management
    
    func saveCategories() {
        do {
            try context.save()
        } catch {
            print("Error saving category data: \(error)")
        }
        loadCategories()
    }
    
    func loadCategories() {
        let request : NSFetchRequest<TodoCategory> = TodoCategory.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        request.sortDescriptors = [sortDescriptor]
        do {
            categories = try context.fetch(request)
        } catch {
            print("Error retrieving category data: \(error)")
        }
        print("categories: \(categories)")
        tableView.reloadData()

        
    }

}
