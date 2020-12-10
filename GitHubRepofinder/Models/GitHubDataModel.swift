//
//  GitHubDataModel.swift
//  GitHubRepofinder
//
//  Created by Tomasz Paluszkiewicz on 10/12/2020.
//

import Foundation
import UIKit

class GitHubDataModel {
    ///checking errors
    var incompleteResult: Bool?
    var totalCount: Int?
    ///data to upload from API
    var repoName: String?
    var repoOwnerName: String?
    var pictureOwner: String?
    var numberOfStars: String?
    
    var repoURL: String?
    var repoCommitsPath: String?
    var commitAuthor: String?
    var commitAuthorEmail: String?
    var commitMessage: String?
}
