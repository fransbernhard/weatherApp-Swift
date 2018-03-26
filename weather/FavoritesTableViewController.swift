//
//  FavoritesTableViewController.swift
//  weather
//
//  Created by Mimi Lundberg on 2018-03-14.
//  Copyright © 2018 Mimi Lundberg. All rights reserved.
//

import UIKit

class FavoritesTableViewController: UITableViewController {
    
    var images = [String]()
    var data: [String] = []
    
    private let dbhelper = DBHelper()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        images = ["1", "2", "3", "1", "2", "3", "1"]
        data = dbhelper.getAllData()
        print("yeess", dbhelper.getAllData())
    }
    
    override func viewWillAppear(_ animated: Bool) {
        data = dbhelper.getAllData()
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "fCell", for: indexPath) as! FavoritesTableViewCell

        cell.myImg.image = UIImage(named: images[indexPath.row])
        cell.myLabel?.text = data[indexPath.row]
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let indexPath = tableView.indexPathForSelectedRow {
            let selectedRow = indexPath.row
            let vc = segue.destination as! DetailViewController
            
            vc.recievedLabel = data[selectedRow]
            vc.recievedImage = images[selectedRow]
        }
        
    }

}
