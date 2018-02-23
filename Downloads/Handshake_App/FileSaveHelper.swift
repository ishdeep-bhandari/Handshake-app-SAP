//
//  FileSaveHelper.swift
//  Handshake
//
//  Created by Bhandari, Ishdeep on 3/23/16.
//  Copyright © 2016 Parse. All rights reserved.
//
/*
import Foundation
import UIKit

class FileSaveHelper {
 
    private enum FileErrors:ErrorType {
        case FileNotSaved
    }
  
    enum FileExension:String {
        case CSV = ".csv"
    }

    private let directory:NSSearchPathDirectory
    private let directoryPath: String
    private let fileManager = NSFileManager.defaultManager()
    private let fileName:String
    private let filePath:String
    private let fullyQualifiedPath:String
    private let subDirectory:String
    
    var fileExists:Bool {
        get {
            return fileManager.fileExistsAtPath(fullyQualifiedPath)
        }
    }
    
    var directoryExists:Bool {
        get {
            var isDir = ObjCBool(true)
            return fileManager.fileExistsAtPath(filePath, isDirectory: &isDir )
        }
    }
    
    init(fileName:String, fileExtension:FileExension, subDirectory:String, directory:NSSearchPathDirectory){
        self.fileName = fileName + fileExtension.rawValue
        self.subDirectory = "/\(subDirectory)"
        self.directory = directory
        self.directoryPath = NSSearchPathForDirectoriesInDomains(directory, .UserDomainMask, true)[0]
        self.filePath = directoryPath + self.subDirectory
        self.fullyQualifiedPath = "\(filePath)/\(self.fileName)"
        print(self.directoryPath)
        createDirectory()
    }
    private func createDirectory(){
    
        if !directoryExists {
            do {
                
                try fileManager.createDirectoryAtPath(filePath, withIntermediateDirectories: false, attributes: nil)
            }
            catch {
                print("An Error was generated creating the directory")
            }
        }
    }
    
    func saveFile( string fileContents:String) throws{
        if fileExists == false{
        do {
            try fileContents.writeToFile(fullyQualifiedPath, atomically: true, encoding: NSUTF8StringEncoding)
        }
        catch  {
            throw error
            }}
        else{
            let data = fileContents.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!
        if let fileHandle = NSFileHandle(forUpdatingAtPath: fullyQualifiedPath){
            fileHandle.seekToEndOfFile()
            fileHandle.writeData(data)
            fileHandle.closeFile()
        }
        else{
            print("Can't open fileHandle")
            }
        }
    }
}*/