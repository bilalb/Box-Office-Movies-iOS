//
//  MockedURLSessionDataTask.swift
//  Box-Office-Movies-Core
//
//  Created by Bilal Benlarbi on 23.07.2019.
//  Copyrights © 2019 Bilal Benlarbi. All rights reserved.
//

import Foundation

class MockedURLSessionDataTask: URLSessionDataTask {
    
    let completionHandler: NetworkCompletionHandler?
    let data: Data?
    let urlResponse: URLResponse?
    let customError: Error?
    
    init(completionHandler: NetworkCompletionHandler?, data: Data?, urlResponse: URLResponse?, error: Error?) {
        self.completionHandler = completionHandler
        self.data = data
        self.urlResponse = urlResponse
        self.customError = error
    }
    
    override func resume() {
        completionHandler?(data, urlResponse, customError)
    }
}
