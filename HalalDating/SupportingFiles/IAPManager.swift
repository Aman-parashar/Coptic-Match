import StoreKit
import Foundation

class IAPManager: NSObject {
    static let shared = IAPManager()
    private var products: [SKProduct] = []
    private let productIdentifiers = Set([
        "com.yourapp.weekly_subscription",
        "com.yourapp.monthly_subscription"
    ])
    
    // Updated completion handler type to include SKPaymentTransaction
    private var purchaseCompletion: ((Bool, SKPaymentTransaction?, String?) -> Void)?
    private var restoreCompletion: ((Bool, String?) -> Void)?
    

    override init() {
        super.init()
        // Start observing transactions
        SKPaymentQueue.default().add(self)
    }
    
    // Fetch available products
    func fetchProducts(completion: @escaping ([SKProduct]?, Error?) -> Void) {
        let request = SKProductsRequest(productIdentifiers: productIdentifiers)
        request.delegate = self
        request.start()
    }
    
    // Purchase subscription
    func purchaseSubscription(product: SKProduct, completion: @escaping (Bool, SKPaymentTransaction?, String?) -> Void) {
        guard SKPaymentQueue.canMakePayments() else {
            completion(false, nil, "In-App Purchases are disabled")
            return
        }
        
        self.purchaseCompletion = completion
        let payment = SKPayment(product: product)
        SKPaymentQueue.default().add(payment)
    }
    
    
    // Verify receipt
    func verifyReceipt() {
        guard let receiptUrl = Bundle.main.appStoreReceiptURL,
              let receiptData = try? Data(contentsOf: receiptUrl) else {
            return
        }
        
        // Add your receipt verification logic here
        // You might want to verify with Apple's servers
    }
}

// MARK: - SKProductsRequestDelegate
extension IAPManager: SKProductsRequestDelegate {
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        self.products = response.products
        
        if !response.invalidProductIdentifiers.isEmpty {
            print("Invalid product identifiers: \(response.invalidProductIdentifiers)")
        }
    }
}

// MARK: - SKPaymentTransactionObserver
extension IAPManager: SKPaymentTransactionObserver {
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {
            case .purchased:

                SKPaymentQueue.default().finishTransaction(transaction)
                purchaseCompletion?(true, transaction, nil)
                
            case .failed:
                SKPaymentQueue.default().finishTransaction(transaction)
                purchaseCompletion?(false, transaction, transaction.error?.localizedDescription)
                restoreCompletion?(false, transaction.error?.localizedDescription)
                
            case .restored:

                SKPaymentQueue.default().finishTransaction(transaction)
                
            case .deferred:
                purchaseCompletion?(false, transaction, "Purchase approval pending")
                
            case .purchasing:
                break
                
            @unknown default:
                break
            }
        }
    }
    
}
