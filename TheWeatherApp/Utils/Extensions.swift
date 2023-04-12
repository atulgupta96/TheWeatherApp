//
//  Extensions.swift
//  TheWeatherApp
//
//  Created by Atul Gupta on 08/04/23.
//

import Foundation
import UIKit

extension UIViewController {
    //Show activity indicator
    func showActivityIndicator(_ backgroundColor: UIColor = .black.withAlphaComponent(0.5)) {
        DispatchQueue.main.async {
            let container = UIView(frame: self.view.frame)
            container.backgroundColor = backgroundColor
            container.tag = 10001
            let activityIndicator = UIActivityIndicatorView(style: .medium)
            activityIndicator.color = .white
            activityIndicator.center = container.center
            container.addSubview(activityIndicator)
            self.view.addSubview(container)
            activityIndicator.startAnimating()
            self.view.isUserInteractionEnabled = false
        }
    }
    
    //Remove activity indicator
    func removeActivityIndicator() {
        DispatchQueue.main.async {
            self.view.isUserInteractionEnabled = true
            let activityIndicator = self.view.viewWithTag(10001)
            activityIndicator?.removeFromSuperview()
        }
    }
    
    //Show alert
    func alert(_ title: String, _ message: String? = nil, _ action: String = "Okay", _ onClick: ((UIAlertAction) -> Void)? = nil) {
        let controller = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: action, style: .default, handler: onClick)
        controller.addAction(defaultAction)
        present(controller, animated: true, completion: nil)
    }
}

extension String {
    var trim: String {
        self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}

extension UICollectionView {
    
    func registerCell(type: UICollectionViewCell.Type, identifier: String? = nil) {
        let cellId = String(describing: type)
        register(UINib(nibName: cellId, bundle: nil), forCellWithReuseIdentifier: identifier ?? cellId)
    }
    
    func dequeueCell<T: UICollectionViewCell>(withType type: UICollectionViewCell.Type, for indexPath: IndexPath) -> T? {
        return dequeueReusableCell(withReuseIdentifier: type.identifier, for: indexPath) as? T
    }
}

extension UIView {
    static var identifier: String {
        return String(describing: self)
    }
}
