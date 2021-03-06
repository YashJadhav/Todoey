//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Yash Arun Jadhav on 07/09/18.
//  Copyright © 2018 YashJadhav. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController
{
    var categoryArray = [Category]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        loadCategories()
    }

    // MARK: - TableView DataSource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return categoryArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        cell.textLabel?.text = categoryArray[indexPath.row].name
        
        return cell
    }
    
    //MARK:- TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow
        {
            destinationVC.selectedCategory = categoryArray[indexPath.row]
        }
        
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem)
    {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Category", style: .default)
        {
            (action) in
            
            let newCategory = Category(context: self.context)
            newCategory.name = textField.text!
            
            self.categoryArray.append(newCategory)
            
            self.saveCategories()
        }
        alert.addAction(action)
        alert.addTextField
        {
            (field) in
            textField = field
            textField.placeholder = "Create New Category"
        }
        present(alert, animated: true, completion: nil)
    }
    
    //MARK:- Data Manipulation Methods
    func saveCategories()
    {
        do
        {
            try context.save()
        }
        catch
        {
            print("Error saving category \(error)")
        }
        
        tableView.reloadData()
    }
    
    func loadCategories()
    {
        let request: NSFetchRequest<Category> = Category.fetchRequest()
        
        do
        {
            categoryArray = try context.fetch(request)
        }
        catch
        {
            print("Error fetching data from context \(error)")
        }
        tableView.reloadData()
    }
}
