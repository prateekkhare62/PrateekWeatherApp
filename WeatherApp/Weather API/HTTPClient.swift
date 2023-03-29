//
//  HTTPClient.swift
//  EssentialFeed
//
//  Created by Prateek on 07/02/21.
//

import Foundation

public protocol HTTPClientTask {
    func cancel()
}

public protocol HTTPClient {
    
    typealias Result = Swift.Result<(Data,HTTPURLResponse), Error>
    
    /// The completion handler can be invoke in any thread.
    /// Client are responsible to dispatch to appropriate threads, If needed.
    @discardableResult
    func get(from url: URL, completion:@escaping (Result) -> Void) -> HTTPClientTask
    
}
