# LynnBubbleTableView
Bubble Chat UI in swift using auto layout

Simplely make an array using custom data class.
and it will automatically display everything.

![ScreenShot](https://cloud.githubusercontent.com/assets/6169147/11111036/960c1a18-8947-11e5-81c7-7133ab124ee3.PNG)
![ScreenShot](https://cloud.githubusercontent.com/assets/6169147/11111037/960c5690-8947-11e5-81a0-6c8d8eee1773.PNG)

#How to use
1.Import LynnBubbleTableView folder. (12 files)

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

#Configuration
        self.tbBubbleDemo.someoneElse_grouping = true // default is true
        self.tbBubbleDemo.header_scrollable = true // defaut is true. false is not implement yet.
        self.tbBubbleDemo.header_show_weekday = true // default is true
        self.tbBubbleDemo.refreshable = true // default is false

#Convinience Function
        self.tbBubbleDemo.scrollBubbleViewToBottom(true) // true will animate
        func bubbleTableView (bubbleTableView:LynnBubbleTableView, didSelectRowAtIndexPath indexPath: NSIndexPath) // optional, call when bubble cell did selected
        func bubbleTableViewRefreshed(bubbleTableView:LynnBubbleTableView) // optinal, call when bubble view triggered refresh action. please set self.tbBubbleDemo.refreshable = true when you use.
        
#Copy Right
        do it whatever you want, but please don't remove top of the 7 comment lines :)
        
It is my first public library. Hope it will be helpful
