//
//  ViewController.swift
//  Todoey
//
//  Created by Rachel Drysdale on 27/12/2018.
//  Copyright © 2018 Rachel Drysdale. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
	
	var itemArray = [Item]()
	
	let defaults = UserDefaults.standard

	override func viewDidLoad() {
		super.viewDidLoad()
		
		let newItem = Item()
		newItem.title = "Year at a Glance"
		itemArray.append(newItem)
		
		let newItem2 = Item()
		newItem2.title = "Future Log"
		itemArray.append(newItem2)
		
		let newItem3 = Item()
		newItem3.title = "2019 Goals"
		itemArray.append(newItem3)
		
		if let items = defaults.array(forKey: "TodoListArray") as? [Item] {
			itemArray = items
		}
	}
	
	// MARK: - TableView Datasource Methods
	
	// Create the same amount of rows as there are items in itemArray
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return itemArray.count
	}
	
	// Create a cell and label it with the text from the corresponding item in itemArray
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
		let item = itemArray[indexPath.row]
		cell.textLabel?.text = item.title
		// Ternary operator - change cell accessory type depending on if item.done is true; if true, set accessory type to checkmark, if false, set accessory type to none
		cell.accessoryType = item.done ? .checkmark : .none
		return cell
	}
	
	// MARK: - TableView Delegate Methods
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		// If row doesn't have a checkmark then add a checkmark when tapped, if row does have a checkmark then remove checkmark when tapped
		itemArray[indexPath.row].done = !itemArray[indexPath.row].done
		tableView.reloadData()
		
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
			let newItem = Item()
			newItem.title = textField.text!
			self.itemArray.append(newItem)
			// Save item array into defaults
			self.defaults.set(self.itemArray, forKey: "TodoListArray")
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

