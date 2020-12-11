//
//  MainViewController.swift
//  GitHubRepofinder
//
//  Created by Tomasz Paluszkiewicz on 10/12/2020.
//

import UIKit
import Alamofire
import SwiftyJSON
import SDWebImage

var githubDataArray: [GitHubDataModel] = [GitHubDataModel]()
    var cellIndex = 0

class MainViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var labelRepositories: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    
    
    let GITHUB_URL = "https://api.github.com/search/repositories"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ///search bar config
        searchBar.backgroundImage = UIImage()
        searchBar.delegate = self
        
        viewConfiguration()
        tableViewConfiguration()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        viewConfiguration()
        
    }
    
    //MARK: - Networking
    
    func getData(url: String, parameters: [String : String]){
        
        AF.request(url, method: .get, parameters: parameters).responseJSON {
            response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                
                self.updateData(json: json)
                ARSLineProgress.hide()
                
                //print("JSON from server response: \(json)")
                //print(response.request ?? "response reqest issue")
                
                break
            case .failure(let error):
                print("Connection Issues")
                print(error)
                self.labelRepositories.text = "Connection Issue"
            }
        }
        
    }
    
    //MARK: - JSON Parsing
    
    func updateData(json: JSON){
        
        githubDataArray.removeAll()
        
        if json["incomplete_results"].bool == false {
            
            
            let resultArray = json["items"]
            
            for index in resultArray.arrayValue{
                
                let item = GitHubDataModel()
                
                item.repoName = index["name"].stringValue
                item.repoOwnerName = index["owner"]["login"].stringValue
                item.pictureOwner = index["owner"]["avatar_url"].stringValue
                item.numberOfStars = index["stargazers_count"].stringValue
                item.repoURL = index["html_url"].stringValue
                item.repoCommitsPath = "https://api.github.com/repos/\(index["owner"]["login"].stringValue)/\(index["name"].stringValue)/commits"
                
                //print(item.repoCommitsPath)
                githubDataArray.append(item)
                
            }
            
            
            if json["total_count"].int == 0 {
                labelRepositories.text = "0 results"
            } else {
                labelRepositories.text = "Repositories result:"
            }
            
            
            updateUIWithData()
            for x in 0..<githubDataArray.count {
                print(x, "=", githubDataArray[x].repoName!) }
            
        }
        else if json["incomplete_results"].bool == true {
            print(json)
            
            labelRepositories.text = "Incomplete result"
        }
        else {
            labelRepositories.text = "unknow problem, ask developer :("
            print(json)
        }
    }
    
    //MARK: - UI Updates
    
    func updateUIWithData(){
        
            self.tableView.reloadData()

    }
    
    //MARK: - searchQuery
    func userEnteredQuery(query: String) {
        
        let params : [String : String] = ["q" : query]
        getData(url: GITHUB_URL, parameters: params)
        
    }
    
    //MARK: - View Configuration
    
    func viewConfiguration() {
        
        self.view.backgroundColor = UIColor.white
        ///set navbar
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.black]
        navigationController?.navigationBar.largeTitleTextAttributes = textAttributes
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        self.navigationController?.navigationBar.barTintColor = UIColor.white
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        /// set status bar
        navigationController?.navigationBar.barStyle = .default
        setNeedsStatusBarAppearanceUpdate()
        ///set serach bar
       
        if #available(iOS 13.0, *) {
            searchBar.searchTextField.leftView?.tintColor = .gray
        }
       
        if let textfield = searchBar.value(forKey: "searchField") as? UITextField {
            textfield.textColor = UIColor.black
            textfield.backgroundColor = #colorLiteral(red: 0.9607843137, green: 0.9607843137, blue: 0.9607843137, alpha: 1)
            textfield.attributedPlaceholder = NSAttributedString(string: textfield.placeholder ?? "", attributes: [NSAttributedString.Key.foregroundColor : UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 0.1)])
            
        }
        /// set label
        labelRepositories.font = UIFont(name: Constants.Fonts.fontSFDisplayBold, size: 22)
        labelRepositories.addTextSpacing(spacing: 0.35)
        labelRepositories.textColor = UIColor.black
        ///set table view
        self.tableView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    }
    
    /// status bar color change
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if #available(iOS 13.0, *) {
            return .darkContent
        } else {
            return .default
        }
        
    }
    
    //MARK: - TableView Configuration
    
    func tableViewConfiguration() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: Constants.Cells.cellIndentifierMain, bundle: nil), forCellReuseIdentifier: Constants.Cells.cellNibNameMain)
        self.tableView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//
//
//        if segue.identifier == Constants.segueCell {
//            let destinationVC = segue.destination as! DetailsViewController
//
//            if let indexPath = tableView.indexPathForSelectedRow {
//
//                /// send row number to DetailsViewController and use by JSON quert
//                destinationVC.selectedCell = indexPath.row
//                destinationVC.githubDataArrayFromSegue = githubDataArray
//            }
//        }
//    }
    
    
}


//MARK: - extension ViewController

// tableView
extension MainViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        cellIndex = indexPath.row
        performSegue(withIdentifier: Constants.segueCell, sender: self)
        print(indexPath.row)
    }
}

extension MainViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableView.keyboardDismissMode = .onDrag
        return githubDataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Cells.cellNibNameMain, for: indexPath) as! MainCell
        
        cell.labelTitle.text = githubDataArray[indexPath.row].repoName
        cell.labelStars.text = githubDataArray[indexPath.row].numberOfStars
        
        if let icon = githubDataArray[indexPath.row].pictureOwner {
            
            let url = URL(string: icon)
            cell.imageAvatar.sd_setImage(with: url) { (downloadedImage, downloadedExeption, cacheType, downloadURL) in
            }
        }
    
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    }
    
}



// search bar
extension MainViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        if searchBar.text == "" {
            
            let alert = UIAlertController(title: "EMPTY TEXTFILED", message: "Type something inside search bar", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            present(alert, animated: true, completion: nil)
        }
        else{
            ARSLineProgress.show()
            let query = searchBar.text!
            userEnteredQuery(query: query)
            
        }
    }
}
