//
//  ViewController.swift
//  StorageProject
//
//  Created by Olivia Mellen on 5/2/22.
//

import UIKit
import Firebase

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    let firebase = Database.database().reference()
    
    var arrayOf = ArrayOf()
    var names = String()
    var location = String()
    var quantity = Int()
    
    var storages: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "myCell")
        getStorages()
        
    }
    
    func getStorages() {
        arrayOf.names = []
        arrayOf.location = []
        
        let nameReference = Database.database().reference().child("Item")
        nameReference.observe(.value) { (snapshot) in
            for data in snapshot.children.allObjects as! [DataSnapshot] {
                let name = data.key
                let locationName = data.childSnapshot(forPath: "Location").value as! String
                //let quantity = data.childSnapshot(forPath: "Quantity").value as! Int
                self.arrayOf.names.append(name)
                self.arrayOf.location.append(locationName)
                //self.arrayOf.quantity.append(quantity)
            }
            
            DispatchQueue.main.async {
                var storageExists = false
                for x in self.storages {
                    if self.arrayOf.location.last == x {
                        storageExists = true
                    }
                }
                
                if storageExists == false {
                    self.storages.append(self.arrayOf.location.last!)
                }
                
                print(self.storages)
                self.tableView.reloadData()
            }
        }
    
    }
    
    
    @IBAction func whenButtonPressed(_ sender: Any) {
        let alert = UIAlertController(title: "Add Storage Area", message: "List the name of your new storage area", preferredStyle: .alert)
        
        alert.addTextField { (textfield) in
            textfield.placeholder = "Storage Name"
        }
        
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        
        let addAction = UIAlertAction(title: "Add", style: .default) { (action) in
            
        }
        alert.addAction(addAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrayOf.names.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell")!
        cell.textLabel?.text = "\(self.arrayOf.location[indexPath.row])"
        cell.detailTextLabel?.text = "\(self.arrayOf.quantity[indexPath.row])"
        return cell
    }
}

