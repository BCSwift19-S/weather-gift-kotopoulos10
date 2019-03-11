//
//  DetailVC.swift
//  WeatherGift
//
//  Created by Tom Kotopoulos on 3/8/19.
//  Copyright © 2019 Tom Kotopoulos. All rights reserved.
//

import UIKit

class DetailVC: UIViewController {

    var locationsArray = [String]()
    var currentPageIndex = 0
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var summaryLabel: UILabel!
    @IBOutlet weak var currentImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        locationLabel.text = locationsArray[currentPageIndex]
        // Do any additional setup after loading the view.
    }
    


}
