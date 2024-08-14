//
//  ProductPreviewView.swift
//  fireStudy
//
//  Created by Alexandra on 24.07.2024.
//

import SwiftUI

struct ProductCellView: View {
    
    let product: Product
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            AsyncImage(url: URL(string: product.thumbnail ?? "")) { image in
                image
                    .resizable()
                    .scaledToFill()
                    .frame(width: 75, height: 75)
                    .cornerRadius(10)
                
            } placeholder: {
                ProgressView()
            }
            .frame(width: 75, height: 75)
            .shadow(color: .black.opacity(0.3), radius: 4, x: 0, y: 2)
            VStack(alignment: .leading, spacing: 4) {
                Text(product.title ?? "n/a")
                    .font(.headline)
                    .foregroundColor(.primary)
                Text("Price: $" + String(product.price ?? 0))
                Text("Rating: " + String(product.rating ?? 0))
                Text("Category: " + (product.category ?? "n/a"))
                Text("Brand: " + (product.brand ?? "n/a"))
            }
            .font(.callout)
            .foregroundColor(.secondary)
        }
    }
}

#Preview {
    ProductCellView(product: Product(id: 1, title: "Test", description: "Test", price: 11, discountPercentage: 11, rating: 11, stock: 1, brand: "Test", category: "Test", thumbnail: "Test", images: []))
}