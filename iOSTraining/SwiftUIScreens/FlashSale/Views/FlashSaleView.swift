//
//  FlashSaleView.swift
//  iOSTraining
//
//  Created by Shane Gamboa - INTERN on 3/4/26.
//

import SwiftUI

// MARK: - FlashSaleView

struct FlashSaleView: View {

    @State private var viewModel = FlashSaleViewModel()

    private let primary   = Color(red: 248/255, green: 188/255, blue: 60/255)   // #F8BC3C
    private let saleRed   = Color(red: 230/255, green: 53/255,  blue: 53/255)   // flash price
    private let darkBg    = Color(red: 18/255,  green: 18/255,  blue: 24/255)   // header bg

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 0) {
                    headerSection
                    contentSection
                }
            }
            .background(Color(.systemGroupedBackground))
            .navigationBarHidden(true)
        }
        .onAppear  { viewModel.onAppear()     }
        .onDisappear { viewModel.onDisappear() }
    }

    // MARK: - Header

    private var headerSection: some View {
        ZStack {
            // Dark gradient background
            LinearGradient(
                colors: [darkBg, Color(red: 30/255, green: 20/255, blue: 5/255)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea(edges: .top)

            // Decorative dots
            GeometryReader { geo in
                ForEach(0..<6, id: \.self) { i in
                    Circle()
                        .fill(primary.opacity(0.06))
                        .frame(width: CGFloat([80,50,110,60,90,40][i]))
                        .offset(
                            x: CGFloat([geo.size.width*0.1, geo.size.width*0.8,
                                        geo.size.width*0.5, geo.size.width*0.2,
                                        geo.size.width*0.85, geo.size.width*0.6][i]),
                            y: CGFloat([20, 10, 50, 80, 60, 110][i])
                        )
                }
            }
            .frame(height: 200)

            VStack(spacing: 16) {
                // Title
                HStack(spacing: 8) {
                    Image(systemName: "bolt.fill")
                        .foregroundStyle(primary)
                        .font(.title2)
                    Text("FLASH SALE")
                        .font(.system(size: 28, weight: .black, design: .rounded))
                        .foregroundStyle(.white)
                        .tracking(2)
                    Image(systemName: "bolt.fill")
                        .foregroundStyle(primary)
                        .font(.title2)
                }

                // Phase label
                Text(viewModel.phaseLabel)
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundStyle(.white.opacity(0.7))
                    .tracking(1)

                // Countdown ring + time
                ZStack {
                    Circle()
                        .stroke(Color.white.opacity(0.1), lineWidth: 8)
                        .frame(width: 110, height: 110)

                    Circle()
                        .trim(from: 0, to: viewModel.progress)
                        .stroke(
                            AngularGradient(
                                colors: [primary, saleRed, primary],
                                center: .center
                            ),
                            style: StrokeStyle(lineWidth: 8, lineCap: .round)
                        )
                        .frame(width: 110, height: 110)
                        .rotationEffect(.degrees(-90))
                        .animation(.linear(duration: 0.9), value: viewModel.progress)

                    Text(viewModel.timeRemaining)
                        .font(.system(size: 22, weight: .bold, design: .monospaced))
                        .foregroundStyle(.white)
                }
                .padding(.bottom, 8)
            }
            .padding(.vertical, 24)
        }
        .frame(minHeight: 220)
    }

    // MARK: - Content

    @ViewBuilder
    private var contentSection: some View {
        switch viewModel.phase {
        case .loading:
            loadingView

        case .active(let items):
            activeView(items: items)

        case .waiting:
            waitingView

        case .error(let msg):
            errorView(message: msg)
        }
    }

    // MARK: - Active Sale

    private func activeView(items: [FlashSaleItem]) -> some View {
        VStack(spacing: 0) {
            // Banner
            HStack {
                Image(systemName: "flame.fill")
                    .foregroundStyle(saleRed)
                Text("\(items.count) items — limited time only!")
                    .font(.footnote)
                    .fontWeight(.semibold)
                    .foregroundStyle(saleRed)
                Spacer()
            }
            .padding(.horizontal)
            .padding(.vertical, 12)
            .background(saleRed.opacity(0.08))

            // Product grid
            LazyVGrid(
                columns: [GridItem(.flexible()), GridItem(.flexible())],
                spacing: 14
            ) {
                ForEach(items) { item in
                    FlashProductCard(item: item, saleRed: saleRed, primary: primary)
                }
            }
            .padding(14)
        }
    }

    // MARK: - Waiting / Inactive

    private var waitingView: some View {
        VStack(spacing: 24) {
            Spacer(minLength: 50)

            Image(systemName: "clock.badge.exclamationmark")
                .font(.system(size: 60))
                .foregroundStyle(primary.opacity(0.7))

            VStack(spacing: 8) {
                Text("No active flash sale right now")
                    .font(.title3)
                    .fontWeight(.bold)

                Text("The next flash sale will start soon.\nCheck back when the countdown hits zero!")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }
            .padding(.horizontal, 32)

            // Teaser skeleton cards
            VStack(alignment: .leading, spacing: 8) {
                Text("Coming up next…")
                    .font(.footnote)
                    .fontWeight(.semibold)
                    .foregroundStyle(.secondary)
                    .padding(.horizontal)

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(0..<5) { _ in
                            teaserCard
                        }
                    }
                    .padding(.horizontal)
                }
            }

            Spacer(minLength: 40)
        }
    }

    private var teaserCard: some View {
        RoundedRectangle(cornerRadius: 12)
            .fill(Color(.systemBackground))
            .frame(width: 120, height: 160)
            .overlay(
                VStack(spacing: 10) {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color(.systemGray5))
                        .frame(width: 80, height: 80)
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color(.systemGray5))
                        .frame(width: 80, height: 10)
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color(.systemGray6))
                        .frame(width: 60, height: 10)
                }
            )
            .redacted(reason: .placeholder)
    }

    // MARK: - Loading / Error

    private var loadingView: some View {
        VStack(spacing: 20) {
            Spacer(minLength: 60)
            ProgressView()
                .scaleEffect(1.4)
                .tint(primary)
            Text("Loading flash deals…")
                .font(.subheadline)
                .foregroundStyle(.secondary)
            Spacer()
        }
    }

    private func errorView(message: String) -> some View {
        VStack(spacing: 16) {
            Spacer(minLength: 60)
            Image(systemName: "wifi.slash")
                .font(.system(size: 50))
                .foregroundStyle(.secondary)
            Text("Failed to load deals")
                .font(.headline)
            Text(message)
                .font(.caption)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            Spacer()
        }
    }
}

// MARK: - FlashProductCard

struct FlashProductCard: View {

    let item     : FlashSaleItem
    let saleRed  : Color
    let primary  : Color

    @State private var appear = false

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Thumbnail
            ZStack(alignment: .topTrailing) {
                AsyncImage(url: URL(string: item.product.thumbnail)) { image in
                    image.resizable().scaledToFill()
                } placeholder: {
                    Color(.systemGray5)
                }
                .frame(height: 130)
                .clipped()
                .clipShape(UnevenRoundedRectangle(
                    topLeadingRadius: 12, bottomLeadingRadius: 0,
                    bottomTrailingRadius: 0, topTrailingRadius: 12
                ))

                // % OFF badge
                Text("-\(item.discountPercent)%")
                    .font(.system(size: 11, weight: .black))
                    .foregroundStyle(.white)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 3)
                    .background(saleRed)
                    .clipShape(Capsule())
                    .padding(8)
            }

            VStack(alignment: .leading, spacing: 6) {
                Text(item.product.title)
                    .font(.caption)
                    .fontWeight(.medium)
                    .lineLimit(2)
                    .padding(.top, 8)

                HStack(alignment: .firstTextBaseline, spacing: 4) {
                    Text("$\(item.flashPrice, specifier: "%.2f")")
                        .font(.subheadline)
                        .fontWeight(.bold)
                        .foregroundStyle(saleRed)

                    Text("$\(item.originalPrice, specifier: "%.2f")")
                        .font(.caption2)
                        .strikethrough()
                        .foregroundStyle(.secondary)
                }

                // Rating stars
                HStack(spacing: 2) {
                    Image(systemName: "star.fill")
                        .font(.system(size: 9))
                        .foregroundStyle(primary)
                    Text(String(format: "%.1f", item.product.rating))
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }
                .padding(.bottom, 10)
            }
            .padding(.horizontal, 10)
        }
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(color: .black.opacity(0.06), radius: 6, x: 0, y: 3)
        .scaleEffect(appear ? 1 : 0.92)
        .opacity(appear ? 1 : 0)
        .onAppear {
            withAnimation(.spring(response: 0.4, dampingFraction: 0.7).delay(0.05)) {
                appear = true
            }
        }
    }
}

// MARK: - Preview

#Preview {
    FlashSaleView()
}
