//
//  PathsManager.swift
//  me@ayossef.net
//
//  Created by Ahmed on 7/21/16.
//  Copyright © 2016 PiTechnologies. All rights reserved.
//

import UIKit

class PathsManager: NSObject {

    
    func pathForInternalFile(fileName:String) -> String?{
        let path = self.filePathForName(fileName)
        if (!self.internalFileExists(fileName))
        {
            return nil
        }
       return path
    }
    
    private func filePathForName(fileName:String)->String{
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        let path = paths.stringByAppendingString("/\(fileName).plist")
        return path
    }
    
    func internalFileExists(fileName:String)->Bool{
        let path = self.filePathForName(fileName)
        let fileManager = NSFileManager.defaultManager()
        return fileManager.fileExistsAtPath(path)
    }
    
    func initArrayFile(fileName:String) -> String{
        let path = self.filePathForName(fileName)
        let fileManager = NSFileManager.defaultManager()
        fileManager.createFileAtPath(path, contents: nil, attributes: nil)
        NSArray().writeToFile(path, atomically: true)
        return path
    }
    
    func initDictionaryFile(fileName:String) -> String{
        let path = self.filePathForName(fileName)
        let fileManager = NSFileManager.defaultManager()
        fileManager.createFileAtPath(path, contents: nil, attributes: nil)
        NSDictionary().writeToFile(path, atomically: true)
        return path
    }
    
    
    func pathForBundleFile(fileName:String)->String{
        return NSBundle.mainBundle().pathForResource(fileName, ofType: "plist")!
    }
}
