//
//  FlashSaleViewModel.swift
//  iOSTraining
//
//  Created by Shane Gamboa - INTERN on 3/4/26.
//


import Foundation
import Combine

// MARK: - Sale Phase

enum SalePhase: Equatable {
    case loading
    case active(items: [FlashSaleItem])
    case waiting
    case error(String)
}

// MARK: - FlashSaleViewModel

@Observable
final class FlashSaleViewModel {

    // MARK: - Published state (SwiftUI reads these)
    private(set) var phase: SalePhase       = .loading
    private(set) var timeRemaining: String  = "--:--"
    private(set) var phaseLabel: String     = ""
    private(set) var progress: Double       = 1.0   // 0…1 used for countdown ring

    // MARK: - Private
    private let service      = FlashSaleService()
    private var allProducts  = [Product]()
    private var timer        : Timer?
    private var saleWindow   : (start: Date, end: Date)?

    // Notification observers for app lifecycle
    private var foregroundObserver: NSObjectProtocol?
    private var backgroundObserver: NSObjectProtocol?

    // MARK: - Lifecycle

    init() {
        registerLifecycleObservers()
        loadProducts()
    }

    deinit {
        stopTimer()
        if let obs = foregroundObserver { NotificationCenter.default.removeObserver(obs) }
        if let obs = backgroundObserver { NotificationCenter.default.removeObserver(obs) }
    }

    // MARK: - Public API

    /// Called by the view when it appears — ensures timer is running.
    func onAppear() {
        if timer == nil { startTimer() }
    }

    func onDisappear() {
        // Keep timer alive so countdown stays accurate; stop only on deinit.
        // If you want to save battery when tab is hidden, call stopTimer() here.
    }

    // MARK: - Data loading

    private func loadProducts() {
        guard let url = URL(string: "https://dummyjson.com/products?limit=100") else { return }

        URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            DispatchQueue.main.async {
                guard let self else { return }
                if let error {
                    self.phase = .error(error.localizedDescription)
                    return
                }
                guard let data,
                      let response = try? JSONDecoder().decode(ProductResponse.self, from: data)
                else {
                    self.phase = .error("Could not decode products.")
                    return
                }
                self.allProducts = response.products
                self.refreshSaleState()
                self.startTimer()
            }
        }.resume()
    }

    // MARK: - Sale state

    private func refreshSaleState() {
        let window      = service.currentSaleWindow()
        saleWindow      = window
        let isActive    = service.isSaleActive(in: window)

        if isActive {
            let items = service.selectFlashItems(from: allProducts)
            phase     = .active(items: items)
            phaseLabel = "Flash Sale Ends In:"
        } else {
            phase     = .waiting
            phaseLabel = "Next Flash Sale Starts In:"
        }

        updateCountdown()
    }

    // MARK: - Timer

    private func startTimer() {
        stopTimer()
        // Tolerance of 0.1 s keeps battery impact low while still looking smooth.
        timer = Timer.scheduledTimer(
            withTimeInterval: 1.0,
            repeats: true
        ) { [weak self] _ in
            self?.tick()
        }
        timer?.tolerance = 0.1
        // Add to .common so it fires while scrolling
        RunLoop.main.add(timer!, forMode: .common)
    }

    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }

    private func tick() {
        guard let window = saleWindow else { return }
        let now = Date()

        if now >= window.end {
            service.createNewCycle()
            refreshSaleState()
            return
        }
        
        let isCurrentlyActive = service.isSaleActive(in: window)
        if !isCurrentlyActive, case .active = phase {
            phase = .waiting
            phaseLabel = "Next Flash Sale Starts In:"
        }
        
        updateCountdown()
    }

    private func updateCountdown() {
        guard let window = saleWindow else { return }
        let remaining = max(0, service.secondsRemaining(in: window))
        timeRemaining = formatTime(remaining)

        let totalPhase: TimeInterval
        if service.isSaleActive(in: window) {
            totalPhase = FlashSaleConfig.saleDuration
        } else {
            totalPhase = FlashSaleConfig.cycleDuration - FlashSaleConfig.saleDuration
        }
        progress = totalPhase > 0 ? remaining / totalPhase : 0
    }

    // MARK: - Helpers

    private func formatTime(_ seconds: TimeInterval) -> String {
        let s  = Int(seconds)
        let mm = (s % 3600) / 60
        let ss = s % 60
        if s >= 3600 {
            let hh = s / 3600
            return String(format: "%02d:%02d:%02d", hh, mm, ss)
        }
        return String(format: "%02d:%02d", mm, ss)
    }

    // MARK: - App lifecycle observers

    /// When returning from background the wall-clock may have jumped.
    /// Re-evaluate which phase we are in instead of relying on tick count.
    private func registerLifecycleObservers() {
        foregroundObserver = NotificationCenter.default.addObserver(
            forName: UIApplication.willEnterForegroundNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            guard let self else { return }
            self.refreshSaleState()
            self.startTimer()   // Restart in case it was stopped
        }

        backgroundObserver = NotificationCenter.default.addObserver(
            forName: UIApplication.didEnterBackgroundNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            // Stop timer while backgrounded to save resources.
            // refreshSaleState() on foreground will recalculate correctly.
            self?.stopTimer()
        }
    }
}

// UIApplication notification names need UIKit – add import guard
#if canImport(UIKit)
import UIKit
#endif
