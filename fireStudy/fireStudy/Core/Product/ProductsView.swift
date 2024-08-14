//
//  ProductsView.swift
//  fireStudy
//
//  Created by Alexandra on 24.07.2024.
//

import SwiftUI
import FirebaseFirestore

struct ProductsView: View {
    
    @StateObject private var viewModel = ProductsViewViewModel()
    
    var body: some View {
       
        List {
            ForEach(viewModel.products) { product in
               ProductCellView(product: product)
                    .contextMenu{
                        Button("Add to favorites") {
                            viewModel.addUserFavoriteProduct(productId: product.id)
                        }
                    }
                
                if product == viewModel.products.last {
                    ProgressView()
                        .onAppear {
                            print("fetch products")
                            viewModel.getProducts()
                        }
                }
            }
        }
        .navigationTitle("Products")
        .toolbar{
            ToolbarItem(placement: .navigationBarLeading) {
                Menu("Filter: \(viewModel.selectedFilter?.rawValue ?? "NONE")") {
                    ForEach(ProductsViewViewModel.FilterOption.allCases, id: \.self) { option in
                        Button(option.rawValue) {
                            Task {
                                try? await viewModel.filterSelected(option: option)
                            }
                        }
                    }
                }
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                Menu("Category: \(viewModel.selectedCategory?.rawValue ?? "NONE")") {
                    ForEach(ProductsViewViewModel.CategoryOption.allCases, id: \.self) { option in
                        Button(option.rawValue) {
                            Task {
                                try? await viewModel.categorySelected(option: option)
                            }
                        }
                    }
                }
            }
        }
        .onAppear {
            viewModel.getProductsCount()
            viewModel.getProducts()
        }
    }
}

#Preview {
    NavigationStack {
        ProductsView()
    }
}
