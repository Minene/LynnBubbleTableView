//
//  LynnBubbleTableView.swift
//  To my love Derrick and LynnA
//
//  Created by Lou Hwang on 2015. 10. 30..
//  Copyright © 2015 Lou Hwang. All rights reserved.
//


import UIKit

public protocol LynnBubbleViewDataSource : class {
    
    func bubbleTableView(numberOfRows bubbleTableView:LynnBubbleTableView) -> Int
    func bubbleTableView(dataAt index:Int, bubbleTableView:LynnBubbleTableView) -> LynnBubbleData
}

@objc protocol LynnBubbleViewDelegate : NSObjectProtocol {
    
    @objc optional func bubbleTableView(_ bubbleTableView:LynnBubbleTableView, didLongTouchedAt index:Int)
    @objc optional func bubbleTableView(_ bubbleTableView:LynnBubbleTableView, didTouchedUserProfile userData:LynnUserData, at index:Int)
    @objc optional func bubbleTableView(_ bubbleTableView:LynnBubbleTableView, didTouchedAttachedImage image:UIImage, at index:Int)
//    @objc optional func bubbleTableView(_ bubbleTableView:LynnBubbleTableView, didTouchedURLLink urlLink:String, at index:Int)
    @objc optional func bubbleTableView(_ bubbleTableView:LynnBubbleTableView, didSelectRowAt index:Int)
//    @objc optional func bubbleTableView(reachedTop bubbleTableView:LynnBubbleTableView)
//    @objc optional func bubbleTableView(reachedBottom bubbleTableView:LynnBubbleTableView)
}

protocol BubbleViewCellEventDelegate : NSObjectProtocol {
    func textLongPressed(cell:MyBubbleViewCell)
    func userProfilePressed(cell:MyBubbleViewCell)
    func attachedImagePressed(cell:MyBubbleViewCell, tappedImage:UIImage)
}


open class LynnBubbleTableView: UITableView {
    
    weak var bubbleDataSource:LynnBubbleViewDataSource?
    
    weak var bubbleDelegate: LynnBubbleViewDelegate?
    
    public var grouping:Bool = true
    public var grouping_interval:Double = 60
    public var scrollHeader = true
    public var showWeekDayHeader = true
    public var showNickName = true
    fileprivate var NICK_NAME_HEIGHT:CGFloat = 24 // same as nick label height constant
    
    fileprivate var arrBubbleSection = [[LynnBubbleData]]()
    fileprivate var heightAtIndexPath = [IndexPath:CGFloat]()
    
    //    public var image_wrapping = true // not yet implemented
    
    init() {
        super.init(frame: CGRect(), style: .plain)
        initialize()
    }
    
    required public init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        initialize()
    }
    
    init(frame: CGRect) {
        super.init(frame: frame, style: .plain)
        initialize()
    }
    
    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        initialize()
    }
    
    func initialize() {
        
        self.delegate = self
        self.dataSource = self
        
        self.rowHeight = UITableViewAutomaticDimension
//        self.estimatedRowHeight = 80
        
        self.register(UINib(nibName: "LynnBubbleViewHeaderCell", bundle: nil), forCellReuseIdentifier: "lynnBubbleHeaderCell")
        self.register(UINib(nibName: "MyBubbleViewCell", bundle: nil), forCellReuseIdentifier: "myBubbleCell")
        self.register(UINib(nibName: "Someone'sBubbleViewCell", bundle: nil), forCellReuseIdentifier: "someonesBubbleCell")
        self.register(UINib(nibName: "ImageBubbleTableViewCell", bundle: nil), forCellReuseIdentifier: "myImageCell")
        self.register(UINib(nibName: "ImageBubbleSomeoneViewCell", bundle: nil), forCellReuseIdentifier: "someoneImageCell")
        
        self.separatorStyle = .none
        
        NotificationCenter.default.addObserver(self, selector: #selector(_imageDidLoadNotification(notification:)), name:NSNotification.Name(rawValue: "_CellDidLoadImageNotification"), object: nil)
        
    }
    
    deinit{
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "_CellDidLoadImageNotification"), object: nil)
    }
    
    func _imageDidLoadNotification(notification: Notification) {
        if  let cell = notification.object as? UITableViewCell {
            if let indexPath = self.indexPath(for: cell){
                DispatchQueue.main.async() {
                    if Thread.isMainThread {
                        print("main")
                    }else{
                        print("sub")
                    }
                    
                    super.reloadRows(at: [indexPath], with: .none)
                }
            }
        }
    }
    
    override open func reloadData() {
        
        guard self.bubbleDataSource != nil else { return super.reloadData() }
        
        let numberOfRows = self.bubbleDataSource!.bubbleTableView(numberOfRows: self)
        if numberOfRows > 0 {
            
            var datas = [LynnBubbleData]()
            
            for index in 0 ..< numberOfRows {
                let bubbleData = self.bubbleDataSource!.bubbleTableView(dataAt: index , bubbleTableView: self)
                datas.append(bubbleData)
            }
            
            datas.sort(by: {$0.date.timeIntervalSinceNow < $1.date.timeIntervalSinceNow})
            
            var arrBubbleDatasGroupByDay = [LynnBubbleData]()
            self.arrBubbleSection = [[]]
            
            let tempData:LynnBubbleData = datas[0]
            arrBubbleDatasGroupByDay.append(tempData)
            
            if datas.count > 1 {
                
                var compareDate = tempData.date
                
                for index in 1 ..< numberOfRows {
                    let comparedData = datas[index]
                    let textOrigin = comparedData.date._stringFromDateFormat("yyyy-MM-dd")
                    let textCompare = compareDate._stringFromDateFormat("yyyy-MM-dd")
                    
                    if textOrigin != textCompare {
                        self.arrBubbleSection.append(arrBubbleDatasGroupByDay)
                        arrBubbleDatasGroupByDay = []
                        compareDate = comparedData.date
                    }
                    arrBubbleDatasGroupByDay.append(comparedData)
                    
                    if index == numberOfRows-1 {
                        self.arrBubbleSection.append(arrBubbleDatasGroupByDay)
                    }
                }
                
            }else{
                self.arrBubbleSection.append(arrBubbleDatasGroupByDay)
            }
            
        }
        
        super.reloadData()
    }
}

extension LynnBubbleTableView : UITableViewDataSource {
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var count:Int = self.arrBubbleSection[section].count
        if count != 0 {
            count += 1 // + 1 for header Cell
        }
        return count
    }
    
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return self.arrBubbleSection.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "lynnBubbleHeaderCell") as? LynnBubbleViewHeaderCell
            let bubbleData:LynnBubbleData = self.arrBubbleSection[indexPath.section][0]
            cell!.setDate(date: bubbleData.date, withDay:showWeekDayHeader)
            return cell!
        }
        
        let bubbleData:LynnBubbleData = self.arrBubbleSection[indexPath.section][indexPath.row - 1]
        
        var cell:MyBubbleViewCell = MyBubbleViewCell()
        
        if bubbleData.userDataType == .me {
            
            if bubbleData.imageData == nil {
                cell = tableView.dequeueReusableCell(withIdentifier: "myBubbleCell") as! MyBubbleViewCell
            }else{
                cell = tableView.dequeueReusableCell(withIdentifier: "myImageCell") as! ImageBubbleTableViewCell
            }
            
            cell.gestureTarget = self
            cell.setBubbleData(data: bubbleData)
            
            return cell
            
        }else {
            
            if bubbleData.imageData == nil {
                cell = tableView.dequeueReusableCell(withIdentifier: "someonesBubbleCell") as! Someone_sBubbleViewCell
            }else{
                cell = tableView.dequeueReusableCell(withIdentifier: "someoneImageCell") as! ImageBubbleSomeoneViewCell
            }
            
            let imgCell = cell as! Someone_sBubbleViewCell
            
            if grouping && indexPath.row > 1 {
                let previousData = self.arrBubbleSection[indexPath.section][indexPath.row - 2]
                
                imgCell.setBubbleData(data: bubbleData, grouping: bubbleData.isSameUser(previousData), showNickName: showNickName && bubbleData.userData.userNickName != nil )
                
            }else{
                
                imgCell.setBubbleData(data: bubbleData, grouping: false, showNickName: showNickName && bubbleData.userData.userNickName != nil )
            }
            
//            cell.setBubbleData(data: bubbleData)
            cell.gestureTarget = self
            return cell
        }
    }
//
    @objc(tableView:heightForRowAtIndexPath:)
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.row > 0 {
            
            let bubbleData:LynnBubbleData = self.arrBubbleSection[indexPath.section][indexPath.row - 1]
            
            if bubbleData.imageData != nil {
                
                var height:CGFloat = bubbleData.imageData!.getImageHeight(tableViewWidth: tableView.bounds.size.width) + 10
                
                if bubbleData.userDataType == .me {
                    return height
                }else{
                    
                    if grouping && indexPath.row > 1{
                        let previousData:LynnBubbleData = self.arrBubbleSection[indexPath.section][indexPath.row - 2]
                        
                        if bubbleData.isSameUser(previousData) {
                            return height
                            
                        }else{
                            
                            if showNickName && bubbleData.userData.userNickName != nil {
                                height += NICK_NAME_HEIGHT
                            }
                            return height
                        }
                        
                    }else{
                        
                        if showNickName && bubbleData.userData.userNickName != nil {
                            height += NICK_NAME_HEIGHT
                        }
                        return height
                    }
                    
                    
                }
            }
        }
        return UITableViewAutomaticDimension
    }
    
    @objc(tableView:estimatedHeightForRowAtIndexPath:)
    public func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        if let height = self.heightAtIndexPath[indexPath] {
            return height
        }else{
            return UITableViewAutomaticDimension;
        }
    }
    
    @objc(tableView:willDisplayCell:forRowAtIndexPath:)
    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        self.heightAtIndexPath[indexPath] = cell.frame.size.height
    }
}

extension LynnBubbleTableView : UITableViewDelegate
{
    fileprivate func getDataRow(indexPath:IndexPath) -> Int {
        var idxCnt = 0
        for index in 0..<indexPath.section {
            idxCnt += arrBubbleSection[index].count
        }
        idxCnt += indexPath.row
        idxCnt -= 1; // decrease header row
        return idxCnt
    }
    
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row != 0 {
            self.bubbleDelegate?.bubbleTableView?(self, didSelectRowAt: self.getDataRow(indexPath: indexPath))
            tableView.deselectRow(at: indexPath, animated: false)
        }
    }
}

extension LynnBubbleTableView : BubbleViewCellEventDelegate {
    internal func attachedImagePressed(cell: MyBubbleViewCell, tappedImage:UIImage) {
        if let indexPath = self.indexPath(for: cell){
            self.bubbleDelegate?.bubbleTableView?(self, didTouchedAttachedImage: tappedImage, at: self.getDataRow(indexPath: indexPath))
        }
    }

    internal func userProfilePressed(cell: MyBubbleViewCell) {
        if let indexPath = self.indexPath(for: cell){
            let bubbleData = self.arrBubbleSection[indexPath.section][indexPath.row - 1]
            self.bubbleDelegate?.bubbleTableView?(self, didTouchedUserProfile: bubbleData.userData, at: self.getDataRow(indexPath: indexPath))
        }
    }

    internal func textLongPressed(cell:MyBubbleViewCell) {
        if let indexPath = self.indexPath(for: cell){
            self.bubbleDelegate?.bubbleTableView?(self, didLongTouchedAt: self.getDataRow(indexPath: indexPath))
        }
    }
}
