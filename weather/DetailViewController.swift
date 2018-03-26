//
//  DetailViewController.swift
//  weather
//
//  Created by Mimi Lundberg on 2018-03-14.
//  Copyright © 2018 Mimi Lundberg. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var degrees: UILabel!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var wTitle: UILabel!
    @IBOutlet weak var favLabel: UILabel!
    @IBOutlet weak var favSwitch: UISwitch!
    
    private let dbhelper = DBHelper()
    
    var recievedLabel: String?
    var recievedImage = String()
    
    @IBAction func onSlide(_ sender: Any) {
        print("SLIDIN: ")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        wTitle.text = recievedLabel!
        img.image = UIImage(named: recievedImage)
        favSwitch.setOn(dbhelper.isInFav(wTitle.text!), animated: false)
        
        if favSwitch.isOn {
            favLabel?.text = "FAVORITE"
        } else {
            favLabel?.text = "NOT FAVORITE"
        }
        
        print("RECIEVED LABEL: ", recievedLabel!)
        print("GET SINGLE WEATHER DATA: ", getSingleWeatherData(cityName: recievedLabel!))
    }
    
    @IBAction func switchAction(_ sender: Any) {
        if favSwitch.isOn {
            favLabel?.text = "FAVORITE"
            dbhelper.add(city: wTitle.text!)
        } else {
            favLabel?.text = "NOT FAVORITE"
            dbhelper.delete(city: wTitle.text!)
        }
        
        print(dbhelper.getAllData())
    }
    
    func getSingleWeatherData(cityName: String) {
        
        if let safeString = cityName.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), let Url = URL(string: "http://api.openweathermap.org/data/2.5/find?q=\(safeString)&APPID=f342e8974a4922efcb502c12d5d49219") {
            
            let request = URLRequest(url: Url)
            let task = URLSession.shared.dataTask(with: request, completionHandler:{ (data : Data?, response : URLResponse?, error : Error?) in
                if let actualError = error {
                    print(actualError)
                } else {
                    if let actualData = data {
                        
                        let decoder = JSONDecoder()
                        
                        do {
                            let weatherResponse = try decoder.decode(WeatherResponse.self, from: actualData)
                            
                            DispatchQueue.main.async {
                                print("weatherResponse: ", weatherResponse)
                                let hehe = weatherResponse.list[0].main
                                print("PRINT TEMP: \(hehe!["temp"]!)")
                                self.degrees.text = "\(weatherResponse.list[0].tempString) °C"
                                print("ICON!!!!!!: ", weatherResponse.list[0].i)
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
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
