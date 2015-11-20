//
//  ImageBubbleSomeoneViewCell.swift
//  LynnBubbleTableViewDemo
//
//  Created by Colondee :D on 2015. 11. 4..
//  Copyright © 2015년 lou. All rights reserved.
//

import UIKit

class ImageBubbleSomeoneViewCell: Someone_sBubbleViewCell {

    @IBOutlet weak var imgData: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .None
//        self.imgData.layer.borderWidth = 1.0
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func setBubbleData(data: LynnBubbleData) {
        if data.image!.isKindOfClass(UIImage) {
            self.imgData.image = data.image as? UIImage
        }else {
            func checkImageUpdated () {
                if data.imageLoaded {
                    self.imgData.image = data.image as? UIImage
                    NSNotificationCenter.defaultCenter().postNotificationName("_CellDidLoadImageNotification", object: self)
                    return
                }else{
                    self.imgData.image = UIImage(named: "message_loading")
                    _delay(0.5, closure: { () -> Void in
                        checkImageUpdated()
                    })
                }
            }
            
            checkImageUpdated()
            
            //            self.imgData.setImageWithUrl(data.image as! NSURL, placeHolderImage: UIImage(named: "message_loading"))
        }
        self.lbNick.text = data.userNickName
        self.imgProfile.image = data.profileImage
        self.lbTime.text = getTimeString(data.date!)
        
    }
    
}
