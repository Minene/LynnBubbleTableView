//
//  ImageBubbleTableViewCell.swift
//  LynnBubbleTableViewDemo
//
//  Created by Colondee :D on 2015. 11. 4..
//  Copyright © 2015년 lou. All rights reserved.
//

import UIKit

class ImageBubbleTableViewCell: MyBubbleViewCell {

    @IBOutlet weak var imgData: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .None
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func setBubbleData(data: LynnBubbleData) {
        
        self.lbTime.text = getTimeString(data.date!)
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
        }
    }
}
