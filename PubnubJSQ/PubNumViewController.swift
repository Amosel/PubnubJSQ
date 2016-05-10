import UIKit
import PubNub
import JSQMessagesViewController

public protocol JSQAvatarStoreType
{
    func avatarImageDataForMessage(message:JSQMessage) -> JSQMessageAvatarImageDataSource
}

public protocol JSQMessageStoreType
{
    func sendMessage(message:JSQMessage) throws -> Void
    func removeMessageAtIndex(index: Int) throws -> Void
    func messageAtIndex(index:Int) throws -> JSQMessage
    var numberOfMessages : Int  { get }
    
    var senderId : String { get }
    var senderDisplayName : String { get }
}

class PubNubChannleViewController: JSQMessagesViewController {
    
    var messageStore : JSQMessageStoreType!
    var avatarStore : JSQAvatarStoreType!
    var bubleImageFactory : JSQMessagesBubbleImageFactory!
    
    init(messageStore: JSQMessageStoreType, avatarStore: JSQAvatarStoreType, bubleImageFactory:JSQMessagesBubbleImageFactory = JSQMessagesBubbleImageFactory())
    {
        self.messageStore = messageStore
        self.avatarStore = avatarStore
        self.bubleImageFactory = bubleImageFactory
        
        super.init(nibName: nil, bundle: nil)
        senderId = messageStore.senderId
        senderDisplayName = messageStore.senderDisplayName
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        navigationController?.navigationBarHidden = false
    }
    struct AvatarVisibility {
        var outgoingAvatarSetting : Bool
        var incomingAvatarSetting : Bool
    }
    let avatarVisibility = AvatarVisibility(outgoingAvatarSetting: false, incomingAvatarSetting: true)
}

extension PubNubChannleViewController
{
    override func didPressSendButton(button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: NSDate!)
    {
        /**
         *  Sending a message. Your implementation of this method should do *at least* the following:
         *
         *  1. Play sound (optional)
         *  2. Add new id<JSQMessageData> object to your data source
         *  3. Call `finishSendingMessage`
         */
        JSQSystemSoundPlayer.jsq_playMessageSentSound()
        
        try! messageStore.sendMessage(JSQMessage(senderId: senderId, displayName: senderDisplayName, text: text))
        
        self.finishSendingMessage()
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return messageStore.numberOfMessages
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell
    {
        /**
         *  Override point for customizing cells
         */
        
        let cell = super.collectionView(collectionView, cellForItemAtIndexPath: indexPath) as! JSQMessagesCollectionViewCell
        
        /**
         *  Configure almost *anything* on the cell
         *
         *  Text colors, label text, label colors, etc.
         *
         *
         *  DO NOT set `cell.textView.font` !
         *  Instead, you need to set `self.collectionView.collectionViewLayout.messageBubbleFont` to the font you want in `viewDidLoad`
         *
         *
         *  DO NOT manipulate cell layout information!
         *  Instead, override the properties you want on `self.collectionView.collectionViewLayout` from `viewDidLoad`
         */
        let message = try! messageStore.messageAtIndex(indexPath.item)
        
        if (message.senderId == senderId) {
            cell.textView.textColor = .blackColor()
        }
        else {
            cell.textView.textColor = .whiteColor()
        }
        
        cell.textView.linkTextAttributes = [
            NSForegroundColorAttributeName: cell.textView.textColor!,
            NSUnderlineStyleAttributeName: NSUnderlineStyle.StyleSingle.rawValue | NSUnderlineStyle.PatternSolid.rawValue
        ]
        return cell
        
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView, messageDataForItemAtIndexPath indexPath: NSIndexPath) -> JSQMessageData
    {
        return try! messageStore.messageAtIndex(indexPath.item)
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView, didDeleteMessageAtIndexPath indexPath: NSIndexPath)
    {
        try! messageStore.removeMessageAtIndex(indexPath.item)
    }
    
    override func collectionView(collectionView:JSQMessagesCollectionView, messageBubbleImageDataForItemAtIndexPath indexPath:NSIndexPath) -> JSQMessageBubbleImageDataSource
    {
        /**
         *  You may return nil here if you do not want bubbles.
         *  In this case, you should set the background color of your collection view cell's textView.
         *
         *  Otherwise, return your previously created bubble image data objects.
         */
        
        let message = try! messageStore.messageAtIndex(indexPath.item)
        
        if message.senderId == senderId {
            return bubleImageFactory.outgoingMessagesBubbleImageWithColor(.jsq_messageBubbleLightGrayColor())
        } else {
            return bubleImageFactory.incomingMessagesBubbleImageWithColor(.jsq_messageBubbleGreenColor())
        }
    }
    
    override func collectionView(collectionView:JSQMessagesCollectionView, avatarImageDataForItemAtIndexPath indexPath:NSIndexPath) -> JSQMessageAvatarImageDataSource?
    {
        /**
         *  Return `nil` here if you do not want avatars.
         *  If you do return `nil`, be sure to do the following in `viewDidLoad`:
         *
         *  self.collectionView.collectionViewLayout.incomingAvatarViewSize = CGSizeZero;
         *  self.collectionView.collectionViewLayout.outgoingAvatarViewSize = CGSizeZero;
         *
         *  It is possible to have only outgoing avatars or only incoming avatars, too.
         */
        
        /**
         *  Return your previously created avatar image data objects.
         *
         *  Note: these the avatars will be sized according to these values:
         *
         *  self.collectionView.collectionViewLayout.incomingAvatarViewSize
         *  self.collectionView.collectionViewLayout.outgoingAvatarViewSize
         *
         *  Override the defaults in `viewDidLoad`
         */
        
        let message = try! messageStore.messageAtIndex(indexPath.item)
        
        if message.senderId == senderId {
            if !avatarVisibility.outgoingAvatarSetting {
                return nil
            }
        }
        else {
            if !avatarVisibility.incomingAvatarSetting {
                return nil;
            }
        }

        return avatarStore.avatarImageDataForMessage(message)
        
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView, attributedTextForCellTopLabelAtIndexPath indexPath: NSIndexPath) -> NSAttributedString?
    {
        /**
         *  This logic should be consistent with what you return from `heightForCellTopLabelAtIndexPath:`
         *  The other label text delegate methods should follow a similar pattern.
         *
         *  Show a timestamp for every 3rd message
         */
        if indexPath.item % 3 == 0 {
            let message = try! messageStore.messageAtIndex(indexPath.item)
            return JSQMessagesTimestampFormatter.sharedFormatter().attributedTimestampForDate(message.date)
        }
        return nil
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView, attributedTextForMessageBubbleTopLabelAtIndexPath indexPath: NSIndexPath) -> NSAttributedString?
    {
        let message = try! messageStore.messageAtIndex(indexPath.item)
        /**
         *  iOS7-style sender name labels
         */
        if message.senderId == senderId {
            return nil
        }
        if indexPath.item - 1 > 0 {
            let previousMessage: JSQMessage = try! messageStore.messageAtIndex(indexPath.item - 1)
            if previousMessage.senderId == message.senderId
            {
                return nil
            }
        }
        /**
         *  Don't specify attributes to use the defaults.
         */
        return NSAttributedString(string: message.senderDisplayName)
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView, attributedTextForCellBottomLabelAtIndexPath indexPath: NSIndexPath) -> NSAttributedString?
    {
        return nil
    }
    
}