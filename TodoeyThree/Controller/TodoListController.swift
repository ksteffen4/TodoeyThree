//
//  ViewController.swift
//  TodoeyThree
//
//  Created by Keith Steffen on 1/9/22.
//

import UIKit

class TodoListController: UITableViewController {

    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        .first!.appendingPathComponent("ToDoList.plist")

    var todoList: [TodoListItem] = [
        TodoListItem("Buy Eggos", false),
        TodoListItem("Slay Dragon", true),
        TodoListItem("Drive Car", false)
    ]

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
        cell.textLabel?.text = todoList[indexPath.row].task
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
                let item = TodoListItem(text, false)
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

    func loadListData() {

        if let data = try? Data(contentsOf: dataFilePath) {
            let decoder = PropertyListDecoder()
            do {
                todoList = try decoder.decode([TodoListItem].self	, from: data)
            } catch {
                print("Error decoding data: \(error)")
            }
            } else {
            print("Error reading data")
        }
        tableView.reloadData()
    }
    
    func saveListData() {
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(todoList)
            try data.write(to: dataFilePath)
        } catch {
            print("An error occured encoding and writing data \(error)")
        }
        tableView.reloadData()
    }
}

