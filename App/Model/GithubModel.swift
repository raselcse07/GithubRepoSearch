//
//  GithubModel.swift
//  GithubRepoSearch
//
//  Created by Rasel on 2021/08/01.
//

import Foundation

// MARK: - GithubModel
struct GithubModel: JSONType {
    let totalCount: Int
    let items: [GithubItem]
}

// MARK: - Item
struct GithubItem: JSONType {
    let name: String?
    let fullName: String
    let stargazersCount: Int
}

