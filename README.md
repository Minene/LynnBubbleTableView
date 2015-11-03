# LynnBubbleTableView
Bubble Chat UI in swift using auto layout

Simplely make an array using custom data class.
and it will automatically display everything.

#How to use
1.Import LynnBubbleTableView folder. (8 files)

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
#Convinience Function
        self.tbBubbleDemo.scrollBubbleViewToBottom(true) // true will animate
        
