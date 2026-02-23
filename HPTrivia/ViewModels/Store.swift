//
//  Store.swift
//  HPTrivia
//
//  Created by Abhishek on 23/02/26.
//

import StoreKit

@MainActor
@Observable
class Store {
    var products: [Product] = []
    var purchased = Set<String>()
    
    private var updates: Task<Void, Never>? = nil
    
    init() {
        updates = watchForUpdates()
    }
    
    // Load available products
    func loadProducts() async {
        do {
            products = try await Product.products(for: ["hp4", "hp5", "hp6", "hp7"])
            products.sort {
                $0.displayName < $1.displayName
            }
        } catch {
            print("Unable to load products: \(error)")
        }
    }
    
    // Purchase a product
    func purchase(_ product: Product) async {
        do {
            let result = try await product.purchase()
            
            switch result {
            // Purchase successful, but now we need to verify receipt and transaction
            case .success(let verificationResult):
                switch verificationResult {
                case .unverified(let signedType, let verificationError):
                    print("Error on \(signedType): \(verificationError)")
                    
                case .verified(let signedType):
                    purchased.insert(signedType.productID)
                    
                    await signedType.finish()
                }
                
            // User cancelled or parent disapproved child's purchase request
            case .userCancelled:
                break
                
            // Waiting for some sort of approval
            case .pending:
                break
                
            @unknown default:
                break
            }
        } catch {
            print("Unable to purchase product: \(error)")
        }
    }
    
    // Check for purchased products
    private func checkPurchased() async {
        // Clear and rebuild the purchased set based on current entitlements
        var newPurchased = Set<String>()
        for product in products {
            if let result = await Transaction.latest(for: product.id) {
                switch result {
                case .unverified(let transaction, let verificationError):
                    print("Unverified transaction for \(transaction.productID): \(verificationError)")
                case .verified(let transaction):
                    if transaction.revocationDate == nil {
                        newPurchased.insert(transaction.productID)
                    }
                }
            }
        }
        purchased = newPurchased
    }
    // Recheck checkPurchase(), it might have some issues
    
    // Connect with App Store to watch for purchase and transactions updates
    private func watchForUpdates() -> Task<Void, Never> {
        Task(priority: .background) {
            for await _ in Transaction.updates {
                await checkPurchased()
            }
        }
    }
}

