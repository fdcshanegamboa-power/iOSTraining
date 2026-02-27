//
//  ImageViewerViewController.swift
//  iOSTraining
//
//  Created by Shane Gamboa - INTERN on 2/27/26.
//

import UIKit

class ImageViewerViewController: UIViewController {
    
    private let imageURL: String
    private var currentScale: CGFloat = 1.0
    
    // MARK: - UI
    private let scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.minimumZoomScale = 1.0
        sv.maximumZoomScale = 4.0
        sv.showsHorizontalScrollIndicator = false
        sv.showsVerticalScrollIndicator = false
        sv.backgroundColor = .clear
        return sv
    }()
    
    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        return iv
    }()
    
    private let backgroundView: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = .black
        v.alpha = 0.92
        return v
    }()
    
    private let closeButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
        btn.tintColor = .white
        btn.contentVerticalAlignment = .fill
        btn.contentHorizontalAlignment = .fill
        return btn
    }()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let ai = UIActivityIndicatorView(style: .medium)
        ai.translatesAutoresizingMaskIntoConstraints = false
        ai.color = .white
        ai.hidesWhenStopped = true
        return ai
    }()
    
    // MARK: - Init
    init(imageURL: String) {
        self.imageURL = imageURL
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadImage()
    }
    
    // MARK: - Setup
    private func setupUI() {
        view.backgroundColor = .clear
        
        view.addSubview(backgroundView)
        view.addSubview(scrollView)
        view.addSubview(closeButton)
        view.addSubview(activityIndicator)
        scrollView.addSubview(imageView)
        scrollView.delegate = self
        
        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            imageView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            imageView.heightAnchor.constraint(equalTo: scrollView.heightAnchor),
            imageView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: scrollView.centerYAnchor),
            
            closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            closeButton.widthAnchor.constraint(equalToConstant: 32),
            closeButton.heightAnchor.constraint(equalToConstant: 32),
            
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        // Tap to dismiss
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapBackground))
        backgroundView.addGestureRecognizer(tapGesture)
        
        // Double tap to zoom
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(didDoubleTap(_:)))
        doubleTap.numberOfTapsRequired = 2
        scrollView.addGestureRecognizer(doubleTap)
        
        closeButton.addTarget(self, action: #selector(didTapClose), for: .touchUpInside)
    }
    
    private func loadImage() {
        guard let url = URL(string: imageURL) else { return }
        activityIndicator.startAnimating()
        
        URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in
            guard let data = data, let image = UIImage(data: data) else { return }
            DispatchQueue.main.async {
                self?.activityIndicator.stopAnimating()
                self?.imageView.image = image
            }
        }.resume()
    }
    
    // MARK: - Actions
    @objc private func didTapBackground() {
        dismiss(animated: true)
    }
    
    @objc private func didTapClose() {
        dismiss(animated: true)
    }
    
    @objc private func didDoubleTap(_ gesture: UITapGestureRecognizer) {
        if scrollView.zoomScale > 1.0 {
            scrollView.setZoomScale(1.0, animated: true)
        } else {
            let point = gesture.location(in: imageView)
            let zoomRect = CGRect(
                x: point.x - 50,
                y: point.y - 50,
                width: 100,
                height: 100
            )
            scrollView.zoom(to: zoomRect, animated: true)
        }
    }
}

// MARK: - UIScrollViewDelegate
extension ImageViewerViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}
