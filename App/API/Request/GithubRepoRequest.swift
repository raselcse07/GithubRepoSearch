//
//  GithubRepoRequest.swift
//  GithubRepoSearch
//
//  Created by Rasel on 2021/07/31.
//

import Foundation

final class GithubRepoRequest: BaseAPIRequest<GithubModel> {
    
    override var path: String {
        return "/search/repositories"
    }
    
    override var method: HTTPMethod {
        return .get
    }
    
    override var query: [URLQueryItem]? {
        return URLQueryItem.generateQuery(items: [
            "q"         : searchString,
            "per_page"  : (perPage ?? Const.perPage).toString(),
            "page"      : (page ?? Const.initialPage).toString(),
            "sort"      : Const.sortBy,
            "order"     : Const.order
        ])
    }
    
    override var headers: HTTPHeaders {
        return [
            "accept": "application/vnd.github.v3+json"
        ]
    }
    
    let searchString: String
    let perPage: Int?
    let page: Int?
    
    init(searchString: String, perPage: Int? = nil, page: Int? = nil) {
        self.searchString = searchString
        self.perPage = perPage
        self.page = page
    }
    
}
