//
//  ProductDetailViewController.swift
//  iOSTraining
//
//  Created by Shane Gamboa - INTERN on 2/25/26.
//

import UIKit

class ProductDetailViewController: UIViewController {

    var product: Product?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = product?.name
    }
    
//    private let scrollView: UIScrollView = {
//        let sv = UIScrollView()
//        sv.backgroundColor = .systemRed
//        return sv
//    }()
//    
//    private let contentView: UIView = {
//        let v = UIView()
//        v.backgroundColor = .systemPurple
//        return v
//    }()
//    
//    private func setupUI(){
//        self.view.backgroundColor = .systemBlue
//        
//        self.view.addSubview(scrollView)
//        scrollView.translatesAutoresizingMaskIntoConstraints = false
//        
//        self.scrollView.addSubview(contentView)
//        contentView.translatesAutoresizingMaskIntoConstraints = false
//        
//        NSLayoutConstraint.activate([
//            scrollView.topAnchor.constraint(equalTo: self.view.topAnchor),
//            scrollView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
//            scrollView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
//            scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
//            
//            contentView.topAnchor.constraint(equalTo: self.scrollView.topAnchor),
//            contentView.leadingAnchor.constraint(equalTo: self.scrollView.leadingAnchor),
//            contentView.trailingAnchor.constraint(equalTo: self.scrollView.trailingAnchor),
//            contentView.bottomAnchor.constraint(equalTo: self.scrollView.bottomAnchor),
//            
//            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
//            contentView.heightAnchor.constraint(equalTo: scrollView.heightAnchor, multiplier: 2),
//        ])
//    }
}
