//
//  PubNubSetup.swift
//  TwilioJSQ
//
//  Created by Amos Elmaliah on 4/13/16.
//  Copyright © 2016 Amos Elmaliah. All rights reserved.
//

import Foundation
import PubNub
import Keys

struct ClientData
{
    let client : PubNub
    let channel : String
    let title : String
    let senderDisplayName : String
    let senderId : String
    
}

let keys = PubnubJSQKeys()

let configuration = PNConfiguration(
    publishKey: keys.pubnubPublishKey(),
    subscribeKey: keys.pubnubSubscribeKey()
)

let defaults = Defaults(key: "PubnubSetup")
let PubnubUserId = StoredObjectIdentifier<String>(key:"PubnubUserId")
let PubnubUserChannel = StoredObjectIdentifier<String>(key:"channel")
let PubnubUserChannelTitle = StoredObjectIdentifier<String>(key:"channelTitle")
let PubnubUserDisplayName = StoredObjectIdentifier<String>(key:"userName")

let clientData = ClientData(
    client: PubNub.clientWithConfiguration(configuration),
    channel: defaults.get(PubnubUserChannel, defaultValue: "General"),
    title: defaults.get(PubnubUserChannelTitle, defaultValue: "General"),
    senderDisplayName: defaults.get(PubnubUserChannelTitle, defaultValue: "Amos"),
    senderId:defaults.get(PubnubUserId, defaultValue: NSUUID().UUIDString)
)
