//
//  BaseAPIRequest.swift
//  GithubRepoSearch
//
//  Created by Rasel on 2021/07/31.
//

import Foundation

class BaseAPIRequest<BodyType: JSONType>: HTTPRequest<BodyType> {
    
    var path: String {
        return .empty
    }
    
    override var baseURL: URL {
        var url = URL(string: Const.baseAPIUrl)!
        url.appendPathComponent(path)
        return url
    }
    
    override var query: [URLQueryItem]? {
        return nil
    }
    
    override var parameters: HTTPParameters {
        return [:]
    }
    
    override var headers: HTTPHeaders {
        return [:]
    }
}
