//
//  LynnBubbleTableView.swift
//  To my love Derrick and LynnA
//
//  Created by Lou Hwang on 2015. 10. 30..
//  Copyright © 2015 Lou Hwang. All rights reserved.
//

import UIKit

public protocol LynnBubbleViewDataSource : NSObjectProtocol {
    
    func numberOfRowsForBubbleTable (bubbleTableView:LynnBubbleTableView) -> Int
    func bubbleTableView (bubbleTableView:LynnBubbleTableView, dataAtIndex:Int) -> LynnBubbleData
    
}

public class LynnBubbleTableView: UITableView, UITableViewDelegate, UITableViewDataSource {

    public var bubbleDataSource:LynnBubbleViewDataSource?
    public var someoneElse_grouping = true
//    public var someoneElse_grouping_interval:NSTimeInterval = 60.0
    private var arrBubbleSection:Array<Array<LynnBubbleData>> = []
    public var header_scrollable = true
    public var header_show_weekday = true
//    public var image_wrapping = true // not yet implemented
    
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
        
    }
        
    override public func reloadData() {
        
        if self.bubbleDataSource != nil && self.bubbleDataSource?.numberOfRowsForBubbleTable(self) > 0 {
            
            let numberOfRows:Int = self.bubbleDataSource!.numberOfRowsForBubbleTable(self)
            var datas:Array<LynnBubbleData> = []
            
            for index in 0 ..< numberOfRows {
                let bubbleData = self.bubbleDataSource!.bubbleTableView(self, dataAtIndex: index)
                datas.append(bubbleData)
            }
            
            datas.sortInPlace({$0.date!.timeIntervalSinceNow < $1.date!.timeIntervalSinceNow})
            
            var arrBubbleDatasGroupByDay:Array<LynnBubbleData> = []
            self.arrBubbleSection = []
        
            let tempData:LynnBubbleData = datas[0]
            arrBubbleDatasGroupByDay.append(tempData)
            
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
            
            if someoneElse_grouping && indexPath.row > 1{
                let previousData:LynnBubbleData = self.arrBubbleSection[indexPath.section][indexPath.row - 2]
                
                imgCell.imgProfile.hidden = previousData.type == BubbleDataType.Someone && previousData.userID == bubbleData.userID
                
            }else{
                imgCell.imgProfile.hidden = false
            }
            
        }
        
        cell.setBubbleData(bubbleData)
        
        
        
        return cell
    }
    
    public func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if indexPath.row > 1 {
         
            let bubbleData:LynnBubbleData = self.arrBubbleSection[indexPath.section][indexPath.row - 1]
            
            if bubbleData.image != nil {
                return ((bubbleData.image?.size.height)! * (tableView.bounds.size.width / 2)) / (bubbleData.image?.size.width)! + 10
            }
        }
        return UITableViewAutomaticDimension
    }
    
    
    //MARK: - Public Method
    
    func scrollBubbleViewToBottom(animated:Bool){
        let lastSectionIdx = self.numberOfSections - 1
        
        if lastSectionIdx >= 0 {
            
            let yPositionForChat = self.contentSize.height
            if yPositionForChat > self.bounds.size.height {
                
                let idx:NSIndexPath = NSIndexPath(forRow: self.numberOfRowsInSection(lastSectionIdx) - 1, inSection: lastSectionIdx)
                self.scrollToRowAtIndexPath(idx, atScrollPosition: .Bottom, animated: animated)
            }
        }
    }
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
