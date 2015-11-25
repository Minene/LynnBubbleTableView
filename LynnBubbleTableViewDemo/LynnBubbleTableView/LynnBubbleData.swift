//
//  LynnBubbleData.swift
//  To my love Derrick and LynnA
//
//  Created by Lou Hwang on 2015. 10. 30..
//  Copyright © 2015 Lou Hwang. All rights reserved.
//

import Foundation
import UIKit

enum BubbleDataType: Int {
    case None = -1
    case Mine = 0
    case Someone
}

public struct LynnBubbleUser {
    private(set) public var profileImage: UIImage?
    private(set) public var userID:String?
    private(set) public var userNickName:String?
}

public class LynnBubbleData: NSObject {
 
    internal var type: BubbleDataType = .None
    private(set) public var user: LynnBubbleUser!
    private(set) public var date: NSDate!
    
    private(set) public var text: String?
    private(set) public var image: UIImage?
    private(set) public var imageURL: NSURL?
    private(set) public var imageLoaded: Bool = false
    
    
    convenience init(userID: String?, userNickname: String?, profile: UIImage?, text: String?, image: UIImage?, date: NSDate) {
        self.init()
        
        self.user   = LynnBubbleUser(profileImage: profile, userID: userID, userNickName: userNickname)
        self.date   = date
        
        self.text   = text
        self.image  = image
        imageLoaded = true
    }
    
    convenience init(imageUrl: String?, userID: String?, userNickname: String?, profile: UIImage?, placeHolderImage:UIImage = UIImage(named: "message_loading")!, failureImage:UIImage = UIImage(named: "message_loading_fail")!, date: NSDate) {

        self.init(userID: userID, userNickname: userNickname, profile: profile, text: nil, image: nil, date: date)
        
        func loadFail() {
            self.image = failureImage
            self.imageLoaded = true
        }
        
        guard let imageUrl = imageUrl else {
            loadFail()
            return
        }
        self.imageURL = NSURL(string: imageUrl)
        self.image = placeHolderImage
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0)) {
            
            guard let imageData = NSData(contentsOfURL: self.imageURL!) else {
                loadFail()
                return
            }
            self.image = UIImage(data: imageData)
            self.imageLoaded = true
        }
    }
    
    func getImageHeight (tableViewWidth width:CGFloat) -> CGFloat {
        
        return ((self.image!.size.height) * (width / 2)) / (self.image!
            .size.width)
        
//        if self.imageLoaded {
//            return ((self.image!.size.height) * (width / 2)) / (self.image!
//                .size.width)
//        }else {
//            let tempImg = UIImage(named: "message_loading")!
//            return ((tempImg.size.height) * (width / 2)) / (tempImg.size.width)
//        }
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

