//
//  Server.swift
//  SGLog
//
//  Created by Barry Kostjens on 17/07/2019.
//  Copyright © 2019 Prosilic. All rights reserved.
//

import Foundation

class Server : NSObject {
    
    var url: String
    let logQueue = LogQueue()
    
    init(url:String) {
        self.url = url
    }
    
    internal func post(_ gelf:GELF) {
       
        guard let url = URL(string:self.url) else {
            print("\(#file) \(#function) couldn't cast URL of \(self.url)")
            return
        }
        
        guard let jsonData = gelf.jsonData() else {
            print("\(#file) \(#function) Unable to encode gelf to json")
            return
        }
        
        let session = URLSession(configuration: .default, delegate: self, delegateQueue: nil)
        var request = URLRequest(url: url)
        
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = session.uploadTask(with: request, from: jsonData) { data, response, error in
            if let error = error {
                // Posting to server failed. Add gelf to the queue
                self.logQueue.addToQueue(gelf)
                print("\(#file) \(#function) Error: \(error)")
                return
            }
            
            // Posting to server succeeded, let's process any remaining items in the queue
            self.processQueue()
        }
        task.resume()
    }
    
    private func processQueue() {
        guard let gelf = self.logQueue.getQueuedItem() else { return }
        self.post(gelf)
    }
}

extension Server : URLSessionDelegate {
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        guard let serverTrust = challenge.protectionSpace.serverTrust else {
            return
        }
        completionHandler(.useCredential, URLCredential(trust: serverTrust))
    }
}
