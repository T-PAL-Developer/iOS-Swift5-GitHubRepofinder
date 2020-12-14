//
//  DetailsViewController.swift
//  GitHubRepofinder
//
//  Created by Tomasz Paluszkiewicz on 10/12/2020.
//

import UIKit
import Alamofire
import SwiftyJSON

class DetailsViewController: UIViewController {
    
    @IBOutlet weak var labelAuthorName: UILabel!
    @IBOutlet weak var labelStarsNumber: UILabel!
    @IBOutlet weak var labelRepoTitle: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var imageRepo: UIImageView!
    @IBOutlet weak var buttonViewOnline: UIButton!
    @IBOutlet weak var buttonShareRepo: UIButton!
    
    var dataArray: [GitHubDataModel] = [GitHubDataModel]()
    var commitsArray: [GitHubDataModel] = [GitHubDataModel]()
    var commitsCount = 0
    var cellIndex: Int = 0
    var cellIndexFromMainVC: Int?
    var dataArrayFromMainVC: [GitHubDataModel]? {
        didSet {
            dataArray = dataArrayFromMainVC!
            cellIndex = cellIndexFromMainVC!
            getData()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewConfiguration()
        tableViewConfiguration()
    }
    
    
    @IBAction func buttonViewOnlinePressed(_ sender: Any) {
        
        if let url = URL(string: dataArray[cellIndex].repoURL!) {
            UIApplication.shared.open(url)
        }
    }
    
    @IBAction func buttonSharePressed(_ sender: Any) {
        
        let items = [URL(string: dataArray[cellIndex].repoURL!)!]
        let ac = UIActivityViewController(activityItems: items, applicationActivities: nil)
        present(ac, animated: true)
        
    }
    
    
    //MARK: - Networking
    
    
    func getData(){
        
        if let url = dataArray[cellIndex].repoCommitsPath {
            
            AF.request(url).responseJSON{
                response in
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
        
                    self.updateData(json: json)
                    
                    //print("JSON from server response: \(json)")
                    //print(response.request ?? "response reqest issue")
                    
                    break
                case .failure(let error):
                    print("Connection Issues")
                    print(error)
                    self.labelRepoTitle.text = "Check Internet"
                }
            }
        }
        
    }
    
    //MARK: - JSON Parsing
    
    func updateData(json: JSON){
        
        commitsArray.removeAll()
        
        
        commitsCount = json.count
        if commitsCount > 3 {
            commitsCount = 3
        }
        
        for i in 0..<commitsCount {
            let item = GitHubDataModel()
            item.commitAuthor = json[i]["commit"]["author"]["name"].stringValue
            item.commitAuthorEmail = json[i]["commit"]["author"]["email"].stringValue
            item.commitMessage = json[i]["commit"]["message"].stringValue
            
            commitsArray.append(item)
        }
        
        self.tableView.reloadData()
        
    }
    
    
    //MARK: - View Configuration
    
    func viewConfiguration() {
        
        ///set view properties
        self.view.backgroundColor = UIColor.white
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.black]
        navigationController?.navigationBar.largeTitleTextAttributes = textAttributes
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        self.navigationController?.navigationBar.barTintColor = UIColor.white
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        let backButton = UIBarButtonItem()
        backButton.title = "Back"
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
        self.navigationController!.navigationBar.barStyle = .black
        buttonShareRepo.layer.cornerRadius = buttonShareRepo.frame.size.height / 5
        buttonViewOnline.layer.cornerRadius = buttonViewOnline.frame.size.height / 5
        
        ///set labels & image from dataArray
        labelAuthorName.text = dataArray[cellIndex].repoOwnerName
        labelStarsNumber.text = "Numbers of Stars (\(dataArray[cellIndex].numberOfStars!))"
        labelRepoTitle.text = dataArray[cellIndex].repoName

        if let icon = dataArray[cellIndex].pictureOwner {
            
            let url = URL(string: icon)
            imageRepo.sd_setImage(with: url) { (downloadedImage, downloadedExeption, cacheType, downloadURL) in
            }
        }
        
    }
    
    /// status bar color change
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    //MARK: - TableView Configuration
    
    func tableViewConfiguration() {
        tableView.dataSource = self
        tableView.register(UINib(nibName: Constants.Cells.cellIndentifierDetails, bundle: nil), forCellReuseIdentifier: Constants.Cells.cellNibNameDetails)
        self.tableView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    }
   
    
}

//MARK: - extension ViewController

// tableView

extension DetailsViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableView.keyboardDismissMode = .onDrag
        return commitsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Cells.cellNibNameDetails, for: indexPath) as! DetailsCell
        
        cell.labelCommitAuthor.text = commitsArray[indexPath.row].commitAuthor
        cell.labelCommitMessage.text = commitsArray[indexPath.row].commitMessage
        cell.labelEmailAuthor.text = commitsArray[indexPath.row].commitAuthorEmail
        cell.labelNumber.text = "\(indexPath.row + 1)"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    }
    
}
