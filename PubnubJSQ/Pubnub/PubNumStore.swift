import PubNub
import JSQMessagesViewController

public protocol PubNubJSQStoreDelegate {
    func storeDidFinishRecievingMessage(store:PubNubJSQStore)
}

public class PubNubJSQStore : NSObject, PNObjectEventListener {
    
    var clientData : ClientData!
    var channel : String { return clientData.channel }
    var client : PubNub { return clientData.client }
    
    var delegate : PubNubJSQStoreDelegate?
    
    private var avatars : [String : JSQMessageAvatarImageDataSource] = [:]
    private var messages : [JSQMessage] = []
    
    init(clientData: ClientData) {
        self.clientData = clientData
        super.init()
        client.addListener(self)
        client.subscribeToChannels([channel], withPresence: true)
        client.historyForChannel(channel) {[weak self] (result, status) in
            if let historyData = result?.data
            {
                self?.appendMessageHistoryData(historyData)
            } else {
                fatalError()
            }
        }
        
        client.timeWithCompletion { (result, status) in
            if status == nil {
                
            } else {
                
            }
        }
    }

    public func client(client: PubNub, didReceiveStatus status: PNStatus)
    {
        if status.error {
            print("error publishing:\(status)")
        } else {
            switch status.category {
            case .PNUnexpectedDisconnectCategory: print("unexpectedly disconnected")
            case .PNDisconnectedCategory: print("Disconnected")
            case .PNConnectedCategory:
                print("connected!")
            default:
                print("didReceiveStatus:\(status)")
            }
        }
    }
    
    public func client(client: PubNub, didReceiveMessage message: PNMessageResult)
    {
        if let actualChannel = message.data.actualChannel
        {
            print("message receieved:\(message.data.subscribedChannel) \nChannel:\(actualChannel)")
        } else
        {
            
        }
        print("Received message: \(message.data.message) on channel \(message.data.subscribedChannel) at \(message.data.timetoken)")
        
        guard let messageData :PNMessageData = message.data  else { fatalError() }
        appendMessageData(messageData)
    }
    
    public func client(client: PubNub, didReceivePresenceEvent event: PNPresenceEventResult)
    {
        
    }

    private func appendMessageHistoryData(historyData:PNHistoryData)
    {
        let newMessages = historyData.messages.flatMap { JSQMessage.fromJSON($0) }.filter {
            !self.messages.contains($0)
        }
        if newMessages.count > 0 {
            self.messages += newMessages
            delegate?.storeDidFinishRecievingMessage(self)
        }
    }
    
    private func appendMessageData(messageData:PNMessageData)
    {
        if let message = JSQMessage.fromJSON(messageData.message!) where !messages.contains(message) {
            messages.append(message)
            delegate?.storeDidFinishRecievingMessage(self)
        }
    }
}

let notYetImplementedError = NSError(domain: "string", code: 0, userInfo: nil)

extension PubNubJSQStore : JSQMessageStoreType
{
    public var senderId : String { return clientData.senderId }
    public var senderDisplayName : String { return clientData.senderDisplayName }
    public var numberOfMessages: Int { return messages.count }
    
    public func sendMessage(message:JSQMessage) throws -> Void
    {
        let json = try message.jsonObject()
        client.publish(json, toChannel: channel, withCompletion: { (status) in
            if status.error {
                print("error publishing:\(status)")
            }
        })
    }
    
    public func removeMessageAtIndex(index: Int) throws -> Void
    {
        if messages.count > index {
            messages.removeAtIndex(index)
        } else {
            throw notYetImplementedError
        }
    }
    
    public func messageAtIndex(index:Int) throws -> JSQMessage
    {
        if messages.count > index {
            return messages[index]
        } else {
            throw notYetImplementedError
        }
    }
}


extension PubNubJSQStore : JSQAvatarStoreType
{
    func avatarImageDataForSenderId(senderId: String, andSenderDisplayName displayName:String) -> JSQMessageAvatarImageDataSource
    {
        
        if let avatar = avatars[senderId] { return avatar }
        
        let initials = displayName.nameInitials()
        
        let imageFactory =  JSQMessagesAvatarImageFactory.avatarImageWithUserInitials(
            initials,
            backgroundColor: UIColor(white: 0.85, alpha: 1.0),
            textColor: UIColor(white: 0.60, alpha: 1.0),
            font: UIFont.systemFontOfSize(14.0),
            diameter: UInt(kJSQMessagesCollectionViewAvatarSizeDefault)
        )
        avatars[senderId] = imageFactory
        
        return imageFactory
    }
    public func avatarImageDataForMessage(message:JSQMessage) -> JSQMessageAvatarImageDataSource {
        return avatarImageDataForSenderId(message.senderId, andSenderDisplayName: message.senderDisplayName)
    }
}
