import UIKit
import CoreData


class WalksViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var walksTableView: UITableView!
    
    // MARK: - Constants
    let wallksTableViewCell = WalksTableViewCell()
    let image = UIImage()
  
    
    
    // MARK: - Variables
    var walksArray   = [Walk]()
    var infoToBeSent: Walk?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkOnLaunch()
        
    }
    
    
    // MARK: - Actions
    @IBAction func refreshWalksButton(_ sender: Any) {

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
                
                self.saveWalkData(data: _parseWalks)
                
            } catch let error {
                print("ERROR!!!!!! - \(error)")
            }
            DispatchQueue.main.async {
                self.walksTableView.reloadData()
            }
            }.resume()
    }
    
    
    func saveWalkData(data: [WalksInfo]) {        
        for one in data {
            let walk = Walk(context: PersistenceManager.context)
            walk.walkTitle = one.walkTitle
            walk.walkType = one.walkType
            walk.walkIcon = one.walkIcon
            walk.walkRating = one.walkRating
            walk.walkCountry = one.walkCountry
            walk.walkDistrict = one.walkDistrict
            walk.walkLength = one.walkLength
            walk.walkGrade = one.walkGrade
            walk.walkStartCoordLat = one.walkStartCoordLat
            walk.walkStartCoordLong = one.walkStartCoordLong
            walk.walkIllustration = one.walkIllustration
            walk.walkDescription = one.walkDescription
            walk.walkID = one.walkID
            
        
            if walksArray.isEmpty {
                walksArray.append(walk)
                image.saveImage(walk.walkIcon)
                image.saveImage(walk.walkIllustration)
            } else {
                for one in walksArray {
                    if one.walkID == walk.walkID {
                        break
                    } else if (one == walksArray[walksArray.endIndex - 1]) {
                        walksArray.append(walk)
                        image.saveImage(walk.walkIcon)
                        image.saveImage(walk.walkIllustration)
                    }
                }
            }
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
        cell.ratingImage.image = image.changeRatingImage(walk.walkRating)
        cell.areaImage.image = image.getImageFromStorage(walk.walkIcon)
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        guard editingStyle == .delete else { return }
        image.deleteImageFromStorage(walksArray[indexPath.row].walkIcon!)
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

