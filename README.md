# LynnBubbleTableView
Bubble Chat UI in swift using auto layout

Simplely make an array using custom data class.
and it will automatically display everything.

![ScreenShot](https://cloud.githubusercontent.com/assets/6169147/11111086/4b15448e-8948-11e5-91c6-3e3f98c10ac4.PNG) ![ScreenShot](https://cloud.githubusercontent.com/assets/6169147/11111085/4b14313e-8948-11e5-9aa5-8606f0df6a16.PNG)

#How to use
1.Import LynnBubbleTableView folder. (14 files)

2.Add a tableview in your storyboard or xib whatever, and change custom class from UITableView to LynnBubbleTableView in identity inspector

3.Connect IBOulet in your view controller.

4.set custom datasource. (self.tbBubbleDemo.bubbleDataSource = self)

5.You only need 2 datasource function.

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
6.that's it

#Data Initialize
1. If data type is mine, use LynnBubbleDataMine class initializer
2. If data type is someone, use LynnBubbleDataSomeone class initializer
3. If data contains only text or local image, use init method start with (userID).
4. If data contains remote image, use init method start with (imageUrl).
4-1. You can set placeholder and load failure image.
4-2. If you want to use default placeholder and load failure image, please import "message_loading" and "message_loading_fail" image from imageAsset.

example)
        LynnBubbleDataMine(userID: "123",userNickname: "me" , profile: nil, text: "my message", image: nil, date: NSDate())
        LynnBubbleDataSomeone(userID: "234", userNickname: "you", profile: UIImage(named: "ico_girlprofile"), text: "someone message", image: nil, date: NSDate())
        
        LynnBubbleDataMine(userID: "123",userNickname: "me" , profile: nil, text: nil, image: local Image, date: NSDate())
        LynnBubbleDataSomeone(imageUrl: "http://remote image address", userID: "234", userNickname: "you", profile: UIImage(named: "ico_girlprofile"), date: NSDate())


#Configuration
        self.tbBubbleDemo.someoneElse_grouping = true // default is true
        self.tbBubbleDemo.header_scrollable = true // defaut is true. false is not implement yet.
        self.tbBubbleDemo.header_show_weekday = true // default is true
        self.tbBubbleDemo.refreshable = true // default is false
        self.tbBubbleDemo.show_nickname = true // default is false        
        

#Convinience Function
        self.tbBubbleDemo.scrollBubbleViewToBottom(true) // true will animate
        func bubbleTableView (bubbleTableView:LynnBubbleTableView, didSelectRowAtIndexPath indexPath: NSIndexPath) // optional, call when bubble cell did selected
        func bubbleTableViewRefreshed(bubbleTableView:LynnBubbleTableView) // optinal, call when bubble view triggered refresh action. please set self.tbBubbleDemo.refreshable = true when you use.
        
#Copy Right
        do it whatever you want, but please don't remove top of the 7 comment lines :)
        
It is my first public library. Hope it will be helpful
