//
//  HTTPResponse.swift
//  GithubRepoSearch
//
//  Created by Rasel on 2021/07/31.
//

import Foundation

open class HTTPResponse<BodyType> {
    
    public var statusCode: Int
    public var headers: HTTPHeaders = [:]
    public var body: BodyType
    
    init(statusCode: Int, headers: HTTPHeaders, body: BodyType) {
        self.statusCode = statusCode
        self.headers = headers
        self.body = body
    }
}
