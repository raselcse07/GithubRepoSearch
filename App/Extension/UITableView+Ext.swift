//
//  UITableView+Ext.swift
//  GithubRepoSearch
//
//  Created by Rasel on 2021/08/01.
//

import UIKit

extension UITableView {
    
    private var activityIndicator: UIActivityIndicatorView {
        return prepareLoadingIndicator()
    }
    
    public func register<Cell: UITableViewCell>(_ cell: Cell.Type) {
        
        let identifier = String(describing: cell)
        
        if Bundle.main.path(forResource: identifier, ofType: "nib") != nil {
            register(UINib(nibName: identifier, bundle: nil), forCellReuseIdentifier: identifier)
        } else {
            register(cell, forCellReuseIdentifier: identifier)
        }
    }
    
    public func dequeueReusableCell<Cell: UITableViewCell>(with cellType: Cell.Type, for indexPath: IndexPath) -> Cell {
        
        return dequeueReusableCell(withIdentifier: String(describing: cellType), for: indexPath) as! Cell
    }
    
    public func dequeueReusableCell<Cell: UITableViewCell>(with cellType: Cell.Type) -> Cell {
        
        return dequeueReusableCell(withIdentifier: String(describing: cellType)) as! Cell
    }
    
    public func waiting(_ indexPath: IndexPath, completion: @escaping CallBack) {
        activityIndicator.startAnimating()
        if let lastVisibleIndexPath = indexPathsForVisibleRows?.last {
            if indexPath == lastVisibleIndexPath && indexPath.row == numberOfRows(inSection: 0) - 1 {
                DispatchQueue.runOnMain(delay: .milliseconds(3000), completion)
            }
        }
    }
    
    public func finishLoading() {
        if tableFooterView != nil {
            activityIndicator.stopAnimating()
            tableFooterView = nil
        }
        else {
            tableFooterView = nil
        }
    }
    
    private func prepareLoadingIndicator() -> UIActivityIndicatorView {
        
        var activityIndicatorView = UIActivityIndicatorView()
        
        if tableFooterView == nil {
            
            let indicatorFrame = CGRect(x: 0, y: 0, width: self.bounds.width, height: 80)
            activityIndicatorView = UIActivityIndicatorView(frame: indicatorFrame)
            activityIndicatorView.autoresizingMask = [.flexibleLeftMargin, .flexibleRightMargin]
            
            if #available(iOS 13.0, *) {
                activityIndicatorView.style = .large
            } else {
                // Fallback on earlier versions
                activityIndicatorView.style = .whiteLarge
            }
            activityIndicatorView.hidesWhenStopped = true
            activityIndicatorView.backgroundColor = .lightText
            tableFooterView = activityIndicatorView
        
            return activityIndicatorView
        }
        else {
            return activityIndicatorView
        }
    }
}
