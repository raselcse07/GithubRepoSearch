//
//  URLQueryItem+Ext.swift
//  GithubRepoSearch
//
//  Created by Rasel on 2021/08/03.
//

import Foundation

extension URLQueryItem {
    
    public static func generateQuery(items: [String: String]) -> [Self] {
        return items.map {
            URLQueryItem(name: $0, value: $1)
        }
    }
}
