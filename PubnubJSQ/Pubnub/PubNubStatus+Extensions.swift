import PubNub

extension PNStatusCategory : CustomStringConvertible {
    public var description: String
    {
        switch self {
        case .PNUnknownCategory: return "PNUnknownCategory"
            
            /**
             @brief      \b PubNub request acknowledgment status.
             @discussion Some API endpoints respond with request processing status w/o useful data.
             
             @since 4.0
             */
        case .PNAcknowledgmentCategory: return "PNAcknowledgmentCategory"
            
            /**
             @brief      \b PubNub Access Manager forbidden access to particular API.
             @discussion It is possible what at the moment when API has been used access rights hasn't been
             applied to the client.
             
             @since 4.0
             */
        case .PNAccessDeniedCategory: return "PNAccessDeniedCategory"
            
            /**
             @brief      API processing failed because of request time out.
             @discussion This type of status is possible in case .of very slow connection when request: return "of"
             doesn't have enough time to complete processing (send request body and receive
             server response).
             
             @since 4.0
             */
        case .PNTimeoutCategory: return "PNTimeoutCategory"
            
            /**
             @brief      API request is impossible because there is no connection.
             @discussion At the moment when API has been used there was no active connection to the
             Internet.
             
             @since 4.0
             */
        case .PNNetworkIssuesCategory: return "PNNetworkIssuesCategory"
            
            /**
             @brief      Status sent when client successfully subscribed to remote data objects live feed.
             @discussion Connected mean what client will receive live updates from \b PubNub service at
             specified set of data objects.
             
             @since 4.0
             */
        case .PNConnectedCategory: return "PNConnectedCategory"
            
            /**
             @brief      Status sent when client successfully restored subscription to remote data objects
             live feed after unexpected disconnection.
             
             @since 4.0
             */
        case .PNReconnectedCategory: return "PNReconnectedCategory"
            
            /**
             @brief      Status sent when client successfully unsubscribed from one of remote data objects
             live feeds.
             @discussion Disconnected mean what client won't receive live updates from \b PubNub service
             from set of channels used in unsubscribe API.
             
             @since 4.0
             */
        case .PNDisconnectedCategory: return "PNDisconnectedCategory"
            
            /**
             @brief  Status sent when client unexpectedly lost ability to receive live updates from
             \b PubNub service.
             @discussion This state is sent in case .of issues which doesn't allow it anymore receive live: return "of"
             updates from \b PubNub service. After issue resolve connection can be restored.
             In case .if issue appeared because of network connection client will restore: return "if"
             connection only if configured to restore subscription.
             
             @since 4.0
             */
        case .PNUnexpectedDisconnectCategory: return "PNUnexpectedDisconnectCategory"
            
            /**
             @brief      Status which is used to notify about API call cancellation.
             @discussion Mostly cancellation possible only for connection based operations
             (subscribe/leave).
             
             @since 4.0
             */
        case .PNCancelledCategory: return "PNCancelledCategory"
            
            /**
             @brief      Status is used to notify what API request from client is malformed.
             @discussion In case .if this status arrive, it is better to print out status object debug: return "if"
             description and contact support@pubnub.com
             
             @since 4.0
             */
        case .PNBadRequestCategory: return "PNBadRequestCategory"
            
            /**
             @brief      Status is used to notify what client has been configured with malformed filtering expression.
             @discussion In case .if this status arrive, check syntax used for \c -setFilterExpression: method.: return "if"
             
             @since 4.0
             */
        case .PNMalformedFilterExpressionCategory: return "PNMalformedFilterExpressionCategory"
            
            /**
             @brief      \b PubNub because of some issues sent malformed response.
             @discussion In case .if this status arrive, it is better to print out status object debug: return "if"
             description and contact support@pubnub.com
             
             @since 4.0
             */
        case .PNMalformedResponseCategory: return "PNMalformedResponseCategory"
            
            /**
             @brief      Looks like \b PubNub client can't use provided \c cipherKey to decrypt received
             message.
             @discussion In case .if this status arrive, make sure what all clients use same \c cipherKey to: return "if"
             encrypt published messages.
             
             @since 4.0
             */
        case .PNDecryptionErrorCategory: return "PNDecryptionErrorCategory"
            
            /**
             @brief      Status is sent in case .if client was unable to use API using secured connection.: return "if"
             @discussion In case .if this issue happens, client can be re-configured to use insecure: return "if"
             connection. If insecure connection is impossible then it is better to print out
             status object debug description and contact support@pubnub.com
             
             @since 4.0
             */
        case .PNTLSConnectionFailedCategory: return "PNTLSConnectionFailedCategory"
            
            /**
             @brief      Status is sent in case .if client unable to check certificates trust chain.: return "if"
             @discussion If this state arrive it is possible what proxy or VPN has been used to connect to
             internet. In another case .it is better to get output of: return "it"
             "nslookup pubsub.pubnub.com" status object debug description and mail to
             support@pubnub.com
             */
        case .PNTLSUntrustedCertificateCategory: return "PNTLSUntrustedCertificateCategory"
        }
    }
}
