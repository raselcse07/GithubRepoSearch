//
//  HTTPRequest.swift
//  GithubRepoSearch
//
//  Created by Rasel on 2021/07/31.
//

import Foundation

open class HTTPRequest<BodyType> {
    
    open var baseURL: URL { fatalError("Overwrite required") }
    open var query: [URLQueryItem]? { fatalError("Overwrite required") }
    open var headers: HTTPHeaders { fatalError("Overwrite required") }
    open var parameters: HTTPParameters { fatalError("Overwrite required") }
    open var method: HTTPMethod { fatalError("Overwrite required") }
    
    open var isJSONRequest: Bool {
        return headers["Content-Type"]?.lowercased().contains("application/json") ?? false
    }
    
    open var url : URL? {
        var urlComponents = URLComponents()
        urlComponents.scheme = baseURL.scheme
        urlComponents.host = baseURL.host
        urlComponents.path = baseURL.path
        if let query = query {
            urlComponents.queryItems = query
        }
        return urlComponents.url
    }
    
    public init() {}
}
