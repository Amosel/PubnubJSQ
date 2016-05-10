import PubNub
import JSQMessagesViewController

private var jsq_message_key: UInt8 = 0

extension PNMessageResult
{
    var jsq_message : JSQMessage
    {
        get
        {
            return associatedObject(self, key: &jsq_message_key) { () -> JSQMessage in
                let date = NSDate(timeIntervalSince1970: self.data.timetoken.doubleValue)
                let text : String = self.data.message as! String
                let senderId = self.uuid
                let senderDisplayName = self.uuid
                return JSQMessage(senderId: senderId, senderDisplayName: senderDisplayName, date: date, text: text)
            }
        }
        set
        {
            associateObject(self, key: &jsq_message_key, value: newValue)
        }
    }
}

extension JSQMessage
{
    
    private func jsonEncodeDate() -> NSCopying
    {
        return date.timeIntervalSince1970
    }
    private static func jsonDecodeDate(object:AnyObject?) -> NSDate?
    {
        guard let timeInterval = object as? Double else { return nil }
        return NSDate(timeIntervalSince1970: timeInterval )
    }
    
    func jsonObject() throws -> AnyObject
    {
        guard self.isMediaMessage == false else { throw NSError(domain: "Media Messages not implemented yet", code: 0, userInfo: nil) }
        
        return [
            "senderId" : senderId,
            "senderDisplayName" : senderDisplayName,
            "date" : jsonEncodeDate(),
            "text" : text
        ]
        
    }
    
    public static func fromJSON( json: AnyObject) -> JSQMessage?
    {

        guard
            let senderId = json["senderId"] as? String,
            let senderDisplayName = json["senderDisplayName"] as? String,
            let date = jsonDecodeDate(json["date"]),
            let text = json["text"] as? String
            else
        {
                return nil
        }
        
        return JSQMessage(senderId: senderId, senderDisplayName: senderDisplayName, date: date, text: text)
    }
}