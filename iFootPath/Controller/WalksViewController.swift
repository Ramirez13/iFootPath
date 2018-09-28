//
//  ViewController.swift
//  iFootPath
//
//  Created by Viktor on 19.09.2018.
//  Copyright © 2018 Viktor. All rights reserved.
//

import UIKit
import CoreData


class WalksViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var walksTableView: UITableView!
    
    // MARK: - Constants
    let wallksTableViewCell = WalksTableViewCell()
    
    // MARK: - Variables
    var walksArray   = [WalksInfo]()
    var walksCDArray = [NSManagedObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        
       
       
    
    }
    
    // MARK: - Actions
    @IBAction func refreshWalksButton(_ sender: Any) {
        self.walksArray.removeAll()
        downloadWalks()
    }
    
    
    // MARK: - Method
    func downloadWalks() {
        guard let url = URL(string: "https://www.ifootpath.com/API/get_walks.php") else { return }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else { return }
            guard error == nil else { return }

            do {
                let parseWalks = try JSONDecoder().decode(Walks.self, from: data)
                guard let _parseWalks = parseWalks.walks else { return }
                for walk in _parseWalks {
                    self.walksArray.append(walk)
                }
            } catch let error {
                print("ERROR!!!!!! - \(error)")
            }
            DispatchQueue.main.async {
                self.walksTableView.reloadData()
            }
            }.resume()
    }

    func changeRatingImage(rating: String?) -> UIImage? {
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
    
    
    
}



extension WalksViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return walksArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let walk = walksArray[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "WalksCell", for: indexPath) as! WalksTableViewCell
        cell.titleLabel.text = walk.walkTitle
        cell.detailLabel.text = walk.walkType
        cell.ratingImage.image = changeRatingImage(rating: walk.walkRating)
        
        if let url = URL(string: "http://www.ifootpath.com/upload/thumbs/" + (walk.walkIcon ?? "0")) {
            do {
                let data = try Data(contentsOf: url)
                cell.areaImage.image = UIImage(data: data)
            } catch let error {
                print("ERROR!!!!!! - \(error.localizedDescription)")
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        walksArray.remove(at: indexPath.row)
        
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
    
    
}





