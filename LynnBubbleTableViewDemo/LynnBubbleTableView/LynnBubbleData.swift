//
//  LynnBubbleData.swift
//  To my love Derrick and LynnA
//
//  Created by Lou Hwang on 2015. 10. 30..
//  Copyright © 2015 Lou Hwang. All rights reserved.
//

import Foundation
import UIKit

enum BubbleDataType: Int{
    case Mine = 0
    case Someone
}

public class LynnBubbleData: NSObject {
    
    var text: String?
    var profileImage: UIImage?
    var image: AnyObject?
    var date: NSDate?
    var userID:String?
    var userNickName:String?
    var type: BubbleDataType
    var imageLoaded = false
    
    override init() {
        self.type = .Mine
    }
    
    convenience init(userID:String?, userNickname:String?, profile:UIImage?, text: String?, image: AnyObject?, date: NSDate? , type:BubbleDataType = .Mine) {
        // Default type is Mine
        
        self.init()
        
        self.profileImage = profile
        self.text = text
        self.date = date
        self.userID = userID
        self.userNickName = userNickname
        self.type = type
        
        if let data:AnyObject = image  {
            if data.isKindOfClass(UIImage) {
                self.image = data as! UIImage
                self.imageLoaded = true
            }else if data.isKindOfClass(NSString) {
                
                self.image = data
                
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0)) {
                    let imageData:NSData? = NSData(contentsOfURL: NSURL(string: data as! String)!)
                    if imageData == nil{
                        self.image = UIImage(named: "message_loading")
                    }else{
                        self.image = UIImage(data: imageData!)
                    }
                    self.imageLoaded = true
                }
            }
        }

        
    }
    
    func getImageHeight (tableViewWidth width:CGFloat) -> CGFloat {
        
        if self.imageLoaded {
            return ((self.image!.size.height) * (width / 2)) / (self.image!
                .size.width)
        }else {
            let tempImg = UIImage(named: "message_loading")!
            return ((tempImg.size.height) * (width / 2)) / (tempImg.size.width)
        }
//        func getHeight (img:UIImage = self.image as! UIImage) -> CGFloat {
//            return ((img.size.height) * (width / 2)) / (img.size.width)
//        }
//        
//        if self.imageLoaded {
//            return getHeight()
//        }else{
//            return getHeight()
//        }
        
    }
}

