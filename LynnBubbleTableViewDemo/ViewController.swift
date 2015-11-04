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

        self.tbBubbleDemo.someoneElse_grouping = true // default is true
        self.tbBubbleDemo.header_scrollable = true // defaut is true. false is not implement yet.
        self.tbBubbleDemo.header_show_weekday = true // default is true
        
        self.testChatData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func testChatData () {
        let message = "aslkjfdlkjglkjsdjglksjdflkjlskvjkldjv lkjclvkjvlkjvlklkjlcklck"
        var text = message
        for index in 0..<10 {
            
            if index % 4 == 0 {
                let bubbleData:LynnBubbleData = LynnBubbleData(userID: "123", profile: nil, text: text, image: nil, date: NSDate())
                self.arrChatTest.append(bubbleData)
            }else {
                let bubbleData:LynnBubbleData = LynnBubbleData(userID: "234", profile: UIImage(named: "ico_girlprofile"), text: "asklfdj", image: nil, date: NSDate(), type: BubbleDataType.Someone)
                self.arrChatTest.append(bubbleData)
            }
            text += message
            
        }
        
        let image_width = UIImage(named: "cat_width.jpg")!
        let image_height = UIImage(named: "cat_height.jpg")!
        
        
        self.arrChatTest.append(LynnBubbleData(userID: "123", profile: nil, text: nil, image: image_width, date: NSDate()))
        self.arrChatTest.append(LynnBubbleData(userID: "123", profile: nil, text: nil, image: image_height, date: NSDate()))
        self.arrChatTest.append(LynnBubbleData(userID: "234", profile: UIImage(named: "ico_girlprofile"), text: nil, image: image_width, date: NSDate(), type: BubbleDataType.Someone))
        self.arrChatTest.append(LynnBubbleData(userID: "234", profile: UIImage(named: "ico_girlprofile"), text: nil, image: image_height, date: NSDate(), type: BubbleDataType.Someone))
        
        self.tbBubbleDemo.reloadData()
        
        self.tbBubbleDemo.scrollBubbleViewToBottom(true)
        
    }
    func numberOfRowsForBubbleTable(bubbleTableView: LynnBubbleTableView) -> Int {
        return self.arrChatTest.count
    }
    
    func bubbleTableView(bubbleTableView: LynnBubbleTableView, dataAtIndex: Int) -> LynnBubbleData {
        if let data:LynnBubbleData = self.arrChatTest[dataAtIndex] {
            return data
        }else {
            return LynnBubbleData()
        }
    }

}

