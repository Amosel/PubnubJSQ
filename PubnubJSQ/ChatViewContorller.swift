import UIKit
import JSQMessagesViewController

class ChatViewContorller : PubNubChannleViewController
{
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        
        let messageAndAvatarStore = PubNubJSQStore(clientData: clientData)
        messageAndAvatarStore.delegate = self
        self.messageStore = messageAndAvatarStore
        self.avatarStore = messageAndAvatarStore
        self.bubleImageFactory = JSQMessagesBubbleImageFactory()

        senderId = messageStore.senderId
        senderDisplayName = messageStore.senderDisplayName
    }
}

extension ChatViewContorller : PubNubJSQStoreDelegate
{
    func storeDidFinishRecievingMessage(store: PubNubJSQStore)
    {
        finishSendingMessage()
    }
}
