//
//  DetailInfoViewController.swift
//  iFootPath
//
//  Created by Viktor on 01.10.2018.
//  Copyright © 2018 Viktor. All rights reserved.
//

import UIKit

class DetailInfoViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var districtLabel: UILabel!
    @IBOutlet weak var lengthLabel: UILabel!
    @IBOutlet weak var gradeLabel: UILabel!
    @IBOutlet weak var startCoordLatLabel: UILabel!
    @IBOutlet weak var startCoordLongLabel: UILabel!
    @IBOutlet weak var ilustrationImage: UIImageView!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    
    // MARK: - Varibles
    var detailInfo: Walk?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        showInfo()
        
    }
    

    // MARK: - Method
    func showInfo() {
        guard detailInfo != nil else{ return }
        countryLabel.text = detailInfo?.walkCountry
        districtLabel.text = detailInfo?.walkDistrict
        lengthLabel.text = "Length: \(detailInfo!.walkLength ?? "000")"
        gradeLabel.text = "Grade: \(detailInfo!.walkGrade ?? "000")"
        startCoordLatLabel.text = "Latitude: \(detailInfo!.walkStartCoordLat ?? "000")"
        startCoordLongLabel.text = "Longitude: \(detailInfo!.walkStartCoordLong ?? "000")"
        descriptionTextView.text = detailInfo!.walkDescription ?? "000"
        
//        if let url = URL(string: "http://www.ifootpath.com/upload/thumbs/" + (detailInfo?.walkIllustration ?? "0")) {
//            do {
//                let data = try Data(contentsOf: url)
//                ilustrationImage.image = UIImage(data: data)
//            } catch let error {
//                print("ERROR!!!!!! - \(error.localizedDescription)")
//            }
//        }
    }

}
