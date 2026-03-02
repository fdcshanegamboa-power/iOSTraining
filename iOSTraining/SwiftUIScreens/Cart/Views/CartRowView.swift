//
//  CartRowView.swift
//  iOSTraining
//
// Cart/Views/CartRowView.swift

import SwiftUI

struct CartRowView: View {
    let item: CartItem
    let onQuantityChange: (Int) -> Void
    let onDelete: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            HStack(alignment: .top, spacing: 12) {

                // Thumbnail
                AsyncImage(url: URL(string: item.product.thumbnail)) { image in
                    image
                        .resizable()
                        .scaledToFill()
                } placeholder: {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color(.systemGray5))
                        .overlay {
                            Image(systemName: "photo")
                                .foregroundStyle(.secondary)
                        }
                }
                .frame(width: 80, height: 80)
                .clipShape(RoundedRectangle(cornerRadius: 10))

                // Info
                VStack(alignment: .leading, spacing: 4) {
                    HStack(alignment: .top) {
                        Text(item.product.title)
                            .font(.headline)
                            .fontWeight(.semibold)
                            .lineLimit(2)
                            .fixedSize(horizontal: false, vertical: true)

                        Spacer()

                        // X Delete Button
                        Button {
                            onDelete()
                        } label: {
                            Image(systemName: "xmark")
                                .font(.caption)
                                .fontWeight(.bold)
                                .foregroundStyle(.blue)
                                .padding(6)
                                .background(Color.blue.opacity(0.1))
                                .clipShape(Circle())
                        }
                    }

                    if let brand = item.product.brand {
                        Text(brand)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }

                    Spacer(minLength: 8)

                    // Quantity + Price Row
                    HStack {
                        // Quantity Stepper
                        HStack(spacing: 0) {
                            Button {
                                onQuantityChange(item.quantity - 1)
                            } label: {
                                Text("-")
                                    .font(.title3)
                                    .fontWeight(.medium)
                                    .frame(width: 32, height: 32)
                                    .foregroundStyle(item.quantity <= 1 ? Color.secondary : Color.blue)
                            }
                            .disabled(item.quantity <= 1)

                            Text("\(item.quantity)")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .frame(width: 28)
                                .multilineTextAlignment(.center)

                            Button {
                                onQuantityChange(item.quantity + 1)
                            } label: {
                                Text("+")
                                    .font(.title3)
                                    .fontWeight(.medium)
                                    .frame(width: 32, height: 32)
                                    .foregroundStyle(.blue)
                            }
                        }
                        .background(Color(.systemGray6))
                        .clipShape(RoundedRectangle(cornerRadius: 8))

                        Spacer()

                        Text("$\(item.subtotal, specifier: "%.2f")")
                            .font(.subheadline)
                            .fontWeight(.bold)
                    }
                }
            }
            .padding(14)
        }
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }
}
