//
//  HTTPTask.swift
//  GithubRepoSearch
//
//  Created by Rasel on 2021/07/31.
//

import Foundation

open class HTTPTask<BodyType> {
    
    var request: URLRequest
    var session: URLSession
    var commonResponseHandler: CallBackWithValue<HTTPResponse<BodyType>, HTTPResponse<BodyType>?>?
    
    private var task: URLSessionTask?
    private var _onError: CallBackWithValue<APIError, Void>?
    private var _onSuccess: CallBackWithValue<HTTPResponse<BodyType>, Void>?
    
    init(request: URLRequest, session: URLSession) {
        self.request = request
        self.session = session
    }
    
    func execute() -> Self {
        
        task = session.dataTask(with: request) { data, response, error in
            
            if error != nil {
                self._onError?(APIError.convert(from: error!))
                self.cancel()
                return
            }
            
            guard let urlResponse = response as? HTTPURLResponse else {
                self._onError?(APIError.E1000)
                self.cancel()
                return
            }
            
            if urlResponse.statusCode == 403 {
                self._onError?(APIError.E1003)
                self.cancel()
                return
            } else {
                guard
                    let headers = urlResponse.allHeaderFields as? HTTPHeaders,
                    let data = data,
                    let body = self.pareseBody(data),
                    let result = self.commonResponseHandler?(HTTPResponse(statusCode: urlResponse.statusCode, headers: headers, body: body))
                else {
                    self._onError?(APIError.E1000)
                    self.cancel()
                    return
                }
                self._onSuccess?(result)
            }
        }
        
        task?.resume()
        return self
    }
    
    func pareseBody(_ data: Data) -> BodyType? {
        return data as? BodyType
    }
    
    public func onSuccess(_ next: @escaping CallBackWithValue<HTTPResponse<BodyType>, Void>) -> Self {
        _onSuccess = next
        return self
    }
    
    func onError(_ next: @escaping CallBackWithValue<APIError, Void>) -> Self {
        _onError = next
        return self
    }
    
    func cancel() {
        task?.cancel()
    }
    
}
