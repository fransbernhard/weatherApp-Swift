//
//  SearchTableViewController.swift
//  weather
//
//  Created by Mimi Lundberg on 2018-03-14.
//  Copyright © 2018 Mimi Lundberg. All rights reserved.
//

import UIKit

class SearchTableViewController: UITableViewController, UISearchResultsUpdating {
    
    var data : [String] = [] // [String]()
    var images : [String] = []
    var searchController : UISearchController! // trust me!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        images = ["1", "2", "3", "1", "2", "3", "1"]
        
        definesPresentationContext = true // magiska flaggan
        
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        
        navigationItem.searchController = searchController
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("VIW DID APPEAR")
        super.viewDidAppear(animated)
        searchController.isActive = true
        DispatchQueue.main.async { [unowned self] in
            self.searchController.searchBar.becomeFirstResponder()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    var shouldUseSearchResult : Bool {
        if let text = searchController.searchBar.text {
            if text.isEmpty {
                return false
            } else {
                return searchController.isActive
            }
        } else {
            return false
        }
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        if let text = searchController.searchBar.text?.lowercased(){
            print("NEW TEXT: \(searchController.searchBar.text ?? "default value")")
            getWeatherData(searchText: text)
        } else {
            print("SET TO ZERO!!!!")
            data = []
        }
    }
    
    func getWeatherData (searchText: String){
        if let safeString = searchText.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), let Url = URL(string: "http://api.openweathermap.org/data/2.5/find?q=\(safeString)&APPID=f342e8974a4922efcb502c12d5d49219") {
            
            let request = URLRequest(url: Url)
            let task = URLSession.shared.dataTask(with: request, completionHandler:{ (data : Data?, response : URLResponse?, error : Error?) in
                if let actualError = error {
                    print(actualError)
                } else {
                    if let actualData = data {
                        
                        let decoder = JSONDecoder()
                        
                        do {
                            let weatherResponse = try decoder.decode(WeatherResponse.self, from: actualData)
                            let cityResponse = try decoder.decode(CityResponse.self, from: actualData)
                            
                            DispatchQueue.main.async {
                                self.data = []
                                for x in 0..<cityResponse.count {
                                    print(weatherResponse.list[x].name! + ", " + weatherResponse.list[x].sys!["country"]!)
                                    self.data.append(weatherResponse.list[x].name! + ", " + weatherResponse.list[x].sys!["country"]!)
                                    print("SELF.DATA.COUNT: ", self.data.count)
                                    self.tableView.reloadData()
                                }
                            }
                        } catch let e {
                            print("Error parsing json: \(e)")
                        }
                        
                    } else {
                        print("Data was nil.")
                    }
                }
            })
            task.resume()
        } else {
            print("Bad url string")
        }
        print(data)
        // return data
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if shouldUseSearchResult {
            return data.count
        } else {
            return 0
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "sCell", for: indexPath) as! SearchTableViewCell
        
        var array : [String]
        
        if shouldUseSearchResult {
            print("NOT SET TO ZERO")
            array = data
        } else {
            print("SET ARRAY TO ZERO")
            array = []
        }
        
        cell.sCellImg.image = UIImage(named: images[indexPath.row])
        cell.sCellLabel?.text = array[indexPath.row]
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
            print("SELECTED ROW: ", data[selectedRow])
            let vc = segue.destination as! DetailViewController
            
            vc.recievedLabel = data[selectedRow]
            vc.recievedImage = images[selectedRow]
            
        }
    }

}
