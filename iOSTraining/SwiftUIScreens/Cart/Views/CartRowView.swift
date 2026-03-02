//
//  CartRowView.swift
//  iOSTraining
//

import SwiftUI

struct CartRowView: View {
    let item: CartItem
    let primaryColor: Color
    let onQuantityChange: (Int) -> Void
    let onDelete: () -> Void
    let onToggleSelection: () -> Void
    
    var body: some View {
        HStack(spacing: 12) {
            // Selection Checkbox
            Button {
                onToggleSelection()
            } label: {
                Image(systemName: item.isSelected ? "checkmark.square.fill" : "square")
                    .font(.title2)
                    .foregroundStyle(item.isSelected ? primaryColor : .secondary)
            }
            .buttonStyle(.plain)
            
            // Product Image
            AsyncImage(url: URL(string: item.product.thumbnail)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                Color(.systemGray6)
            }
            .frame(width: 80, height: 80)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            
            // Product Info
            VStack(alignment: .leading, spacing: 6) {
                Text(item.product.title)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .lineLimit(2)
                
                Text("$\(item.product.price, specifier: "%.2f")")
                    .font(.headline)
                    .foregroundStyle(primaryColor)
                
                HStack(spacing: 12) {
                    // Quantity Stepper
                    HStack(spacing: 0) {
                        Button {
                            onQuantityChange(item.quantity - 1)
                        } label: {
                            Image(systemName: "minus")
                                .font(.caption)
                                .frame(width: 32, height: 32)
                        }
                        .buttonStyle(.bordered)
                        .tint(.secondary)
                        
                        Text("\(item.quantity)")
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .frame(width: 40)
                        
                        Button {
                            onQuantityChange(item.quantity + 1)
                        } label: {
                            Image(systemName: "plus")
                                .font(.caption)
                                .frame(width: 32, height: 32)
                        }
                        .buttonStyle(.bordered)
                        .tint(primaryColor)
                    }
                    
                    Spacer()
                    
                    // Delete Button
                    Button(role: .destructive) {
                        onDelete()
                    } label: {
                        Image(systemName: "trash")
                            .font(.subheadline)
                    }
                }
            }
        }
        .padding(12)
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .opacity(item.isSelected ? 1.0 : 0.7)
    }
}
