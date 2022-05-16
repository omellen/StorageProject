//
//  ItemsViewController.swift
//  StorageProject
//
//  Created by Olivia Mellen on 5/16/22.
//

import UIKit
import Firebase

class ItemsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableview: UITableView!
    var storageTitle = ""
    
    var arrayOf = ArrayOf()
    var names = String()
    var location = String()
    var quantity = Int()
    
    var items: [String] = []
    
    let database = Database.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = storageTitle
        self.tableview.delegate = self
        tableview.dataSource = self
        tableview.register(UITableViewCell.self, forCellReuseIdentifier: "myCell")
        getItems()
    }
    
    func getItems() {
        arrayOf.itemNames = []
        arrayOf.location = []
        arrayOf.storages = []
        
        let nameReference = Database.database().reference().child("Item")
        nameReference.observe(.value) { (snapshot) in
            for data in snapshot.children.allObjects as! [DataSnapshot] {
                let name = data.key
                let locationName = data.childSnapshot(forPath: "Location").value as! String
                //let quantity = data.childSnapshot(forPath: "Quantity").value as! Int
        
                self.arrayOf.itemNames.append(name)
                self.arrayOf.location.append(locationName)
                //self.arrayOf.quantity.append(quantity)

                if locationName == self.storageTitle {
                    self.items.append(name)
                }
            }

            DispatchQueue.main.async {
                print(self.items)
                self.tableview.reloadData()
            }
        }
    }
    
    
    @IBAction func whenAddItemsPressed(_ sender: Any) {
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count = 0
        if items.isEmpty {
            count = 0
        } else {
            count = self.items.count
        }
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell")!
        if items.isEmpty {
            cell.textLabel?.text = ""
        } else {
            cell.textLabel?.text = "\(self.items[indexPath.row])"
        }
        return cell
    }
    
}
