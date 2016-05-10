import UIKit

protocol StoredObjectIdentifierType
{
    associatedtype ValueType
    var key : String { get }
}

struct StoredObjectIdentifier <T : Any> : StoredObjectIdentifierType
{
    typealias ValueType = T
    let key : String
}

class Defaults
{
    var userDefaults : NSUserDefaults
    var cache : [String : AnyObject]
    var key : String
    
    init(key:String, userDefaults:NSUserDefaults = NSUserDefaults.standardUserDefaults())
    {
        self.userDefaults = userDefaults
        self.key = key
        self.cache = userDefaults.objectForKey(key) as? [String : AnyObject] ?? [:]
        save()
    }
    
    func get <T :StoredObjectIdentifierType>(identifier:T, defaultValue:T.ValueType) -> T.ValueType
    {
        if let value = cache[identifier.key] as? T.ValueType
        {
            return value
        }
        set(identifier, value: defaultValue)
        return defaultValue
    }
    
    func get <T :StoredObjectIdentifierType>(identifier:T) -> T.ValueType?
    {
        return cache[identifier.key] as? T.ValueType
    }
    func set <T :StoredObjectIdentifierType>(identifier:T, value:T.ValueType?)
    {
        cache[identifier.key] = value as? AnyObject
        save()
    }
    
    func save()
    {
        userDefaults.setObject(cache, forKey: key)
        userDefaults.synchronize()
    }
}