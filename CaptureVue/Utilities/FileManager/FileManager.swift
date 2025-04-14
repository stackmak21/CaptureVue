//
//  FileManager.swift
//  CaptureVue
//
//  Created by Paris Makris on 23/2/25.
//

import Foundation
import SwiftUI

actor LocalFileManager {
    
    static let instance = LocalFileManager()
    private init() { }
    
    func saveFile(file: Data, fileName: String, folderName: String) -> URL? {
        
        // create folder
        createFolderIfNeeded(folderName: folderName)
        
        // get path for image
        guard
            let url = getUrlForFile(fileName: fileName, folderName: folderName)
            else { return nil }
        
        // save image to path
        do {
            try file.write(to: url)
            return url
        } catch let error {
            log.error("Error saving file. File Name: \(fileName).  \(error)")
            return nil
        }
    }
    
    func getFileUrl(fileName: String, folderName: String) -> URL? {
        guard
            let url = getUrlForFile(fileName: fileName, folderName: folderName),
            FileManager.default.fileExists(atPath: url.path) else {
            return nil
        }
        return url
    }
    
    func getFile(fileName: String, folderName: String) -> Data? {
        guard
            let url = getUrlForFile(fileName: fileName, folderName: folderName),
            FileManager.default.fileExists(atPath: url.path) else {
            return nil
        }
        return FileManager.default.contents(atPath: url.path)
    }
    
    func getAllFiles(folderName: String) -> [String] {
        guard
            let url = getUrlForFolder(folderName: folderName),
            FileManager.default.fileExists(atPath: url.path)
        else { return [] }
        
        do{
            let result = try FileManager.default.contentsOfDirectory(atPath: url.path)
//            return result.map({url.appendingPathComponent($0).absoluteString})
            return result
        }catch{
            return []
        }
    }
    
    func deleteFile(fileName: String, folderName: String) -> Bool {
        do{
            guard let url = getUrlForFile(fileName: fileName, folderName: folderName) else { return false }
            try FileManager.default.removeItem(atPath: url.path)
            return true
        }
        catch{
            return false
        }
    }
    
    func getURLforVideo(fileName: String, folderName: String) -> URL? {
        return getUrlForFile(fileName: fileName, folderName: folderName)
    }
    
    private func createFolderIfNeeded(folderName: String) {
        guard let url = getUrlForFolder(folderName: folderName) else { return }
        
        if !FileManager.default.fileExists(atPath: url.path) {
            do {
                try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
            } catch let error {
                print("Error creating directory. FolderName: \(folderName). \(error)")
            }
        }
    }
    
    private func getUrlForFolder(folderName: String) -> URL? {
        let url = FileManager.default.temporaryDirectory
        return url.appendingPathComponent(folderName)
    }
    
    private func getUrlForFile(fileName: String, folderName: String) -> URL? {
        guard let folderURL = getUrlForFolder(folderName: folderName) else {
            return nil
        }
        return !fileName.isEmpty ? folderURL.appendingPathComponent(fileName) : folderURL
    }
    
    
}
