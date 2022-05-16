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
    var storages: [String] = []
    
    let database = Database.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = storageTitle
        self.tableview.delegate = self
        tableview.dataSource = self
        tableview.register(UITableView.self, forCellReuseIdentifier: "myCell")
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

            }

            DispatchQueue.main.async {
                self.tableview.reloadData()
            }
        }
    }
    @IBAction func whenAddItemsPressed(_ sender: Any) {
        
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        <#code#>
    }
    


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
