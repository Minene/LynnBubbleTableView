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
    var type: BubbleDataType
    var imageLoaded = false
    
    override init() {
        self.type = .Mine
    }
    
    convenience init(userID:String?, profile:UIImage?, text: String?, image: AnyObject?, date: NSDate? , type:BubbleDataType = .Mine) {
        // Default type is Mine
        
        self.init()
        
        self.profileImage = profile
        self.text = text
        self.date = date
        self.userID = userID
        self.type = type
        
        if let data:AnyObject = image  {
            if data.isKindOfClass(UIImage) {
                self.image = data as! UIImage
                self.imageLoaded = true
            }else if data.isKindOfClass(NSString) {
                
                self.image = data
                
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0)) {
                    self.image = UIImage(data: NSData(contentsOfURL: NSURL(string: data as! String)!)!)!
                    self.imageLoaded = true
                }
            }
        }

        
    }
    
    func getImageHeight (tableViewWidth width:CGFloat) -> CGFloat {
        
        if self.imageLoaded {
            return ((self.image?.size.height)! * (width / 2)) / (self.image?.size.width)!
        }else{
            return UIImage(named: "message_loading")!.size.height
        }
        
    }
}

