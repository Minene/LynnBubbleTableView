//
//  LynnBubbleTableView.swift
//  To my love Derrick and LynnA
//
//  Created by Lou Hwang on 2015. 10. 30..
//  Copyright © 2015 Lou Hwang. All rights reserved.
//

import UIKit
import ObjectiveC

extension NSDate {
    
    func _stringWithFormat(format: String) -> String {
        let formatter = NSDateFormatter()
        let language = NSBundle.mainBundle().preferredLocalizations.first! as String
        formatter.locale = NSLocale(localeIdentifier: language)
        formatter.dateFormat = format;
        return formatter.stringFromDate(self)
    }
}

typealias dispatch_cancelable_closure = (cancel : Bool) -> Void
func _delay(time:NSTimeInterval, closure:()->Void) ->  dispatch_cancelable_closure? {
    
    func dispatch_later(clsr:()->Void) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(time * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), clsr)
    }
    
    var closure:dispatch_block_t? = closure
    var cancelableClosure:dispatch_cancelable_closure?
    
    let delayedClosure:dispatch_cancelable_closure = { cancel in
        if closure != nil {
            if (cancel == false) {
                dispatch_async(dispatch_get_main_queue(), closure!);
            }
        }
        closure = nil
        cancelableClosure = nil
    }
    
    cancelableClosure = delayedClosure
    
    dispatch_later {
        if let delayedClosure = cancelableClosure {
            delayedClosure(cancel: false)
        }
    }
    
    return cancelableClosure;
}


@objc public protocol LynnBubbleViewDataSource : NSObjectProtocol {
    
    func numberOfRowsForBubbleTable(bubbleTableView: LynnBubbleTableView) -> Int
    func bubbleTableView(bubbleTableView:LynnBubbleTableView, dataAtIndex:Int) -> LynnBubbleData?
    optional func bubbleTableView (bubbleTableView:LynnBubbleTableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    optional func bubbleTableViewRefreshed(bubbleTableView:LynnBubbleTableView)
}

public class LynnBubbleTableView: UITableView, UITableViewDelegate, UITableViewDataSource {

    internal var bubbleDataSource:LynnBubbleViewDataSource?
    public var someoneElse_grouping = true
//    public var someoneElse_grouping_interval:NSTimeInterval = 60.0
    private var arrBubbleSection:Array<Array<LynnBubbleData>> = []
    private let NICK_NAME_HEIGHT:CGFloat = 24 // same as nick label height constant
    public var header_scrollable = true
    public var header_show_weekday = true
    public var show_nickname = false
//    public var image_wrapping = true // not yet implemented
    public var refreshable = false {
        didSet {
            if refreshable {
                self.addSubview(self.refreshControl)
            }else{
                self.refreshControl.removeFromSuperview()
            }
        }
    }
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "handleRefresh:", forControlEvents: UIControlEvents.ValueChanged)
        
        return refreshControl
    }()
    
    init() {
        super.init(frame: CGRectZero, style: UITableViewStyle.Plain)
        initialize()
    }
    required public init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        initialize()
    }
    
    init(frame: CGRect) {
        super.init(frame: frame, style: UITableViewStyle.Plain)
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
        self.estimatedRowHeight = 80
        
        self.registerNib(UINib(nibName: "LynnBubbleViewHeaderCell", bundle: nil), forCellReuseIdentifier: "lynnBubbleHeaderCell")
        self.registerNib(UINib(nibName: "MyBubbleViewCell", bundle: nil), forCellReuseIdentifier: "myBubbleCell")
        self.registerNib(UINib(nibName: "Someone'sBubbleViewCell", bundle: nil), forCellReuseIdentifier: "someonesBubbleCell")
        self.registerNib(UINib(nibName: "ImageBubbleTableViewCell", bundle: nil), forCellReuseIdentifier: "myImageCell")
        self.registerNib(UINib(nibName: "ImageBubbleSomeoneViewCell", bundle: nil), forCellReuseIdentifier: "someoneImageCell")
        
        self.separatorStyle = .None
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "_imageDidLoadNotification:", name:"_CellDidLoadImageNotification", object: nil)
        
    }
    
    deinit{
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "_CellDidLoadImageNotification", object: nil)
        
    }
    
        
    override public func reloadData() {
        
        if self.bubbleDataSource != nil && self.bubbleDataSource?.numberOfRowsForBubbleTable(self) > 0 {
            
            if let numberOfRows:Int = self.bubbleDataSource!.numberOfRowsForBubbleTable(self) {
                
                var datas:Array<LynnBubbleData> = []
                
                for index in 0 ..< numberOfRows {
                    let bubbleData = self.bubbleDataSource!.bubbleTableView(self, dataAtIndex: index)
                    datas.append(bubbleData!)
                }
                
                datas.sortInPlace({$0.date!.timeIntervalSinceNow < $1.date!.timeIntervalSinceNow})
                
                var arrBubbleDatasGroupByDay:Array<LynnBubbleData> = []
                self.arrBubbleSection = []
                
                let tempData:LynnBubbleData = datas[0]
                arrBubbleDatasGroupByDay.append(tempData)
                
                if datas.count > 1 {
                    
                    let dateFormatter = NSDateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd"
                    let compareDate = tempData.date
                    
                    for index in 1 ..< numberOfRows {
                        let comparedData = datas[index]
                        let textOrigin = dateFormatter.stringFromDate(comparedData.date!)
                        let textCompare = dateFormatter.stringFromDate(compareDate!)
                        
                        if textOrigin != textCompare {
                            self.arrBubbleSection.append(arrBubbleDatasGroupByDay)
                            arrBubbleDatasGroupByDay = []
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

        }
        super.reloadData()
    }
    
    public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if var count:Int = self.arrBubbleSection[section].count {
            if count != 0 {
                ++count // + 1 for header Cell
            }
            return count
        }else {
            return 0
        }
    }
    
    public func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        if let count:Int = self.arrBubbleSection.count {
            return count
        }else {
            return 0
        }
    }
    
    public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier("lynnBubbleHeaderCell") as? LynnBubbleViewHeaderCell
            let bubbleData:LynnBubbleData = self.arrBubbleSection[indexPath.section][0]
            cell!.setDate(bubbleData.date!, withDay:header_show_weekday)
            return cell!
        }
        
        let bubbleData:LynnBubbleData = self.arrBubbleSection[indexPath.section][indexPath.row - 1]
        
        var cell:MyBubbleViewCell = MyBubbleViewCell()
        
        if bubbleData.type == BubbleDataType.Mine {

            if bubbleData.image == nil {
                cell = tableView.dequeueReusableCellWithIdentifier("myBubbleCell") as! MyBubbleViewCell
            }else{
                cell = tableView.dequeueReusableCellWithIdentifier("myImageCell") as! ImageBubbleTableViewCell
            }
            
            
        }else {

            if bubbleData.image == nil {
                cell = tableView.dequeueReusableCellWithIdentifier("someonesBubbleCell") as! Someone_sBubbleViewCell
            }else{
                cell = tableView.dequeueReusableCellWithIdentifier("someoneImageCell") as! ImageBubbleSomeoneViewCell
            }
            
            let imgCell = cell as! Someone_sBubbleViewCell
            
//            if show_nickname {
//                imgCell.lbNick.hidden = false
//                imgCell.constraintForNickHidden.constant = 24
//                
//            }else{
//                imgCell.lbNick.hidden = true
//                imgCell.constraintForNickHidden.constant = 0
//            }
//
//            if someoneElse_grouping && indexPath.row > 1{
//                let previousData:LynnBubbleData = self.arrBubbleSection[indexPath.section][indexPath.row - 2]
//
//                if previousData.type == BubbleDataType.Someone && previousData.userID == bubbleData.userID {
//                    imgCell.imgProfile.hidden = true
//                    if show_nickname {
//                        imgCell.lbNick.hidden = true
//                        imgCell.constraintForNickHidden.constant = 0
//                    }
//                }else{
//                    imgCell.imgProfile.hidden = false
//                }
//            }else{
//                imgCell.imgProfile.hidden = false
//            }
//            
//            imgCell.layoutIfNeeded()

            if someoneElse_grouping && indexPath.row > 1{
                let previousData:LynnBubbleData = self.arrBubbleSection[indexPath.section][indexPath.row - 2]
                
                if previousData.type == BubbleDataType.Someone && bubbleData.user.userID != nil && previousData.user.userID == bubbleData.user.userID {
                    imgCell.imgProfile.hidden = true
                    imgCell.constraintForNickHidden.constant = 0
                    
                }else{
                    imgCell.imgProfile.hidden = false
                    
                    if show_nickname && bubbleData.user.userNickName != nil {
                        imgCell.constraintForNickHidden.constant = NICK_NAME_HEIGHT
                    }else{
                        imgCell.constraintForNickHidden.constant = 0
                    }
                    
                }
                
            }else{
                imgCell.imgProfile.hidden = false
                
                if show_nickname && bubbleData.user.userNickName != nil {
                    imgCell.constraintForNickHidden.constant = NICK_NAME_HEIGHT
                }else{
                    imgCell.constraintForNickHidden.constant = 0
                }
            }
            imgCell.layoutIfNeeded()
        }
        
        cell.setBubbleData(bubbleData)
        
        
        
        return cell
    }
    
    public func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if indexPath.row > 1 {
            
            let bubbleData:LynnBubbleData = self.arrBubbleSection[indexPath.section][indexPath.row - 1]
            
            if bubbleData.image != nil {
                
                var height:CGFloat = bubbleData.getImageHeight(tableViewWidth: tableView.bounds.size.width) + 10
                
                
                if bubbleData.type == .Mine {
                    return height
                }else{
                    
                    if someoneElse_grouping && indexPath.row > 1{
                        let previousData:LynnBubbleData = self.arrBubbleSection[indexPath.section][indexPath.row - 2]
                        
                        if previousData.type == BubbleDataType.Someone && bubbleData.user.userID != nil && previousData.user.userID == bubbleData.user.userID {
                            return height
                            
                        }else{
                        
                            if show_nickname && bubbleData.user.userNickName != nil {
                                height += NICK_NAME_HEIGHT
                            }
                            return height
                            
                        }
                        
                    }else{
                        
                        if show_nickname && bubbleData.user.userNickName != nil {
                            height += NICK_NAME_HEIGHT
                        }
                        return height
                    }

//                    
//                    let previousData:LynnBubbleData = self.arrBubbleSection[indexPath.section][indexPath.row - 2]
//                    if previousData.type == BubbleDataType.Someone && previousData.userID == bubbleData.userID {
//                        var height:CGFloat = bubbleData.getImageHeight(tableViewWidth: tableView.bounds.size.width) + 10
//                        
//                        if someoneElse_grouping {
//                            
//                        }
//                        if show_nickname {
//                            height += 24
//                        }
//                        return height
//                        
//                    }else{
//                        var height:CGFloat = bubbleData.getImageHeight(tableViewWidth: tableView.bounds.size.width) + 10
//                        if show_nickname {
//                            height += 24
//                        }
//                        return height
//                    }

                }
            }
        }
        return UITableViewAutomaticDimension
    }
    
    func _imageDidLoadNotification(notification: NSNotification) {
        if  let cell = notification.object as? UITableViewCell {
            if let indexPath = self.indexPathForCell(cell){
                self.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .None)
            }
        }
    }
    
    public func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let reponse = self.bubbleDataSource?.respondsToSelector("bubbleTableView:didSelectRowAtIndexPath:")
        if reponse! {
            self.bubbleDataSource?.bubbleTableView!(self, didSelectRowAtIndexPath: indexPath)
        }
        
        
    }
    
    func handleRefresh(refreshControl: UIRefreshControl) {
        // Do some reloading of data and update the table view's data source
        // Fetch more objects from a web service, for example...
        
        // Simply adding an object to the data source for this example
        
        let reponse = self.bubbleDataSource?.respondsToSelector("bubbleTableViewRefreshed:")
        if reponse! {
            self.bubbleDataSource?.bubbleTableViewRefreshed!(self)
        }
        
        refreshControl.endRefreshing()
    }
    
    //MARK: - Public Method
    
    func scrollBubbleViewToBottom(animated:Bool){
        
        let delay = 0.1 * Double(NSEC_PER_SEC)
        let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        
        dispatch_after(time, dispatch_get_main_queue(), {
            let lastSectionIdx = self.numberOfSections - 1
            
            if lastSectionIdx >= 0 {
                
                let yPositionForChat = self.contentSize.height
                if yPositionForChat > self.bounds.size.height {
                    
                    self.setContentOffset(CGPointMake(0, yPositionForChat - self.bounds.size.height), animated: animated)

//                    
//                    let idx:NSIndexPath = NSIndexPath(forRow: self.numberOfRowsInSection(lastSectionIdx) - 1, inSection: lastSectionIdx)
//                    self.scrollToRowAtIndexPath(idx, atScrollPosition: .Bottom, animated: animated)
                    
                    //                self.setContentOffset(CGPointMake(0, yPositionForChat - self.bounds.size.height), animated: animated)
                }
            }
        })
    }
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
