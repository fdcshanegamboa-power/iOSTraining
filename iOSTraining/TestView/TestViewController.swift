//
//  TestViewController.swift
//  iOSTraining
//
//  Created by Shane Gamboa - INTERN on 2/26/26.
//

import UIKit

class TestViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    private let identifier = "TestCollectionViewCell"
    private let sectionIdentifier = "Section1CollectionViewCell"
    
    private var photos: [String] = [
        "laptopstand", "mechanicalkeyboard", "usbchub", "wirelessmouse",
        "phonecase", "wirelessheadphones", "smartwatch", "smartwatch",
        "smartwatch", "smartwatch", "smartwatch", "smartwatch",
        "smartwatch", "smartwatch", "smartwatch", "smartwatch"
    ]
    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: identifier, bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: identifier)
        
        self.title = "Please help me!"
        
        let nib2 = UINib(nibName: sectionIdentifier, bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: identifier)
        collectionView.register(nib2, forCellWithReuseIdentifier: sectionIdentifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        // Do any additional setup after loading the view.
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension TestViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if section == 0 {
            return 6
        }
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as? TestCollectionViewCell {
                cell.imageName = photos[indexPath.row]
                return cell
            }
        default:
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: sectionIdentifier, for: indexPath) as? Section1CollectionViewCell {
                return cell
            }
        }
        
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let columns: CGFloat = 3
        let spacing: CGFloat = 10
        let insets: CGFloat = 10 * 2
        
        let totalInterItemSpacing = spacing * (columns - 1)
        let availableWidth = collectionView.bounds.width - insets - totalInterItemSpacing
        let itemWidth = floor(availableWidth / columns)
        
        return CGSize(width: itemWidth, height: itemWidth)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let alert = UIAlertController(
            title: "WooShoo!",
            message: "You tapped on \(photos[indexPath.row])",
            preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default){ _ in
        }
        alert.addAction(okAction)
        self.present(alert, animated: true)
    }
}
