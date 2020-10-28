//
//  LogQueue.swift
//  SGLog
//
//  Created by Barry Kostjens on 19/07/2019.
//  Copyright © 2019 Prosilic. All rights reserved.
//

import Foundation

class LogQueue {
    private var queue : [GELF] = []
    private var logfile : URL
    
    init() {
        let documentPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        self.logfile = documentPath.appendingPathComponent("sglog.json")
        self.queue = readFromFile() ?? []
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(appMovedToBackground), name: UIApplication.willResignActiveNotification, object: nil)
    }
    
    public func addToQueue(_ gelf: GELF) {
        self.queue.append(gelf)
    }
    
    public func getQueuedItem() -> GELF? {
        
        if let gelf = self.queue.first {
            self.queue.removeFirst()
            return gelf
        }
        
        return nil
    }
    
    private func writeToFile() {
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(self.queue)
            print("\(#file) \(#function) queue: \(String(describing: self.queue))")
            print("\(#file) \(#function) data: \(data)")
            if FileManager.default.fileExists(atPath: logfile.path) {
                try FileManager.default.removeItem(at: logfile)
            }
            FileManager.default.createFile(atPath: logfile.path, contents: data, attributes: nil)
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    private func readFromFile() -> [GELF]? {
        if let data = FileManager.default.contents(atPath: logfile.path) {
            let decoder = JSONDecoder()
            do {
                let model = try decoder.decode([GELF].self, from: data)
                print("\(#file) \(#function) model: \(model)")
                return model
            } catch {
                fatalError("\(error)")
            }
        } else {
            print("\(#file) \(#function) No data at \(logfile.path)!")
        }
        return nil
    }
    
    @objc private func appMovedToBackground() {
        // Let's write the queue to disk
        self.writeToFile()
    }
}
