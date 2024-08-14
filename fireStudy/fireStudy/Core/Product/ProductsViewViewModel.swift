//
//  ProductsViewViewModel.swift
//  fireStudy
//
//  Created by Alexandra on 26.07.2024.
//

import Foundation
import FirebaseFirestore

@MainActor
final class ProductsViewViewModel: ObservableObject {
    
    @Published private(set) var products: [Product] = []
    @Published var selectedFilter: FilterOption? = nil
    @Published var selectedCategory: CategoryOption? = nil
    private var lastDocument: DocumentSnapshot? = nil

    enum FilterOption: String, CaseIterable {
        case noFilter
        case priceHigh
        case proceLow
        
        var priceDescending: Bool? {
            switch self {
            case .noFilter: return nil
            case .priceHigh: return true
            case .proceLow: return false
            }
        }
    }
    
    func filterSelected(option: FilterOption) async throws {
        self.selectedFilter = option
        self.products = []
        self.lastDocument = nil
        self.getProducts()
    }
    
    enum CategoryOption: String, CaseIterable {
        case noCategory
        case groceries
        case beauty
        case furniture
        
        var categoryKey: String? {
            if self == .noCategory {
                return nil
            }
            return self.rawValue
        }
    }
    
    func categorySelected(option: CategoryOption) async throws {
        self.selectedCategory = option
        self.products = []
        self.lastDocument = nil
        self.getProducts()
    }
    
    func getProducts() {
        
        print("LAST DOC: \(String(describing: lastDocument))")
        Task {
            let (newProduct, lastDocument) = try await ProductsManager.shared.getAllProducts(descending: selectedFilter?.priceDescending, category: selectedCategory?.categoryKey, count: 10, lastDocument: lastDocument)
            self.products.append(contentsOf: newProduct)
            if let lastDocument {
                self.lastDocument = lastDocument
            }
            print("RETURNED DOC: \(String(describing: lastDocument))")
        }
    }
    
    func getProductsCount() {
        Task {
            let count = try await ProductsManager.shared.getAllProductCount()
            print("ALL PRODUCT ACCOUNT \(count)")
        }
    }
    
    func addUserFavoriteProduct(productId: Int) {
        Task {
            let authDataResult = try AuthManager.shared.getAuthUser()
            try await UserManager.shared.addUserFavoriteProduct(userId: authDataResult.uid, productId: productId)
        }
    }
    
//    func getProductsByRating() {
//        Task {
////            let newProduct = try await ProductsManager.shared.getProductByRating(count: 3, lastRating: self.products.last?.rating)
//            let (newProduct, lastDocument) = try await ProductsManager.shared.getProductByRating(count: 3, lastDocument: lastDocument)
//            self.products.append(contentsOf: newProduct)
//            self.lastDocument = lastDocument
//        }
//    }
}
