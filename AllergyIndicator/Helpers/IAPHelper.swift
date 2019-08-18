//
//  IAPHelper.swift
//  AllergyIndicator
//
//  Created by Cappillen on 8/5/18.
//  Copyright © 2018 Cappillen. All rights reserved.
//

import Foundation
import StoreKit
import FirebaseDatabase
import FirebaseAuth

class IAPHelper: NSObject {
    
    private override init() {}
    static let shared = IAPHelper()
    
    var products = [SKProduct]()
    let paymentQueue = SKPaymentQueue.default()
    private static let DatabaseIapPath = Constants.DatabasePath.iap

    func getProducts() {
        let products: Set = [IAPProduct.Picture.rawValue]
        let request = SKProductsRequest(productIdentifiers: products)
        request.delegate = self
        request.start()
        paymentQueue.add(self)
    }
    
    func purchase(product: IAPProduct) {
        guard let productToPurchase = products.filter({ $0.productIdentifier == product.rawValue }).first else { return }
        let payment = SKPayment(product: productToPurchase)
        paymentQueue.add(payment)
    }
    
    static func isIapAllowed(for user: User, completion: @escaping (Bool) -> Void) {
        let ref = Database.database().reference().child("settings")
        
        ref.observeSingleEvent(of: .value) { (snapshot) in
            guard let settings = snapshot.value as? [String: Any] else {
                completion(false)
                return
            }
            guard let iap = settings["iap"] as? Bool else {
                completion(false)
                return
            }
            completion(iap)
        }
    }
    
    static func logTransactionReceipt(for user: User, transaction: SKPaymentTransaction) {
        let ref = Database.database().reference().child("transactions").childByAutoId()
        
        guard let tId = transaction.transactionIdentifier else {
            return;
        }
        let transactionDate = transaction.transactionDate?.timeIntervalSince1970 ?? NSDate().timeIntervalSince1970
        ref.setValue(["email": user.email,
                      "id": user.uid,
                      "transaction_id": tId,
                      "transaction_date": transactionDate,
                      "product_id": transaction.payment.productIdentifier,
                      "quatity": transaction.payment.quantity])
    }
}

extension IAPHelper: SKProductsRequestDelegate {
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        self.products = response.products
        for product in response.products {
            print(product.localizedTitle)
        }
    }
}

extension IAPHelper: SKPaymentTransactionObserver {
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {
            case .purchasing:
                break
            case .purchased:
                let pictureAmount = 30
                Pictures.incrementPictureCount(by: pictureAmount)
                IAPHelper.logTransactionReceipt(for: User.current, transaction: transaction)
                SKPaymentQueue.default().finishTransaction(transaction as SKPaymentTransaction)
                break
            case .failed:
                SKPaymentQueue.default().finishTransaction(transaction as SKPaymentTransaction)
                break
            default:
                queue.finishTransaction(transaction)
                break;
            }
        }
    }
}

extension SKPaymentTransactionState {
    func status() -> String {
        switch self {
        case .deferred:
            return "deferred"
        case .failed:
            return "failed"
        case .purchased:
            return"purchased"
        case .purchasing:
            return "purchasing"
        case .restored:
            return "restored"
         default:
            return "unknown"
        }
    }
}
