//
//  DetailViewController.swift
//  weather
//
//  Created by Mimi Lundberg on 2018-03-14.
//  Copyright © 2018 Mimi Lundberg. All rights reserved.
//

import UIKit
import AVFoundation

class DetailViewController: UIViewController {
    @IBOutlet weak var degrees: UILabel!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var wTitle: UILabel!
    @IBOutlet weak var favLabel: UILabel!
    @IBOutlet weak var favSwitch: UISwitch!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var sunnyFilter: UIView!
    @IBOutlet weak var windLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var emojLabel: UILabel!
    
    private let dbhelper = DBHelper()
    var recievedLabel: String?
    var recievedImage = String()
    var myAudioPlayer: AVAudioPlayer?

    override func viewDidLoad() {
        super.viewDidLoad()
    
        wTitle.text = recievedLabel!
        self.title = recievedLabel!
        img.image = UIImage(named: recievedImage)
        favSwitch.setOn(dbhelper.isInFav(wTitle.text!), animated: false)
        
        if favSwitch.isOn {
            favLabel?.text = "FAVORITE"
        } else {
            favLabel?.text = "NOT FAVORITE"
        }
        
        getSingleWeatherData(cityName: recievedLabel!)
        
        // ANIMATE WEATHER ICON
        icon.center.y -= 80
        UIView.beginAnimations("tryin", context: nil)
        UIView.setAnimationDuration(2.0)
        UIView.setAnimationDelay(0.2)
        UIView.setAnimationCurve(.easeOut)
        icon.center.y += 80
        UIView.commitAnimations()
    }
    
    // AUDIO FILE 
    func playAudioFile(sound: String) {
        guard let url = Bundle.main.url(forResource: sound, withExtension: "mp3") else {
            return
        }
        
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            try AVAudioSession.sharedInstance().setActive(true)
            
            myAudioPlayer = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
            
            guard let aPlayer = myAudioPlayer else {
                return
            }
            aPlayer.play()
            aPlayer.numberOfLoops = -1
            
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    // CHANGE WEATHER DEGREE SLIDER
    @IBAction func onSlide(_ sender: UISlider) {
        let currentValue = Int(sender.value)
        degrees.text = String("\(currentValue) °C")
        print(sender.value/100);
        sunnyFilter.backgroundColor = UIColor(white: 1, alpha: CGFloat(sender.value/100))
    }
    
    // ADD/REMOVE FAVORITE
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
    
    // GET DETAIL DATA
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
                            let w = try decoder.decode(WeatherResponse.self, from: actualData)
                            
                            DispatchQueue.main.async {
                                print("weatherResponse: ", w)
                                
                                // SET WEATHER VALUES
                                self.degrees.text = "\(w.list[0].tempString) °C"
                                self.windLabel.text = "\(w.list[0].wind!["speed"]!) m/s"
                                self.descriptionLabel.text = "\(w.list[0].weather[0].main!), \(w.list[0].weather[0].description!)"
                                
                                // SET ICON
                                self.icon.image = UIImage(data: w.list[0].iconImageData!)

                                // SET SOUND EFFECTS AND RECOMMENDATIONS
                                let str = w.list[0].weather[0].description!
                                
                                if str.lowercased().range(of:"rain") != nil {
                                    self.playAudioFile(sound: "rain")
                                    self.emojLabel.text = "☔️🧥"
                                } else if str.lowercased().range(of:"drizzle") != nil {
                                    self.playAudioFile(sound: "rain")
                                    self.emojLabel.text = "🧢☂️"
                                } else if str.lowercased().range(of:"thunderstorm") != nil {
                                    self.playAudioFile(sound: "thunder")
                                    self.emojLabel.text = "🎈🔮🔫🍾🦄"
                                } else if str.lowercased().range(of:"clear") != nil {
                                    self.playAudioFile(sound: "clear")
                                    self.emojLabel.text = "🕶"
                                } else if str.lowercased().range(of:"mist") != nil {
                                    self.playAudioFile(sound: "thunder")
                                    self.emojLabel.text = "👓"
                                } else {
                                    self.playAudioFile(sound: "clear")
                                    self.emojLabel.text = "🦄"
                                }
                                
                                // SET BG IMAGE
                                
                                // SET SLIDER + FILER VALUE
                                let i = (w.list[0].tempString as NSString).integerValue
                                self.slider.setValue(Float(i), animated: true)
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
