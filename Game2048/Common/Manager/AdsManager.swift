//
//  AdsManager.swift
//  Game2048
//
//  Created by kokozu on 21/12/2017.
//  Copyright © 2017 guoyi. All rights reserved.
//

import UIKit
import GoogleMobileAds

class AdsManager: NSObject {
    
    static let instance = AdsManager()
    var interstitial: GADInterstitial!
    var completeBlock: ((Bool)->Void)?
    var didLeaveApp = false
    var viewController: UIViewController?
    
    
    override init() {
        super.init()
        GADMobileAds.configure(withApplicationID: "ca-app-pub-4042023740334492~2954900866")
    }
    
    func loadAd() {
        interstitial = GADInterstitial(adUnitID: "ca-app-pub-4042023740334492/2398042250")
        interstitial.delegate = self
        
        let request = GADRequest()
        request.testDevices = [kGADSimulatorID]
        interstitial.load(request)
    }
    
    func showInterstitial(viewController: UIViewController, complete: @escaping (Bool) -> Void) {
        loadAd()
        completeBlock = complete
        self.viewController = viewController
    }
}

extension AdsManager: GADInterstitialDelegate {
    func interstitialDidReceiveAd(_ ad: GADInterstitial) {
        debugPrint("load ad complete")
        guard let showController = viewController else { return }
        guard let complete = completeBlock else { return }
        
        if ad.isReady {
            ad.present(fromRootViewController: showController)
        } else {
            debugPrint("不存在插页广告")
            complete(false)
        }
    }
    
    func interstitial(_ ad: GADInterstitial, didFailToReceiveAdWithError error: GADRequestError) {
        debugPrint("load ad error \(error)")
    }
    
    func interstitialWillPresentScreen(_ ad: GADInterstitial) {
        didLeaveApp = false
    }
    
    func interstitialDidFail(toPresentScreen ad: GADInterstitial) {
        
    }
    
    func interstitialWillDismissScreen(_ ad: GADInterstitial) {
        
    }
    
    func interstitialDidDismissScreen(_ ad: GADInterstitial) {
        guard let complete = completeBlock else {
            debugPrint("interstitail complete black is empty")
            return
        }
        complete(didLeaveApp)
    }
    
    func interstitialWillLeaveApplication(_ ad: GADInterstitial) {
        didLeaveApp = true
    }
}
