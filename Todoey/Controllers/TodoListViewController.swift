//
//  ViewController.swift
//  Todoey
//
//  Created by Rachel Drysdale on 27/12/2018.
//  Copyright © 2018 Rachel Drysdale. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {
	
	var itemArray = [Item]()
	
	var selectedCategory: Category? {
		didSet {
			loadItems()
		}
	}

	let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

	override func viewDidLoad() {
		super.viewDidLoad()
		
		print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
		
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
		
//		context.delete(itemArray[indexPath.row])
//		itemArray.remove(at: indexPath.row)
		
		itemArray[indexPath.row].done = !itemArray[indexPath.row].done
		saveItems()
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
			let newItem = Item(context: self.context)
			newItem.title = textField.text!
			newItem.done = false
			newItem.parentCategory = self.selectedCategory
			self.itemArray.append(newItem)
			// Save item array into defaults
			self.saveItems()
			// At this point even though we have added the item to itemArray, we have not refreshed the view and so the item won't show in the table view, so we need to reload the data
		}
		
		alert.addTextField { (alertTextField) in
			alertTextField.placeholder = "Create new item"
			textField = alertTextField
		}
		
		alert.addAction(action)
		present(alert, animated: true, completion: nil)
		
	}
	
	// MARK: - Model Manipulation Methods
	
	func saveItems() {
		do {
			try context.save()
		} catch {
			print ("Error saving context \(error)")
		}
		tableView.reloadData()
	}
	
	func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil) {
		let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
		if let additionalPredicate = predicate {
			request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
		} else {
			request.predicate = categoryPredicate
		}
		do {
			itemArray = try context.fetch(request)
		} catch {
			print("Error fetching data from context, \(error)")
		}
		tableView.reloadData()
	}

}

// MARK: - Search Bar Methods

extension TodoListViewController: UISearchBarDelegate {
	
	func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
		let request: NSFetchRequest<Item> = Item.fetchRequest()
		let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
		request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
		
		loadItems(with: request, predicate: predicate)
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
