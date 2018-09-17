//
//  FeedTableViewController.swift
//  shareidea
//
//  Created by Eli Davidson on 9/11/18.
//  Copyright © 2018 Eli Davidson. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth


class FeedTableViewController: UITableViewController {

    
    var Dataref: DatabaseReference!
   var ideashared = [Tweet]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        Dataref = Database.database().reference().child("Ideas-Published")
        ObserveData()
        self.tableView.estimatedRowHeight = 50
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
    }
    
    func ObserveData()
    {
        Dataref.observe(.value, with: { (snapshot:DataSnapshot) in
            
            var newIdeas = [Tweet]()
            
            for Ideas in snapshot.children{
                let IdeaObject = Tweet(snapshot: Ideas as! DataSnapshot)
                newIdeas.append(IdeaObject)
                self.tableView.reloadData()
            }
            self.ideashared = newIdeas
            self.tableView.reloadData()
            
        })
    }
    
    
 
    @IBAction func Addbtn(_ sender: AnyObject) {
        
        let IdeaAlert = UIAlertController(title: "", message: "", preferredStyle: .alert)
        IdeaAlert.addTextField { (textField:UITextField) in
            textField.placeholder = "ex: What if we made a reverse osmosis system inside a water bottle to purify the drinking water from the ocean or creeks"
            IdeaAlert.addAction(UIAlertAction(title: "Send", style: .default, handler: { (action:UIAlertAction) in
                
                if let IdeaContentSender = IdeaAlert.textFields?.first?.text {
                    
                    let ideas = Tweet(idea: IdeaContentSender, UserAdded: "Eli_davidson")
                    
                    let idearef = self.Dataref.child(IdeaContentSender.lowercased())
                    
                    idearef.setValue(ideas.toAnyObject())
                }
                
                
            }))
        }
        self.present(IdeaAlert, animated: true, completion: nil)
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return ideashared.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "feedcell", for: indexPath)

        let idea = ideashared[indexPath.row]
        
        cell.textLabel?.text = idea.idea
        cell.detailTextLabel?.text = idea.UserAdded

        tableView.backgroundColor = .red
        cell.selectionStyle = .none
        
        
        return cell
    }
  
 
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
          let sweet = ideashared[indexPath.row]
            sweet.itemReference?.removeValue()
            
    }
    }

}
