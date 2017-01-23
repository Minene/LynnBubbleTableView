//
//  LynnBubbleData.swift
//  To my love Derrick and LynnA
//
//  Created by Lou Hwang on 2015. 10. 30..
//  Copyright © 2015 Lou Hwang. All rights reserved.
//
import UIKit

extension UIImageView {
    
    private struct imageCacheAssociatedKeys {
        static var cached = "cachedImage"
    }
    
    //this lets us check to see if the item is supposed to be displayed or not
    var imageCache:[String: UIImage] {
        get {
            guard let caching = objc_getAssociatedObject(self, &imageCacheAssociatedKeys.cached) as? [String: UIImage] else {
                return [String: UIImage]()
            }
            return caching
        }
        
        
        set(value) {
            objc_setAssociatedObject(self,&imageCacheAssociatedKeys.cached,value,objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    
    
    public func setImageWithUrlRequest(requestUrl:String, placeHolderImage:UIImage? = nil,
                                       success:((_ image:UIImage) -> Void)?,
                                       failure:(() -> Void)?)
    {
        //    let url = URL(string: request)
        self.image = placeHolderImage
        if let cachedImage = self.imageCache[requestUrl] {
            DispatchQueue.main.async {
                success?(cachedImage)
            }
            
        }else{
            DispatchQueue.global().async {
                //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
                
                do {
                    let request = URL(string: requestUrl)
                    let data = try Data(contentsOf: request!)
                    if let downloadedImage = UIImage(data: data) {
                        self.imageCache = [requestUrl : downloadedImage]
                        DispatchQueue.main.async {
                            success?(downloadedImage)
                        }
                    }else{
                        DispatchQueue.main.async {
                            failure?()
                        }
                    }
                } catch {
                    DispatchQueue.main.async {
                        failure?()
                    }
                    
                }
            }
        }
        
    }
}


extension Date {
    
    func _stringFromDateFormat(_ format: String) -> String {
        let formatter = DateFormatter()
        let language = Bundle.main.preferredLocalizations.first! as String
        formatter.locale = Locale(identifier: language)
        formatter.dateFormat = format;
        return formatter.string(from: self)
    }
}

public enum BubbleDataType: Int {
    case none = -1
    case me = 0
    case someone
}

//extension BubbleDataType: Equatable {}
//public func ==(lhs: BubbleDataType, rhs: BubbleDataType) -> Bool {
//    return lhs.rawValue == rhs.rawValue
//}

public class LynnAttachedImageData:NSObject {
    
    public var placeHolderImage:UIImage?
    public var failureImage:UIImage?
    public var image: UIImage?
    public var imageURL: String?
    public var imageLoaded:Bool = false
    
    
    init(image:UIImage) {
        self.image = image
    }
    
    init(named:String) {
        self.image = UIImage(named: named)
    }
    
    init(url:String, placeHolderImage holder:UIImage? = nil, failureImage failure:UIImage? = nil) {
        self.imageURL = url
        self.placeHolderImage = holder
        self.failureImage = failure
    }
    
    func getImageHeight(tableViewWidth width:CGFloat) -> CGFloat {
        if self.image == nil {
            if let tempImg = self.placeHolderImage ?? self.failureImage {
                return ((tempImg.size.height) * (width / 2)) / (tempImg.size.width)
            }else{
                return 10
            }
        }else{
            let imageHeight = self.image!.size.height
            let imageWidth = self.image!.size.width
            let height = (imageHeight * (width / 2)) / imageWidth
            return height
            
        }
    }
    

}

public class LynnUserData :NSObject {
    
    private(set) public var userProfileImage: UIImage?
    private(set) public var userID:String
    private(set) public var userNickName:String?
    public var userInfo: AnyObject?
    
    init(userUniqueId userId:String, userNickName nick:String? = nil, userProfileImage profileImg:UIImage? = nil, additionalInfo userInfo:AnyObject? = nil) {
        
        self.userID = userId
        self.userNickName = nick
        self.userProfileImage = profileImg
        self.userInfo = userInfo
        
        super.init();
    }
}

public protocol LynnAttachedImageProtocol : class {
    var imageData:LynnAttachedImageData? { set get }
    func imageUpdate(to imgView:UIImageView)
}

extension LynnAttachedImageProtocol {
    func imageUpdate(to imgView:UIImageView) {
        
        guard let _ = self.imageData else {
            return
        }
        
        if self.imageData!.imageLoaded {
            imgView.image = self.imageData!.image
            return;
        }else{
            if self.imageData!.image != nil {
                imgView.image = self.imageData!.image
                self.imageData!.imageLoaded = true
                NotificationCenter.default.post(name: Notification.Name(rawValue: "_CellDidLoadImageNotification"), object: imgView.superview?.superview)
                return
            }else{
                guard let url = self.imageData!.imageURL else {
                    self.imageData!.image = self.imageData!.failureImage
                    self.imageUpdate(to: imgView)
                    return
                }
                imgView.setImageWithUrlRequest(requestUrl: url, placeHolderImage: self.imageData?.placeHolderImage, success: { [weak self] (downloadedImage) in
                    
                    self?.imageData!.image = downloadedImage
                    self?.imageUpdate(to: imgView)
                    
                    }, failure: { [weak self] _ in
                        
                        self?.imageData!.image = self?.imageData!.failureImage
                        self?.imageUpdate(to: imgView)
                })
            }
        }
        
        /*
        DispatchQueue.global().async { [unowned self] in
            if self.imageData?.image != nil {
                imgView.image = self.imageData?.image
                NotificationCenter.default.post(name: Notification.Name(rawValue: "_CellDidLoadImageNotification"), object: imgView.superview?.superview)
                return
            }else{
                guard let url = self.imageData?.imageURL else {
                    imgView.image = self.imageData?.failureImage
                    self.imageData?.image = self.imageData?.failureImage
                    self.imageUpdate(to: imgView)
                    return
                }
                imgView.setImageWithUrlRequest(requestUrl: url, placeHolderImage: self.imageData?.placeHolderImage, success: { [weak self] (downloadedImage) in
                    
                    self?.imageData?.image = downloadedImage
                    self?.imageUpdate(to: imgView)
                    
                    }, failure: { [weak self] _ in
                        
                        self?.imageData?.image = self?.imageData?.failureImage
                        self?.imageUpdate(to: imgView)
                })
            }
        }*/
        
    }
    
    func addGesture(to imgView:UIImageView, target:UIGestureRecognizerDelegate, action:Selector) {
        let imageTapped = UITapGestureRecognizer(target: target, action: action)
        imageTapped.delegate = target
        imageTapped.numberOfTapsRequired = 1
        imgView.addGestureRecognizer(imageTapped)
    }
}

public class LynnBubbleData: NSObject {
    
    private(set) public var userDataType:BubbleDataType = .none
    private(set) public var userData:LynnUserData = LynnUserData(userUniqueId: "")
    
    private(set) public var text:String?
    private(set) public var date:Date = Date()
    
    private(set) public var imageData: LynnAttachedImageData?
    
    convenience init(userData:LynnUserData, dataOwner type:BubbleDataType,
                     message text:String?, messageDate date:Date, attachedImage imgData:LynnAttachedImageData? = nil) {
        
        self.init()
        
        self.userDataType = type
        self.userData = userData
        self.text = text
        self.date = date
        self.imageData = imgData
    }
    
    func isSameUser(_ data:LynnBubbleData) -> Bool {
        return self.userData.userID == data.userData.userID
    }
}


