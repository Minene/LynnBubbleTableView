//
//  ViewController.swift
//  LynnBubbleTableViewDemo
//
//  Created by Colondee :D on 2015. 11. 3..
//  Copyright © 2015년 lou. All rights reserved.
//

import UIKit

class ViewController: UIViewController, LynnBubbleViewDataSource {

    @IBOutlet weak var tbBubbleDemo: LynnBubbleTableView!
    
    var arrChatTest:Array<LynnBubbleData> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.tbBubbleDemo.bubbleDataSource = self

        self.tbBubbleDemo.someoneElse_grouping = false // default is true
        self.tbBubbleDemo.header_scrollable = true // defaut is true. false is not implement yet.
        self.tbBubbleDemo.header_show_weekday = true // default is true
        
        self.tbBubbleDemo.refreshable = true // default is false
        self.tbBubbleDemo.show_nickname = true // default is false        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.testChatData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    
    func testChatData () {
        var messageMine = "aslkjfdlkjglkjsdjglksjdflkjlskvjkldjv lkjclvkjvlkjvlklkjlcklck"
        var messageSomeone = "asklfd"
        for index in 0..<10 {
            
            if index % 4 == 0 {
                let bubbleData:LynnBubbleData = LynnBubbleDataMine(userID: "123",userNickname: "me" , profile: nil, text: messageMine, image: nil, date: NSDate())
                self.arrChatTest.append(bubbleData)
                messageMine += " " + messageMine
            }else {
                let bubbleData:LynnBubbleData = LynnBubbleDataSomeone(userID: "234", userNickname: "you", profile: UIImage(named: "ico_girlprofile"), text: messageSomeone, image: nil, date: NSDate())
                self.arrChatTest.append(bubbleData)
                messageSomeone += " " + messageSomeone
            }
            
        }
        
        let image_width = UIImage(named: "cat_width.jpg")!
        let image_height = UIImage(named: "cat_height.jpg")!
        
        self.arrChatTest.append(LynnBubbleDataMine(userID: "123", userNickname: "me",profile: nil, text: nil, image: image_width, date: NSDate()))
        self.arrChatTest.append(LynnBubbleDataSomeone(userID: "234", userNickname: "you",profile: UIImage(named: "ico_girlprofile"), text: nil, image: image_height, date: NSDate()))
        
        self.arrChatTest.append(LynnBubbleDataMine(imageUrl: "http://i.imgur.com/FkInYhB.jpg", userID: "123", userNickname: "me", profile: nil, date: NSDate()))
        self.arrChatTest.append(LynnBubbleDataSomeone(imageUrl: "http://i.imgur.com/Mi8CAdV.jpg", userID: "234", userNickname: "you", profile: UIImage(named: "ico_girlprofile"), date: NSDate()))
        self.arrChatTest.append(LynnBubbleDataSomeone(imageUrl: "http://i.imgur.com/Mi8CAdV.jpg", userID: "234", userNickname: "you", profile: UIImage(named: "ico_girlprofile"), date: NSDate()))
        self.arrChatTest.append(LynnBubbleDataSomeone(imageUrl: "http://i.imgur.com/Mi8CAdV.jpg", userID: "234", userNickname: "you", profile: UIImage(named: "ico_girlprofile"), date: NSDate()))
        self.arrChatTest.append(LynnBubbleDataSomeone(imageUrl: "http://i.imgur.com/Mi8CAdV.jpg", userID: "234", userNickname: "you", profile: UIImage(named: "ico_girlprofile"), date: NSDate()))
        
        
        self.tbBubbleDemo.reloadData()

        self.tbBubbleDemo.scrollBubbleViewToBottom(true)

    }
    
    func numberOfRowsForBubbleTable(bubbleTableView: LynnBubbleTableView) -> Int {
        return self.arrChatTest.count
    }
    
    func bubbleTableView(bubbleTableView: LynnBubbleTableView, dataAtIndex: Int) -> LynnBubbleData? {
        return self.arrChatTest[dataAtIndex]
    }
    
    // optional
    func bubbleTableView(bubbleTableView: LynnBubbleTableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let alert = UIAlertController(title: nil, message: "selected!", preferredStyle: .Alert)
        let closeAction = UIAlertAction(title: "Close",
            style: .Default) { (action: UIAlertAction!) -> Void in
        }
        alert.addAction(closeAction)
        self.presentViewController(alert, animated: true, completion: nil)
    }
    // optional
    func bubbleTableViewRefreshed(bubbleTableView: LynnBubbleTableView) {
        let alert = UIAlertController(title: nil, message: "refresh!", preferredStyle: .Alert)
        let closeAction = UIAlertAction(title: "Close",
            style: .Default) { (action: UIAlertAction!) -> Void in
        }
        alert.addAction(closeAction)
        self.presentViewController(alert, animated: true, completion: nil)
    }

}

