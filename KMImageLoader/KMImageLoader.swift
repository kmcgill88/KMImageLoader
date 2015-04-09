//
//  KMImageLoader.swift
//  
//  Originally inspired by Nate Lyman - NateLyman.com
//
//  Created by Kevin McGill on 3/19/15.
//  Copyright (c) 2015 McGill DevTech, LLC. All rights reserved.
//

import UIKit
import Foundation
import CoreGraphics

class ImageLoader {
    
    let SECONDS_SINCE_DISK_CACHE_CLEAN = 60 //Set time in seconds until cache is cleared.
    let MAX_SIZE:CGFloat = 400 //Max width or height of downloaded Image.

    var cache = NSCache()
    var fileManager = NSFileManager.defaultManager()
    var imageDirectory = "/Documents/Images"
    let errorImage = UIImage(named: "error-image.png")
    
    class var sharedLoader : ImageLoader {
        struct Static {
            static let instance : ImageLoader = ImageLoader()
        }
        return Static.instance
    }
    
    init () {
        initFileManager()
    }
    
    func imageForUrl(urlString: String, completionHandler:(image: UIImage!, url: String) -> () ) {
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), {()in
            
            //Try to get from memory cache.
            var img: UIImage? = self.cache.objectForKey(urlString) as? UIImage
            if let goodImg = img {
                dispatch_async(dispatch_get_main_queue(), {() in
                    completionHandler(image: goodImg, url: urlString)
                })
                return
            }
            
            //Try to get from disk, if found, stick in memory cache
            var data = NSKeyedUnarchiver.unarchiveObjectWithFile(self.filePathForUrl(urlString)) as? NSData
            if let goodData = data {
                img = UIImage(data: goodData)
                if let goodImg = img {
                    self.cache.setObject(goodImg, forKey: urlString)
                    dispatch_async(dispatch_get_main_queue(), {() in
                        completionHandler(image: goodImg, url: urlString)
                    })
                    return
                }
            }
            
            //Go to the web and get the image.
            NSURLSession.sharedSession().dataTaskWithURL(NSURL(string: urlString)!, completionHandler: {(data: NSData!, response: NSURLResponse!, error: NSError!) -> Void in
                
                if (error != nil) {
                    completionHandler(image: self.errorImage, url: urlString)
                    return
                }
                
                if (data != nil) {
                    var image = UIImage(data: data)
                    if var goodImg = image {
                    
                        var tmpImg = self.makeRoundCornerImage(goodImg)
                        
                        if var finalImage = tmpImg {
                            self.cache.setObject(finalImage, forKey: urlString)

                            var tempData = UIImagePNGRepresentation(finalImage)
                            //var tempData = UIImageJPEGRepresentation(finalImage, 0.50)

                            if var finalData = tempData {
                                if !NSKeyedArchiver.archiveRootObject(finalData, toFile: self.filePathForUrl(urlString)) {
                                   println("FAILED to save good image.")
                                }
                                
                                dispatch_async(dispatch_get_main_queue(), {() in
                                    completionHandler(image: finalImage, url: urlString)
                                })
                                return
                            }
                        }
                        dispatch_async(dispatch_get_main_queue(), {() in
                            completionHandler(image: self.errorImage, url: urlString)
                        })
                        return
                    }
                    dispatch_async(dispatch_get_main_queue(), {() in
                        completionHandler(image: self.errorImage, url: urlString)
                    })
                    return
                }
                dispatch_async(dispatch_get_main_queue(), {() in
                    completionHandler(image: self.errorImage, url: urlString)
                })
                return
            }).resume()
        })
        
    }
    
    func makeRoundCornerImage(theImg:UIImage!) -> UIImage? {
        
        if var goodImg = theImg{
            
            var w = goodImg.size.width
            var h = goodImg.size.height
            var aspectRatio = goodImg.size.width / goodImg.size.height
            
            while (w > MAX_SIZE || h > MAX_SIZE) {
                h *= 0.99
                w *= 0.99
            }

            var rect:CGRect = CGRectMake(0, 0, w, (w/aspectRatio))
            
            var ovalWidth = CGFloat(w * 0.075)
            var ovalHeight = CGFloat(h * 0.075)
            
            let bitmapInfo = CGBitmapInfo(CGImageAlphaInfo.PremultipliedLast.rawValue)
            var colorSpace:CGColorSpaceRef  = CGColorSpaceCreateDeviceRGB()
            
            var context:CGContextRef = CGBitmapContextCreate(nil, Int(rect.size.width), Int(rect.size.height), 8, 4 * Int(rect.size.width), colorSpace, bitmapInfo)
            CGContextBeginPath(context)
            
            var fw, fh :CGFloat
            if (ovalWidth == 0 || ovalHeight == 0) {
                CGContextAddRect(context, rect)
            }
            CGContextSaveGState(context)
            CGContextTranslateCTM (context, CGRectGetMinX(rect), CGRectGetMinY(rect))
            CGContextScaleCTM (context, ovalWidth, ovalHeight)
            fw = CGRectGetWidth (rect) / ovalWidth
            fh = CGRectGetHeight (rect) / ovalHeight
            CGContextMoveToPoint(context, fw, fh/2)
            CGContextAddArcToPoint(context, fw, fh, fw/2, fh, 1)
            CGContextAddArcToPoint(context, 0, fh, 0, fh/2, 1)
            CGContextAddArcToPoint(context, 0, 0, fw/2, 0, 1)
            CGContextAddArcToPoint(context, fw, 0, fw, fh/2, 1)
            CGContextClosePath(context)
            CGContextRestoreGState(context)
            CGContextClosePath(context)
            CGContextClip(context)
            CGContextDrawImage(context, CGRectMake(0, 0, rect.size.width, rect.size.height), goodImg.CGImage)
            
            var imageMasked:CGImageRef = CGBitmapContextCreateImage(context)
            
            return UIImage(CGImage: imageMasked)
        }
        return theImg
    }

    func cleanDiskCache(){
         dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), {()in
            var error:NSError?
        
            var calendar = NSCalendar(identifier: NSCalendarIdentifierGregorian)!
            var filePaths = self.fileManager.contentsOfDirectoryAtPath(self.imageDirectory, error: nil)
            if var goodPaths = filePaths as? [NSString] {
                for path in goodPaths {
                    var fullPath = self.imageDirectory.stringByAppendingPathComponent(path as String)
                    var dic:NSDictionary? = self.fileManager.attributesOfItemAtPath(fullPath, error: nil)
                    if var goodDic = dic {
                        var creationDate: AnyObject? = goodDic[NSFileCreationDate]
                        if var savedDate = creationDate as? NSDate {
                            var components = calendar.components(NSCalendarUnit.CalendarUnitSecond, fromDate: savedDate, toDate: NSDate(), options: nil)
                            if  components.second >= self.SECONDS_SINCE_DISK_CACHE_CLEAN {
                                if !self.fileManager.removeItemAtPath(fullPath, error: &error) {
                                    println("Failed to delete \(fullPath). Because -->\(error)")
                                }
                            }
                        }
                    }
                }
            }
            
        })
    }
    
    func initFileManager(){
        var documentsPath: String = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)[0] as! String
        imageDirectory = documentsPath.stringByAppendingPathComponent("Images")
        
        //If the file doesn't exists, make one
        //
        if(!fileManager.fileExistsAtPath(imageDirectory)){
            println("Images Directory didn't exist. Created.")
            fileManager.createDirectoryAtPath(imageDirectory, withIntermediateDirectories: true, attributes: nil, error: nil)
        }
    }
    
    func filePathForUrl(url:String) -> String {
        return imageDirectory.stringByAppendingPathComponent("\(url.hash)")
    }
}