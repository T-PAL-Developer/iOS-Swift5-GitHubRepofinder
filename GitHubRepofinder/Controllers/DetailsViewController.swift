//
//  DetailsViewController.swift
//  GitHubRepofinder
//
//  Created by Tomasz Paluszkiewicz on 10/12/2020.
//

import UIKit

class DetailsViewController: UIViewController {
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewConfiguration()
    
    }
    
   

 
    
    
    
    
    
    
    
    
    //MARK: - View Configuration
    
    func viewConfiguration() {
        
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
        
    }
    
    /// status bar color change
    override var preferredStatusBarStyle: UIStatusBarStyle {
           return .lightContent
       }
    
    
    
    
    
    
}

