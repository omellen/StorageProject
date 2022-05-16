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
    var selectedStorage: String = ""
    
    let database = Database.database().reference()
    
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

                var storageExists = false
                for x in self.storages {
                    if locationName == x {
                        storageExists = true
                    }
                }

                if storageExists == false {
                    self.storages.append(locationName)
                }
            }

            DispatchQueue.main.async {
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
            let nameTFT = alert.textFields?[0].text
            self.storages.append(nameTFT!)
            self.tableView.reloadData()
        }
        
        alert.addAction(addAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count = 0
        if storages.isEmpty {
            count = 0
        } else {
            count = self.storages.count
        }
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell")!
        if storages.isEmpty {
            cell.textLabel?.text = ""
        } else {
            cell.textLabel?.text = "\(self.storages[indexPath.row])"
        }
        cell.detailTextLabel?.text = "\(self.arrayOf.quantity[indexPath.row])"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedStorage = "\(storages[indexPath.row])"
        self.performSegue(withIdentifier: "ItemsSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        let vc = segue.destination as! ItemsViewController
        vc.storageTitle = selectedStorage
    }
}

