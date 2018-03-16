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
    
    var recievedLabel: String?
    var recievedImage = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        wTitle.text = recievedLabel!
        img.image = UIImage(named: recievedImage)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
