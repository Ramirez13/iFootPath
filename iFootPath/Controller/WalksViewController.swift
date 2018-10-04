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
    var walksArray   = [Walk]()
    var infoToBeSent: Walk?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkOnLaunch()
        
    }
    
    // MARK: - Actions
    @IBAction func refreshWalksButton(_ sender: Any) {
        if self.walksArray.isEmpty {
            downloadWalks()
        } else {
            PersistenceManager.deleteData("Walk")
            self.walksArray.removeAll()
            downloadWalks()
        }
     
    
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
                
                self.saveWalkData(data: _parseWalks)
                
            } catch let error {
                print("ERROR!!!!!! - \(error)")
            }
            DispatchQueue.main.async {
                self.walksTableView.reloadData()
            }
            }.resume()
    }
    
    func changeRatingImage(rating: String?) -> UIImage? {
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
    
    func saveWalkData(data: [WalksInfo]) {
        
        for number in data {
            let walk = Walk(context: PersistenceManager.context)
            walk.walkTitle = number.walkTitle
            walk.walkType = number.walkType
            walk.walkIcon = number.walkIcon
            walk.walkRating = number.walkRating
            walk.walkCountry = number.walkCountry
            walk.walkDistrict = number.walkDistrict
            walk.walkLength = number.walkLength
            walk.walkGrade = number.walkGrade
            walk.walkStartCoordLat = number.walkStartCoordLat
            walk.walkStartCoordLong = number.walkStartCoordLong
            walk.walkIllustration = number.walkIllustration
            walk.walkDescription = number.walkDescription
            walk.WalkID = number.walkID
            
            self.walksArray.append(walk)
            
        }
        PersistenceManager.saveContext()
    }
    
   
    
    func fetchWalkData() {
        let fetchRequest: NSFetchRequest<Walk> = Walk.fetchRequest()
        do {
            let walksArray = try PersistenceManager.context.fetch(fetchRequest)
            self.walksArray = walksArray
            self.walksTableView.reloadData()
        } catch {
            print("Error fetchWalkData")
        }
    }
    
    func checkOnLaunch() {
        let alreadyLaunched = UserDefaults.standard.bool(forKey: "alreadyLaunched")
        
        if alreadyLaunched {
            fetchWalkData()
        } else {
            downloadWalks()
            UserDefaults.standard.set(true, forKey: "alreadyLaunched")
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
        PersistenceManager.delete(walksArray[indexPath.row])
        walksArray.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showDetailInfo", sender: nil)
        infoToBeSent = walksArray[indexPath.row]
        
        print("Select \(indexPath.row)")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let info = segue.destination as! DetailInfoViewController
        info.detailInfo = infoToBeSent
        
    }
    
    
}



