//
//  PurchaseHelper.swift
//  Weapon Guide Fortnite
//
//  Created by Michael Isasi on 4/28/18.
//  Copyright © 2018 Jetmax25. All rights reserved.
//

import SwiftyStoreKit
import StoreKit
import Firebase
import Fabric

enum purchaseType : String {
    static let bundleId = "com.JetmaxStudios.BirthdayCountdown"
    
    case removeAds = "AdFree"
    
    var productId : String {
        return "\(purchaseType.bundleId).\(self.rawValue)"
    }
}
struct PurchaseHelper {
    
    
    static func getInfo() {
        SwiftyStoreKit.retrieveProductsInfo( [purchaseType.removeAds.productId], completion: { result in
            print(result)
            self.purchase()
        })
        
    }
    
    
    static func purchase() {
        Answers.logCustomEvent(withName: "Clicked Purchase", customAttributes: nil)
        
        SwiftyStoreKit.purchaseProduct(purchaseType.removeAds.productId, completion: {result in
            switch result {
            case .success(let purchase):
                Answers.logPurchase(withPrice: purchase.product.price, currency: "USD", success: true, itemName: "Ad Free", itemType: purchase.product.localizedTitle, itemId: purchase.productId, customAttributes: nil)
                Answers.logCustomEvent(withName: "Made Purchase")
                print("Purchase Success: \(purchase.productId)")
                UserDefaults.standard.set(true, forKey: "AdFree")
                AppDelegate.adFree = true
                NotificationCenter.default.post(name: Notification.Name.removeAd, object: nil)
            case .error(let error):
                var response : String = "N/A"
                
                switch error.code {
                case .unknown: response = "Unknown error. Please contact support"
                case .clientInvalid: response = "Not allowed to make the payment"
                case .paymentCancelled: response = "Cancelled"
                case .paymentInvalid: response = "The purchase identifier was invalid"
                case .paymentNotAllowed: response = "The device is not allowed to make the payment"
                case .storeProductNotAvailable: response = "The product is not available in the current storefront"
                case .cloudServicePermissionDenied: response = "Access to cloud service information is not allowed"
                case .cloudServiceNetworkConnectionFailed: response = "Could not connect to the network"
                case .cloudServiceRevoked: response = "User has revoked permission to use this cloud service"
                }
                Answers.logCustomEvent(withName: "Failed Purchase", customAttributes: ["Error" : response])
                NotificationCenter.default.post(name: Notification.Name.failedPurchase, object: nil)
            }
        })
        
    }
    
    static func restorePurchases() {
        Answers.logCustomEvent(withName: "Restore Purchase", customAttributes: nil)
        SwiftyStoreKit.restorePurchases(atomically: true) { results in
            if results.restoreFailedPurchases.count > 0 {
                Answers.logCustomEvent(withName: "Restore Failed", customAttributes: nil)
                print("Restore Failed: \(results.restoreFailedPurchases)")
            }
            else if results.restoredPurchases.count > 0 {
                Answers.logCustomEvent(withName: "Restored Purchase", customAttributes: nil)
                print("Restore Success: \(results.restoredPurchases)")
                UserDefaults.standard.set(true, forKey: "AdFree")
                AppDelegate.adFree = true
                NotificationCenter.default.post(name: Notification.Name.removeAd, object: nil)
            }
        }
    }
}

extension Notification.Name {
    static let removeAd = Notification.Name("removeAd")
    static let failedPurchase = Notification.Name("failedPurchase")
}
