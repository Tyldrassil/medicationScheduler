//
//  MultiPeerConnectivityUWB.swift
//  Medication Scheduler
//
//  Created by Thomas Ditman on 29/11/2023.
//


import NearbyInteraction
import WatchConnectivity
import Combine
import os.log


// An example messaging protocol for communications between the app and the
// accessory. In your app, modify or extend this enumeration to your app's
// user experience and conform the accessory accordingly.
enum MessageId: UInt8 {
    // Messages from the accessory.
    case accessoryConfigurationData = 0x1
    case accessoryUwbDidStart = 0x2
    case accessoryUwbDidStop = 0x3
    
    // Messages to the accessory.
    case initialize = 0xA
    case configureAndStart = 0xB
    case stop = 0xC
}

class NearbyAccessoryManager: NSObject, ObservableObject {
    
    //Variables needed for nearbyAccessory according to demo code
    var dataChannel = DataCommunicationChannel()
    
    @Published var distance: Measurement<UnitLength>?
    
    private var didSendDiscoveryToken: Bool = false
    
    var configuration: NINearbyAccessoryConfiguration?
    
    var accessoryConnected = false
    
    var connectedAccessoryName: String?
    
    var accessoryMap = [NIDiscoveryToken: String]()
    
    private var session: NISession?
    
    let logger = os.Logger(subsystem: "thomas.ditman.Medication-Scheduler", category: "NearbyAccessoryManager")
    
    
    override init() {
        super.init()
        
        // Set a delegate for session updates from the framework.
        initializeNISession()
        
        // Prepare the data communication channel.
         //dataChannel.accessoryConnectedHandler = accessoryConnected
         //dataChannel.accessoryDisconnectedHandler = accessoryDisconnected
         //dataChannel.accessoryDataHandler = accessorySharedData
        dataChannel.start()
        
    }
    
    private func initializeNISession() {
        os_log("Initializing the NISession you Rude Dude")
        session = NISession()
        session?.delegate = self
        session?.delegateQueue = DispatchQueue.main
    }
    
    // MARK: - Data Channel functions
    
    func accessorySharedData(data: Data, accessoryName: String) {
        // The accessory begins each message with an identifier byte.
        // Ensure the message length is within a valid range.
        if data.count < 1 {
            //updateInfoLabel(with: "Accessory shared data length was less than one") Thomas Note: think this is a UIKIT thing
            return
        }
        
        guard let messageId = MessageId(rawValue: data.first!) else {
            fatalError("\(data.first!) is not a valid message ID.")
        }
        
        switch messageId {
            
        case .accessoryConfigurationData:
            // Access the message data by skipping the message identifier.
            assert(data.count > 1)
            let message = data.advanced(by: 1)
        case .accessoryUwbDidStart:
            //handleAccessoryUwbDidStart()
            os_log("TBD")
        case .accessoryUwbDidStop:
            //handleAccessoryUwbDidStop()
            os_log("TBD")
        case .configureAndStart:
            fatalError("Accessory should not send 'configureAndStart")
        case .initialize:
            fatalError("Accessory should not send 'initialize")
        case .stop:
            fatalError("Accessory should not send 'stop")
        }
    }
    
    func accessoryConnected(name: String) {
        accessoryConnected = true
        connectedAccessoryName = name
        //Samplecode has some label updates, think that is UIKit stuff
    }
    
    func accessoryDisconnected() {
        accessoryConnected = false
    }
    
    
    // MARK: - Accessory messages handling
    
    func setupAccessory(_ configData: Data, name: String) {
        os_log("Received configuration data from '\(name)'. Running session.")
        do {
            configuration = try NINearbyAccessoryConfiguration(data: configData)
        } catch {
            // Stop and show issue because the incoming data is invalid
            // debug accessory data to ensure expected format
            os_log("Failed to create NINearbyAccessoryConfiguration for '\(name)'. Error: \(error) ")
            return
        }
        
        // Cache the token to correlate updates with this accessory
        cacheToken(configuration!.accessoryDiscoveryToken, accessoryName: name)
        session!.run(configuration!)
    }
    
    func handleAccessoryUwbDidStart() {
        os_log("Accessory session started")
        //In the demo there is UIKit label updates here
    }
    
    func handleAccessoryUwbDidStop() {
        os_log("Accessory session started.")
        //In the demo there is UIKit label updates here. Likely just demo stuff
    }
}

extension NearbyAccessoryManager: NISessionDelegate {
    
    func session(_ session: NISession, didGenerateShareableConfigurationData shareableConfigurationData: Data, for object: NINearbyObject) {
        
        guard object.discoveryToken == configuration?.accessoryDiscoveryToken else { return }
        
        // Prepare to send message to accessory
        var msg = Data([MessageId.configureAndStart.rawValue])
        msg.append(shareableConfigurationData)
        
        let str = msg.map { String(format: "0x%02x, ", $0) }.joined()
        logger.info("Sending shareable configuration bytes: \(str).")
        
        let accessoryName = accessoryMap[object.discoveryToken] ?? "Unknown"
        
        //Send the message to the accessory
        sendDataToAccessory(msg)
        os_log("Sent shareable configuration data to '\(accessoryName)'.")
    }
    
    func session(_ session: NISession, didUpdate nearbyObjects: [NINearbyObject]) {
        guard let accessory = nearbyObjects.first else { return }
        guard let distance = accessory.distance else { return }
        guard let name = accessoryMap[accessory.discoveryToken] else { return }
        
        //UIKIt label updates, specifically distance.
    }
    
    func session(_ session: NISession, didRemove nearbyObjects: [NINearbyObject], reason: NINearbyObject.RemovalReason) {
        //Retry the session only if the peer timed out.
        guard reason == .timeout else { return }
        //UI Update
        
        // The session runs with one accessory
        guard let accessory = nearbyObjects.first else { return }
        
        //Clear the apps accessory state
        accessoryMap.removeValue(forKey: accessory.discoveryToken)
        
        //Consult helper function to decide whether or not to retry.
         //if shouldRetry(accessory) {
         //    sendDataToAccessory(Data([MessageId.stop.rawValue]))
         //    sendDataToAccessory(Data([MessageId.initialize.rawValue]))
         //}
    }
    
    func sessionWasSuspended(_ session: NISession) {
        os_log("Session was suspended")
        let msg = Data([MessageId.stop.rawValue])
        sendDataToAccessory(msg)
    }
    
    func sessionSuspensionEnded(_ session: NISession) {
        os_log("session suspension ended.")
        
        let msg = Data([MessageId.initialize.rawValue])
        sendDataToAccessory(msg)
    }
    
    func session(_ session: NISession, didInvalidateWith error: Error) {
        switch error {
        case NIError.invalidConfiguration:
            //debug the accessory data to ensure an expected format.
            os_log("The accessory configuration date is invalid again")
        case NIError.userDidNotAllow:
             handleUserDidNotAllow()
        default:
             handleSessionInvalidation()
        }
    }
    

}

// MARK: - Helpers.

extension NearbyAccessoryManager {
    
    func cacheToken(_ token: NIDiscoveryToken, accessoryName: String) {
        accessoryMap[token] = accessoryName
    }
    
    func sendDataToAccessory(_ data: Data) {
        do {
            try dataChannel.sendData(data)
        } catch {
            os_log("Failed to send data to accessory: \(error)")
        }
    }
    
    func handleSessionInvalidation() {
        os_log("Session invalidated. Restarting.")
        // Ask the accessroy to stop.
        sendDataToAccessory(Data([MessageId.stop.rawValue]))
            
        // Replace the invalidated session with a new one
        self.session = NISession()
        self.session?.delegate = self
        
        // Ask the accesory to stop
        sendDataToAccessory(Data([MessageId.initialize.rawValue]))
        
    }
    
    func shouldRetry(_ accessory: NINearbyObject) -> Bool {
        if accessoryConnected {
            return true
        }
        return false
    }
    
    func handleUserDidNotAllow() {
        // Beginning in iOS 15, persistent access state in Settings.
        os_log("Nearby Interactions access required. You can change access for NIAccessory in Settings.")
        
        
    }
    
}


class NearbyInteractionManager: NSObject, ObservableObject {
    
    
    @Published var distance: Measurement<UnitLength>?
    
    private var didSendDiscoveryToken: Bool = false
    
    var isConnected: Bool {
        return distance != nil
    }
    
    private var session: NISession?
    
    override init() {
        super.init()
        
        initializeNISession()
        
        WCSession.default.delegate = self
        WCSession.default.activate()
        
    }
    
    
    private func initializeNISession() {
        os_log("initializing the NISession")
        session = NISession()
        session?.delegate = self
        session?.delegateQueue = DispatchQueue.main
    }
    
    private func deinitializeNISession() {
        os_log("invalidating and deinitializing the NISession")
        session?.invalidate()
        session = nil
        didSendDiscoveryToken = false
    }
    
    private func restartNISession() {
        os_log("restarting the NISession")
        if let config = session?.configuration {
            session?.run(config)
        }
    }
    
    
    /// Send the local discovery token to the paired device
    private func sendDiscoveryToken() {
        guard let token = session?.discoveryToken else {
            os_log("NIDiscoveryToken not available")
            return
        }
        
        guard let tokenData = try? NSKeyedArchiver.archivedData(withRootObject: token, requiringSecureCoding: true) else {
            os_log("failed to encode NIDiscoveryToken")
            return
        }
        
        do {
            try WCSession.default.updateApplicationContext([Helper.discoveryTokenKey: tokenData])
            os_log("NIDiscoveryToken \(token) sent to counterpart")
            didSendDiscoveryToken = true
        } catch let error {
            os_log("failed to send NIDiscoveryToken: \(error.localizedDescription)")
        }
    }
    
    /// When a discovery token is received, run the session
    private func didReceiveDiscoveryToken(_ token: NIDiscoveryToken) {
        
        if session == nil { initializeNISession() }
        if !didSendDiscoveryToken { sendDiscoveryToken() }
        
        os_log("running NISession with peer token: \(token)")
        let config = NINearbyPeerConfiguration(peerToken: token)
        session?.run(config)
    }
}


// MARK: - NISessionDelegate

extension NearbyInteractionManager: NISessionDelegate {
    
    func sessionWasSuspended(_ session: NISession) {
        os_log("Session was suspended")
        distance = nil
    }
    
    func sessionSuspensionEnded(_ session: NISession) {
        os_log("Session suspension ended")
        restartNISession()
    }
    
    func session(_ session: NISession, didInvalidateWith error: Error) {
        os_log("NISession did invalidate with error: \(error.localizedDescription)")
        distance = nil
    }
    
    func session(_ session: NISession, didUpdate nearbyObjects: [NINearbyObject]) {
        if let object = nearbyObjects.first, let distance = object.distance {
            os_log("object distance: \(distance) meters")
            self.distance = Measurement(value: Double(distance), unit: .meters)
        }
    }
    
    func session(_ session: NISession, didRemove nearbyObjects: [NINearbyObject], reason: NINearbyObject.RemovalReason) {
        switch reason {
        case .peerEnded:
            os_log("the remote peer ended the connection")
            deinitializeNISession()
        case .timeout:
            os_log("peer connection timed out")
            restartNISession()
        default:
            os_log("disconnected from peer for an unknown reason")
        }
        distance = nil
    }
    
}


// MARK: - WCSessionDelegate

extension NearbyInteractionManager: WCSessionDelegate {
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        guard error == nil else {
            os_log("WCSession failed to activate: \(error!.localizedDescription)")
            return
        }
        
        switch activationState {
        case .activated:
            os_log("WCSession is activated")
            if (!didSendDiscoveryToken) {
                sendDiscoveryToken()
            }
        case .inactive:
            os_log("WCSession is inactive")
        case .notActivated:
            os_log("WCSession is not activated")
        default:
            os_log("WCSession is in an unknown state")
        }
    }
    
    #if os(iOS)
    func sessionDidBecomeInactive(_ session: WCSession) {
        os_log("WCSession did become inactive")
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        os_log("WCSession did deactivate")
    }
    
    func sessionWatchStateDidChange(_ session: WCSession) {
        os_log("""
            WCSession watch state did change:
              - isPaired: \(session.isPaired)
              - isWatchAppInstalled: \(session.isWatchAppInstalled)
            """)
    }
    #endif
    
    func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String: Any]) {
        if let tokenData = applicationContext[Helper.discoveryTokenKey] as? Data {
            if let token = try? NSKeyedUnarchiver.unarchivedObject(ofClass: NIDiscoveryToken.self, from: tokenData) {
                os_log("received NIDiscoveryToken \(token) from counterpart")
                self.didReceiveDiscoveryToken(token)
            } else {
                os_log("failed to decode NIDiscoveryToken")
            }
        }
    }
    
}


