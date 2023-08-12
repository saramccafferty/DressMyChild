//
//  LocationTableViewController.swift
//  DressMyChild
//
//  Created by Sara on 24/2/2023.
//

import UIKit

class LocationTableViewController: UITableViewController {
    
    // variable holds an array of Location objects and will be used to populate the table view
    var locations: [Location] = [] {
        // when Location set Location.saveToFile is called to save the locations to a file
        didSet {
            Location.saveToFile(locations: locations)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // set up the left bar button item to be the edit button
        navigationItem.leftBarButtonItem = editButtonItem
        // set up the row height of the table view
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 44.0
        // set the background view of the table view
        tableView.backgroundView = UIImageView(image: UIImage(named: "nightSkyImage"))
        tableView.backgroundView?.alpha = 0.35
        tableView.backgroundView?.contentMode = .scaleAspectFill
        
        // load saved locations from file, otherwise use sample locations
        if let savedLocations = Location.loadFromFile() {
            locations = savedLocations
        } else {
            locations = Location.sampleLocations
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // reload table view data whenever view is about to appear
        tableView.reloadData()
    }
    
    
    // MARK: - Table view data source
    // populate the table view with locations
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locations.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // dequeue a reusable cell of the LocationTableViewCell type and update its contents
        let cell = tableView.dequeueReusableCell(withIdentifier: "LocationTableViewCell", for: indexPath) as!
        LocationTableViewCell
        
        let location = locations[indexPath.row]
        cell.update(with: location)
        cell.showsReorderControl = true
        
        return cell
    }
    
    // for cell being moved to remove from its original position and insert at the new position
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        let movedLocation = locations.remove(at: fromIndexPath.row)
        locations.insert(movedLocation, at: to.row)
    }
    
    // when add button is tapped, navigate to the AddLocationTableViewController
    @IBAction func addButtonTapped(_ sender: UIBarButtonItem) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "AddLocation") as! AddLocationTableViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    // when cell is deleted removes the location at the index path and updates the table view
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            locations.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        } else if editingStyle == .insert {
        }
    }
    
    // when edit button in navigation bar tapped toggle editing mode of the table view allowing user to reorder or delete cells
    @IBAction func editButtonTapped(_ sender: UIBarButtonItem) {
        let tableViewEditingMode = tableView.isEditing
        tableView.setEditing(!tableViewEditingMode, animated: true)
    }
    
    // when row in tablevie wis selected retreive the associated location and navigates to the LocationDetailViewController
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let location = locations[indexPath.row]
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "LocationDetailViewController") as! LocationDetailViewController
        vc.location = location
        self.navigationController?.pushViewController(vc, animated: true)

    }
    
    
    
    // MARK: - Navigation
    
    // retreive nw location added in AddLocationTableViewController when save button tapped and insert new row to tableview
    @IBAction func unwindToLocationTableView(segue: UIStoryboardSegue) {
        guard segue.identifier == "saveUnwind",
              let sourceViewController = segue.source as? AddLocationTableViewController,
              let location = sourceViewController.location else { return }
        
        let newIndexPath = IndexPath(row: locations.count, section: 0)
        locations.append(location)
        tableView.insertRows(at: [newIndexPath], with: .automatic)
        print(locations)
        
    }
    
}
