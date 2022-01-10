//
//  ViewController.swift
//  TodoeyThree
//
//  Created by Keith Steffen on 1/9/22.
//

import UIKit
import CoreData

class TodoListController: UITableViewController {

    // CoreData context
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    var todoList: [Item] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        loadListData()
    }
    
    //MARK: - TableViewDataSource methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath)
        cell.textLabel?.text = todoList[indexPath.row].title
        cell.accessoryType = todoList[indexPath.row].isChecked ? .checkmark : .none
        return cell
    }
    
    //MARK: - TableViewDelegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = indexPath.row
        todoList[row].isChecked.toggle()
        saveListData()
    }
  
    //MARK: - Add Item button pressed method
    
    
    @IBAction func addItemButtonPressed(_ sender: UIBarButtonItem) {
        
        let alert = UIAlertController(title: "Add New Task", message: nil, preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { action in
            if let text = alert.textFields?.first?.text, text != "" {
                let item = Item(context: self.context)
                item.title = text
                item.isChecked = false
                self.todoList.append(item)
                self.saveListData()
            }
        }
        alert.addAction(action)
        
        alert.addTextField { textField in
            textField.placeholder = "Create new task"
            
        }
        present(alert, animated: true, completion: nil)
    }
    

    //MARK: - Database reads and writes

    func loadListData(searchPredicate: NSPredicate? = nil) {
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        if searchPredicate != nil {
            request.predicate = searchPredicate
        }
        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
        request.sortDescriptors = [sortDescriptor]
        do {
            todoList = try context.fetch(request)
        } catch {
            print("Error reading data from CoreData context: \(error)")
        }
        tableView.reloadData()
    }
    
    func saveListData() {
        do {
            try context.save()
        } catch {
            print("Error saving CoreData context: \(error)")
        }
        tableView.reloadData()
    }
}
//MARK: - UISearchBarDelegate methods
    
extension TodoListController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let text = searchBar.text, text != "" {
            let predicate = NSPredicate(format: "title CONTAINS[cd] %@", text)
            loadListData(searchPredicate: predicate)
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            loadListData(searchPredicate: nil)
        }
    }
    
}
