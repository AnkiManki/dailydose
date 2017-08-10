//
//  PurchaseManager.swift
//  daily.dose
//
//  Created by Stefan Markovic on 8/10/17.
//  Copyright © 2017 Stefan Markovic. All rights reserved.
//

import Foundation
import StoreKit

class PurchaseManager: NSObject, SKProductsRequestDelegate, SKPaymentTransactionObserver {
    
    static let instance = PurchaseManager()
    
    let IAP_REMOVE_ADS = "com.stefanmarkovic.daily.dose.remove.ads"
    
    var productsRequests: SKProductsRequest!
    var products = [SKProduct]()
    
    // this func is doind the request to the apple server to give us all the necessary products
    func fetchProducts(){
        
        let productIds = NSSet(object: IAP_REMOVE_ADS) as! Set<String>
        productsRequests = SKProductsRequest(productIdentifiers: productIds)
        productsRequests.delegate = self
        productsRequests.start()
    }
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        //get info from the app store, price and such and save it in products var
        if response.products.count > 0 {
            print(response.products.debugDescription)
            products = response.products
        }
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        //hello
    }
    
    
    

}
