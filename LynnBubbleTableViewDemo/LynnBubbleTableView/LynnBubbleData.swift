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
    var image: UIImage?
    var date: NSDate?
    var userID:String?
    var type: BubbleDataType
    
    override init() {
        self.type = .Mine
    }
    
    init(userID:String?, profile:UIImage?, text: String?, image: UIImage?, date: NSDate? , type:BubbleDataType = .Mine) {
        // Default type is Mine
        self.profileImage = profile
        self.text = text
        self.image = image
        self.date = date
        self.userID = userID
        self.type = type
    }
    
}

