//
//  ViewController.swift
//  Todoey
//
//  Created by Rachel Drysdale on 27/12/2018.
//  Copyright © 2018 Rachel Drysdale. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
	
	var itemArray = ["Year at a glance", "Future Log", "2019 Goals", "Finances"]

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
	}
	
	// MARK: - TableView Datasource Methods
	
	// Create the same amount of rows as there are items in itemArray
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return itemArray.count
	}
	
	// Create a cell and label it with the text from the corresponding item in itemArray
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
		cell.textLabel?.text = itemArray[indexPath.row]
		return cell
	}
	
	// MARK: - TableView Delegate Methods
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		// print(itemArray[indexPath.row])
		
		// If row doesn't have a checkmark then add a checkmark when tapped, if row does have a checkmark then remove checkmark when tapped
		if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
			tableView.cellForRow(at: indexPath)?.accessoryType = .none
		} else {
			tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
		}
		
		// Animates table view so that when you tap on item it highlights grey briefly but doesn't stay grey as before
		tableView.deselectRow(at: indexPath, animated: true)
	}
	
	//MARK: - Add new items
	
	@IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
		
		var textField = UITextField()
		
		let alert = UIAlertController(title: "Add new to-do item", message: "", preferredStyle: .alert)
		
		let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
			// What will happen once the user clicks the Add Item button on our UIAlert
			// Add item to item array
			self.itemArray.append(textField.text!)
			// At this point even though we have added the item to itemArray, we have not refreshed the view and so the item won't show in the table view, so we need to reload the data
			self.tableView.reloadData()
		}
		
		alert.addTextField { (alertTextField) in
			alertTextField.placeholder = "Create new item"
			textField = alertTextField
		}
		
		alert.addAction(action)
		present(alert, animated: true, completion: nil)
		
	}
	

}

