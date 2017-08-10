//
//  PurchaseManager.swift
//  daily.dose
//
//  Created by Stefan Markovic on 8/10/17.
//  Copyright © 2017 Stefan Markovic. All rights reserved.
//

typealias CompletionHandler = (_ success: Bool) -> ()

import Foundation
import StoreKit

class PurchaseManager: NSObject, SKProductsRequestDelegate, SKPaymentTransactionObserver {
    
    static let instance = PurchaseManager()
    
    let IAP_REMOVE_ADS = "com.stefanmarkovic.daily.dose.remove.ads"
    
    var productsRequests: SKProductsRequest!
    var products = [SKProduct]()
    var transactionComplete: CompletionHandler?
    
    // this func is doind the request to the apple server to give us all the necessary products
    func fetchProducts(){
        
        let productIds = NSSet(object: IAP_REMOVE_ADS) as! Set<String>
        productsRequests = SKProductsRequest(productIdentifiers: productIds)
        productsRequests.delegate = self
        productsRequests.start()
    }
    
    func purchaseRemoveAds(onComplete: @escaping CompletionHandler){
        if SKPaymentQueue.canMakePayments() && products.count > 0 {
            transactionComplete = onComplete
            let removeAdsProducts = products[0]
            let payment = SKPayment(product: removeAdsProducts)
            SKPaymentQueue.default().add(self)
            SKPaymentQueue.default().add(payment)
        } else {
            onComplete(false)
        }
    }
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        //get info from the app store, price and such and save it in products var
        if response.products.count > 0 {
            print(response.products.debugDescription)
            products = response.products
        }
    }
    
    //Logic for purchasing
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {
            case .purchased:
                SKPaymentQueue.default().finishTransaction(transaction)
                if transaction.payment.productIdentifier == IAP_REMOVE_ADS {
                    UserDefaults.standard.set(true, forKey: IAP_REMOVE_ADS)
                    transactionComplete?(true)
                }
                break
            case .failed:
                SKPaymentQueue.default().finishTransaction(transaction)
                transactionComplete?(false)
                break
            case .restored:
                SKPaymentQueue.default().finishTransaction(transaction)
                transactionComplete?(true)
                break
            default:
                transactionComplete?(false)
                break
            }
        }
    }
    
    
    
    
    
    
    

}
