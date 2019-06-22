//
//  IAPHelper.swift
//  AllergyIndicator
//
//  Created by Cappillen on 8/5/18.
//  Copyright © 2018 Cappillen. All rights reserved.
//

import Foundation
import StoreKit

class IAPHelper: NSObject {
    
    private override init() {}
    static let shared = IAPHelper()
    
    var products = [SKProduct]()
    let paymentQueue = SKPaymentQueue.default()
    
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
            print(transaction.transactionState.status(), transaction.payment.productIdentifier)
            switch transaction.transactionState {
            case .purchasing:
                break
            case .purchased:
                Pictures.incrementPictureCount()
                SKPaymentQueue.default().finishTransaction(transaction as SKPaymentTransaction)
                break
            case .failed:
                SKPaymentQueue.default().finishTransaction(transaction as SKPaymentTransaction)
                break
            default:
                queue.finishTransaction(transaction)
//                Pictures.incrementPictureCount()
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
        }
    }
}
