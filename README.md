# LynnBubbleTableView
Bubble Chat UI in swift using auto layout

Simplely make an array using custom data class.
and it will automatically display everything.

![ScreenShot](https://cloud.githubusercontent.com/assets/6169147/11111086/4b15448e-8948-11e5-91c6-3e3f98c10ac4.PNG) ![ScreenShot](https://cloud.githubusercontent.com/assets/6169147/11111085/4b14313e-8948-11e5-9aa5-8606f0df6a16.PNG)

#New and Changed feature this version
- Added 2 custom data model. (UserData and ImageData)

step 1. 

    let userMe = LynnUserData(userUniqueId: "123", userNickName: "me", userProfileImage: nil, additionalInfo: nil)
    
step 2.

    let imgDataCat1 = LynnAttachedImageData(url: "http://i.imgur.com/FkInYhB.jpg")
    
step 3.

    let data = LynnBubbleData(userData: userMe, dataOwner: .me, message: nil, messageDate: Date(), attachedImage: imgDataCat1)
    
- Seperated DataSource and Delegate.

previous) 

    tbBubbleDemo.bubbleDataSource = self

current)

    tbBubbleDemo.bubbleDelegate = self
    tbBubbleDemo.bubbleDataSource = self
    
- Added 3 more delegate function

        func bubbleTableView(_ bubbleTableView: LynnBubbleTableView, didLongTouchedAt index: Int)
        func bubbleTableView(_ bubbleTableView: LynnBubbleTableView, didTouchedAttachedImage image: UIImage, at index: Int)
        func bubbleTableView(_ bubbleTableView: LynnBubbleTableView, didTouchedUserProfile userData: LynnUserData, at index: Int)

- Protocol Method name has been changed like swift 3 style. 

#How to use
1.Import LynnBubbleTableView folder. (12 files)

2.Add a tableview in your storyboard or xib whatever, and change custom class from UITableView to LynnBubbleTableView in identity inspector

3.Connect IBOulet in your view controller.

4.set custom datasource. 

    self.tbBubbleDemo.bubbleDataSource = self

5.You only need 2 datasource function.

    func bubbleTableView(dataAt index: Int, bubbleTableView: LynnBubbleTableView) -> LynnBubbleData {
        return self.arrChatTest[index]
    }

    func bubbleTableView(numberOfRows bubbleTableView: LynnBubbleTableView) -> Int {
        return self.arrChatTest.count
    }
    
6.that's it

#Data Initialize
refer 'New and Changed feature this version'


#Configuration

    var grouping:Bool = true
    var scrollHeader = true
    var showWeekDayHeader = true
    var showNickName = true      
        
#Copy Right
        do it whatever you want, but please don't remove top of the 7 comment lines :)
        
        
It is my first public library. Hope it will be helpful
