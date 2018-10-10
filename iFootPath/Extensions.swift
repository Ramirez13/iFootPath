//
//  Extensions.swift
//  iFootPath
//
//  Created by Viktor on 10/8/18.
//  Copyright © 2018 Viktor. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
    
    func getImageFromStorage(_ imageName: String?) -> UIImage? {
        
        if let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            if let _imageName = imageName {
                let fileURL = documents.appendingPathComponent(_imageName)
                do {
                    let imageData = try Data(contentsOf: fileURL)
                    return UIImage(data: imageData)
                } catch {
                    print("ERROR - getImageFromStorage")
                }
            }
        }
        return nil
    }
    
    
    func saveImage(_ imageName: String?) {
        let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        if let _imageName = imageName {
        if let url = URL(string: "http://www.ifootpath.com/upload/thumbs/" + _imageName ) {
            URLSession.shared.downloadTask(with: url) { location, response, error in
                guard let location = location else {
                    print("ERROR - saveImage: ", error ?? "")
                    
                    return
                }
                do {
                    try FileManager.default.moveItem(at: location, to: documents.appendingPathComponent(response?.suggestedFilename ?? url.lastPathComponent))
                    
                } catch {
                    print(error)
                }
                }.resume()
        }
        }
    }
    
    
    func changeRatingImage(_ rating: String?) -> UIImage? {
        guard rating != nil else { return UIImage.init(named: "start.jpg") }
        let intRating = Double(rating!) ?? 0
        if intRating > 0 && intRating <= 1 {
            return UIImage.init(named: "rating-1.jpg")
        } else if intRating > 1 && intRating <= 2 {
            return UIImage.init(named: "rating-2.jpg")
        } else if intRating > 2 && intRating <= 3 {
            return UIImage.init(named: "rating-3.jpg")
        } else if intRating > 3 && intRating <= 4 {
            return UIImage.init(named: "rating-4.jpg")
        } else if intRating > 4 && intRating <= 5 {
            return UIImage.init(named: "rating-5.jpg")
        } else {
            return UIImage.init(named: "start.jpg")
        }
    }
    
    
    func deleteImageFromStorage(_ localPathName:String) {
        let filemanager = FileManager.default
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask,true)[0] as NSString
        let destinationPath = documentsPath.appendingPathComponent(localPathName)
        do {
            try filemanager.removeItem(atPath: destinationPath)
            print(destinationPath)
        } catch {
            print("ERROR - deleteImageFromStorage")
        }
        
        
    }
    
    
}
