//
//  ViewController.swift
//  daily.dose
//
//  Created by Stefan Markovic on 8/10/17.
//  Copyright © 2017 Stefan Markovic. All rights reserved.
//

import UIKit
import GoogleMobileAds

class HomeVC: UIViewController {

    @IBOutlet weak var bannerView: GADBannerView!
    @IBOutlet weak var removeAdsBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if UserDefaults.standard.bool(forKey: PurchaseManager.instance.IAP_REMOVE_ADS) {
            removeAdsBtn.removeFromSuperview()
            bannerView.removeFromSuperview()
        } else {
            bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
            bannerView.rootViewController = self
            bannerView.load(GADRequest())
        }
    }

    @IBAction func removeAds(_ sender: UIButton) {
        // show a loading screen ActivityIndicator
        PurchaseManager.instance.purchaseRemoveAds { success in
            //dismiss spiner
            if success {
                self.bannerView.removeFromSuperview()
                self.removeAdsBtn.removeFromSuperview()
            } else {
                //show msg to the user why it failed
            }
        }
        
    }
    

}

