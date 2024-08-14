//
//  ProductsManager.swift
//  fireStudy
//
//  Created by Alexandra on 24.07.2024.
//

import Foundation
import FirebaseFirestore
//import FirebaseFirestoreSwift
import Combine
 
final class ProductsManager {
    
    static let shared = ProductsManager()
    private init() { }
    
    private let productsCollection = Firestore.firestore().collection("products")
    
    private func productDocument(productId: String) -> DocumentReference {
        productsCollection.document(productId)
    }
    
    func uploadProduct(product: Product) async throws {
        try productDocument(productId: String(product.id)).setData(from: product, merge: false)
    }
    
    func getProduct(productId: String) async throws -> Product {
        try await productDocument(productId: productId).getDocument(as: Product.self)
    }
    
//    private func getAllProduct() async throws -> [Product] {
//        try await productsCollection
//            .getDocuments(as: Product.self)
//    }
//    
//    private func getAllProductsSortedByPrice(descending: Bool) async throws -> [Product] {
//        try await productsCollection
//            .order(by: Product.CodingKeys.price.rawValue, descending: descending)
//            .getDocuments(as: Product.self)
//    }
//    
//    private func getAllProductsForCategory(category: String) async throws -> [Product] {
//        try await productsCollection
//            .whereField(Product.CodingKeys.category.rawValue, isEqualTo: category)
//            .getDocuments(as: Product.self)
//    }
//    
//    private func getAllProductsByPriceAndCategory(descending: Bool, category: String) async throws -> [Product] {
//        try await productsCollection
//            .whereField(Product.CodingKeys.category.rawValue, isEqualTo: category)
//            .order(by: Product.CodingKeys.price.rawValue, descending: descending)           
//            .getDocuments(as: Product.self)
//    }
    
    private func getAllProductQuery() -> Query {
        productsCollection
    }
    
    private func getAllProductsSortedByPriceQuery(descending: Bool) -> Query {
        productsCollection
            .order(by: Product.CodingKeys.price.rawValue, descending: descending)
    }
    
    private func getAllProductsForCategoryQuery(category: String) -> Query {
        productsCollection
            .whereField(Product.CodingKeys.category.rawValue, isEqualTo: category)
    }
    
    private func getAllProductsByPriceAndCategoryQuery(descending: Bool, category: String) -> Query {
        productsCollection
            .whereField(Product.CodingKeys.category.rawValue, isEqualTo: category)
            .order(by: Product.CodingKeys.price.rawValue, descending: descending)
    }
    
    func getAllProducts(descending: Bool?, category: String?, count: Int, lastDocument: DocumentSnapshot?) async throws -> (products: [Product], lasDocument: DocumentSnapshot?) {
        var query: Query = getAllProductQuery()
        
        if let descending, let category {
            query = getAllProductsByPriceAndCategoryQuery(descending: descending, category: category)
        } else if let descending {
            query = getAllProductsSortedByPriceQuery(descending: descending)
        } else if let category {
            query = getAllProductsForCategoryQuery(category: category)
        }
        
        return try await query
            .startOptionally(afterDocument: lastDocument)
            .getDocumentsWithSnapshot(as: Product.self)
    }
    
    func getProductByRating(count: Int, lastRating: Double?) async throws -> [Product] {
        try await productsCollection
            .order(by: Product.CodingKeys.rating.rawValue, descending: true)
            .limit(to: count)
            .start(after: [lastRating ?? 99999999])
            .getDocuments(as: Product.self)
    }
    
    func getProductByRating(count: Int, lastDocument: DocumentSnapshot?) async throws -> (products: [Product], lasDocument: DocumentSnapshot?) {
        if let lastDocument {
            return try await productsCollection
                .order(by: Product.CodingKeys.rating.rawValue, descending: true)
                .limit(to: count)
                .start(afterDocument: lastDocument)
                .getDocumentsWithSnapshot(as: Product.self)
        } else {
            return try await productsCollection
                .order(by: Product.CodingKeys.rating.rawValue, descending: true)
                .limit(to: count)
                .getDocumentsWithSnapshot(as: Product.self)
        }
    }
    
    func getAllProductCount() async throws -> Int {
        try await productsCollection.aggregateCount()
    }
}


