//
//  ViewController.swift
//  LynnBubbleTableViewDemo
//
//  Created by Colondee :D on 2015. 11. 3..
//  Copyright © 2015년 lou. All rights reserved.
//

import UIKit

class ViewController: UIViewController,LynnBubbleViewDataSource {
    
    @IBOutlet weak var tbBubbleDemo: LynnBubbleTableView!
    
    var arrChatTest:Array<LynnBubbleData> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
//        tbBubbleDemo.delegate = self
        tbBubbleDemo.bubbleDelegate = self
        tbBubbleDemo.bubbleDataSource = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.testChatData()
    }
    
    
    
    func testChatData () {
        /*
        let userMe = LynnUserData(userUniqueId: "123", userNickName: "me", userProfileImage: nil, additionalInfo: nil)
        let userSomeone = LynnUserData(userUniqueId: "234", userNickName: "you", userProfileImage: UIImage(named: "ico_girlprofile"), additionalInfo: nil)
        
        let yesterDay = Date().addingTimeInterval(-60*60*24)
        
        
        let bubbleData:LynnBubbleData = LynnBubbleData(userData: userMe, dataOwner: .me, message: "test", messageDate: yesterDay)
        
        self.arrChatTest.append(bubbleData)  //삽입
        
        print(index)
        
        let image_width = LynnAttachedImageData(named: "cat_width.jpg")
        
        self.arrChatTest.append(LynnBubbleData(userData: userSomeone, dataOwner: .someone, message: nil, messageDate: Date(), attachedImage: image_width))  //삽입
        self.arrChatTest.append(bubbleData) //삽입
        
        
        self.tbBubbleDemo.reloadData()
        
        */
        var messageMine = "aslkjfdlkjglkjsdjglksjdflkjlskvjkldjv lkjclvkjvlkjvlklkjlcklck"
        var messageSomeone = "asklfd"
        
        let userMe = LynnUserData(userUniqueId: "123", userNickName: "me", userProfileImage: nil, additionalInfo: nil)
        let userSomeone = LynnUserData(userUniqueId: "234", userNickName: "you", userProfileImage: UIImage(named: "ico_girlprofile"), additionalInfo: nil)
        let yesterDay = Date().addingTimeInterval(-60*60*24)
        for index in 0..<10 {
            
            if index % 4 == 0 {
                //                let bubbleData:LynnBubbleData = LynnBubbleDataMine(userID: "123",userNickname: "me" , profile: nil, text: messageMine, image: nil, date: NSDate())
                
                let bubbleData:LynnBubbleData = LynnBubbleData(userData: userMe, dataOwner: .me, message: messageMine, messageDate: yesterDay)
                
                self.arrChatTest.append(bubbleData)
                messageMine += " " + messageMine
            }else {
                
                let bubbleData:LynnBubbleData = LynnBubbleData(userData: userSomeone, dataOwner: .someone, message: messageSomeone, messageDate: yesterDay)
                self.arrChatTest.append(bubbleData)
                messageSomeone += " " + messageSomeone
            }
            
        }
        
        let image_width = LynnAttachedImageData(named: "cat_width.jpg")
        let image_height = LynnAttachedImageData(named: "cat_height.jpg")
        
        let imgDataCat1 = LynnAttachedImageData(url: "http://i.imgur.com/FkInYhB.jpg")
        let imgDataCat2 = LynnAttachedImageData(url: "http://i.imgur.com/Mi8CAdV.jpg")
        let imgDataCat3 = LynnAttachedImageData(url: "http://i.imgur.com/Mi8CAdV.jpg", placeHolderImage: UIImage(named: "message_loading"), failureImage: UIImage(named: "message_loading_fail"))
        let imgDataCatFail = LynnAttachedImageData(url: "http://i.imgur.com/404notfound.jpg", placeHolderImage: UIImage(named: "message_loading"), failureImage: UIImage(named: "message_loading_fail"))
        
        self.arrChatTest.append(LynnBubbleData(userData: userMe, dataOwner: .me, message: nil, messageDate: Date(), attachedImage: image_width))
        self.arrChatTest.append(LynnBubbleData(userData: userSomeone, dataOwner: .someone, message: nil, messageDate: Date(), attachedImage: image_height))
        self.arrChatTest.append(LynnBubbleData(userData: userMe, dataOwner: .me, message: nil, messageDate: Date(), attachedImage: imgDataCat1))
        self.arrChatTest.append(LynnBubbleData(userData: userSomeone, dataOwner: .someone, message: nil, messageDate: Date(), attachedImage: imgDataCat2))
        self.arrChatTest.append(LynnBubbleData(userData: userSomeone, dataOwner: .someone, message: nil, messageDate: Date(), attachedImage: imgDataCat3))
        self.arrChatTest.append(LynnBubbleData(userData: userSomeone, dataOwner: .someone, message: nil, messageDate: Date(), attachedImage: imgDataCatFail))
        self.arrChatTest.append(LynnBubbleData(userData: userSomeone, dataOwner: .someone, message: nil, messageDate: Date(), attachedImage: imgDataCat2))
        
        messageMine = "aslkjfdlkjglkjsdjglksjdflkjlskvjkldjv lkjclvkjvlkjvlklkjlcklck"
        messageSomeone = "asklfd"
        let tommorow = Date().addingTimeInterval(60*60*24)
        
        for index in 0..<10 {
            
            if index % 4 == 0 {
                //                let bubbleData:LynnBubbleData = LynnBubbleDataMine(userID: "123",userNickname: "me" , profile: nil, text: messageMine, image: nil, date: NSDate())
                
                let bubbleData:LynnBubbleData = LynnBubbleData(userData: userMe, dataOwner: .me, message: messageMine, messageDate: tommorow)
                
                self.arrChatTest.append(bubbleData)
                messageMine += " " + messageMine
            }else {
                
                let bubbleData:LynnBubbleData = LynnBubbleData(userData: userSomeone, dataOwner: .someone, message: messageSomeone, messageDate: tommorow)
                self.arrChatTest.append(bubbleData)
                messageSomeone += " " + messageSomeone
            }
            
        }
        
        self.tbBubbleDemo.reloadData()
 
    }
    
    func bubbleTableView(dataAt index: Int, bubbleTableView: LynnBubbleTableView) -> LynnBubbleData {
        return self.arrChatTest[index]
    }
    
    func bubbleTableView(numberOfRows bubbleTableView: LynnBubbleTableView) -> Int {
        return self.arrChatTest.count
    }
}

extension ViewController : LynnBubbleViewDelegate {
    // optional
    func bubbleTableView(_ bubbleTableView: LynnBubbleTableView, didSelectRowAt index: Int) {
        
        let alert = UIAlertController(title: nil, message: "selected index : " + "\(index)", preferredStyle: .alert)
        let closeAction = UIAlertAction(title: "Close",
                                        style: .default) { (action: UIAlertAction!) -> Void in
        }
        alert.addAction(closeAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func bubbleTableView(_ bubbleTableView: LynnBubbleTableView, didLongTouchedAt index: Int) {
        let alert = UIAlertController(title: nil, message: "LongTouchedAt index : " + "\(index)", preferredStyle: .alert)
        let closeAction = UIAlertAction(title: "Close",
                                        style: .default) { (action: UIAlertAction!) -> Void in
        }
        alert.addAction(closeAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func bubbleTableView(_ bubbleTableView: LynnBubbleTableView, didTouchedAttachedImage image: UIImage, at index: Int) {
        let alert = UIAlertController(title: nil, message: "AttachedImage index : " + "\(index)", preferredStyle: .alert)
        let closeAction = UIAlertAction(title: "Close",
                                        style: .default) { (action: UIAlertAction!) -> Void in
        }
        alert.addAction(closeAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func bubbleTableView(_ bubbleTableView: LynnBubbleTableView, didTouchedUserProfile userData: LynnUserData, at index: Int) {
        let alert = UIAlertController(title: nil, message: "UserProfile index : " + "\(index)", preferredStyle: .alert)
        let closeAction = UIAlertAction(title: "Close",
                                        style: .default) { (action: UIAlertAction!) -> Void in
        }
        alert.addAction(closeAction)
        self.present(alert, animated: true, completion: nil)
    }
}


