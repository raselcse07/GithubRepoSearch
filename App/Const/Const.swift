//
//  Const.swift
//  GithubRepoSearch
//
//  Created by Rasel on 2021/07/31.
//

import Foundation

struct Const {
    
    // MARK: - API Base url
    static let baseAPIUrl           = "https://api.github.com"
    
    // MARK: - API Request
    static let perPage              = 20
    static let initialPage          = 1
    static let sortBy               = "stars"
    static let order                = "desc"
    
    // MARK: - Others
    static let navigationTitle      = "Repository List"
    static let searchPlaceHolder    = "Type the name of repository ..."
}
