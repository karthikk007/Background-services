//
//  FileAccessibleProtocol.swift
//  BG services
//
//  Created by Karthik on 20/08/19.
//  Copyright © 2019 Karthik. All rights reserved.
//

import UIKit

protocol FileAccessible {
    var fileURL: URL { get set }
    var fileManager: FileManager { get }
    var documentsPath: URL { get }
    
    func localFilePath() -> URL
    func moveFileToDocumentsPath(sourcePath: URL, completion: () -> ())
    func fileExists() -> Bool
    func fileExists(at path: URL) -> Bool
}

extension FileAccessible {
    var fileManager: FileManager {
        return FileManager.default
    }
    
    /// Get local file path: download task stores tune here; AV player plays it.
    var documentsPath: URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    }
    
    func localFilePath() -> URL {
        return documentsPath.appendingPathComponent(fileURL.lastPathComponent)
    }
    
    func copyFileToDocumentsPath(sourcePath: URL, completion: () -> ()) {
        let destinationURL = localFilePath()
        try? fileManager.removeItem(at: destinationURL)
        
        do {
            try fileManager.copyItem(at: sourcePath, to: destinationURL)
            completion()
        } catch let error {
            print("Could not copy file to disk: \(error.localizedDescription)")
        }
    }
    
    func moveFileToDocumentsPath(sourcePath: URL, completion: () -> ()) {
        
        let destinationURL = localFilePath()
        try? fileManager.removeItem(at: destinationURL)
        
        do {
            try fileManager.copyItem(at: sourcePath, to: destinationURL)
            completion()
        } catch let error {
            print("Could not copy file to disk: \(error.localizedDescription)")
        }
    }
    
    func fileExists(at path: URL) -> Bool {
        return fileManager.fileExists(atPath: path.path)
    }
    
    func fileExists() -> Bool {
        let destinationURL = localFilePath()
        return fileManager.fileExists(atPath: destinationURL.path)
    }
    
    func attribures() -> [FileAttributeKey : Any]? {
        do {
            return try fileManager.attributesOfItem(atPath: localFilePath().path)
        } catch {
            print("attributes failed \(error)")
        }
        
        return nil
    }
    
    func printResourceValues() {
        do {
            let values = try localFilePath().resourceValues(forKeys: [.isHiddenKey, .isExcludedFromBackupKey])
            print("values = \(values.allValues)")
        } catch {
            print("error in resource values \(error)")
        }
    }
}
