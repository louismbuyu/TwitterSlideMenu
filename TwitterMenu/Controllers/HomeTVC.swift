//
//  HomeTVC.swift
//  TwitterMenu
//
//  Created by Louis Nelson Levoride on 10.10.19.
//  Copyright © 2019 LouisNelson. All rights reserved.
//

import UIKit

class HomeTVC: UITableViewController {
    
    var menuTVC = MenuTVC()
    fileprivate let menuWidth:CGFloat = 300
    fileprivate var isMenuOpen = false
    fileprivate let velocityThreshold: CGFloat = 500
    fileprivate let darkCover = UIView()
    
    fileprivate func setupPanGesture() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        self.view.addGestureRecognizer(panGesture)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        
        navigationItem.title = "Home"
        self.navigationController?.view.backgroundColor = .white
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Open", style: .plain, target: self, action: #selector(handleOpen))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Hide", style: .plain, target: self, action: #selector(handleHide))
        
        setupMenuController()
        setupPanGesture()
        setupDarkCoverView()
    }
    
    fileprivate func setupDarkCoverView() {
        darkCover.alpha = 0
        darkCover.backgroundColor = UIColor(white: 0, alpha: 0.8)
        darkCover.isUserInteractionEnabled = false
        
        let menuView = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
        menuView?.addSubview(darkCover)
        darkCover.frame = menuView?.frame ?? .zero
    }
    
    @objc func handlePan(gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: self.view)
        
        if gesture.state == .changed {
            var x = translation.x
            
            if isMenuOpen {
                x += menuWidth
            }
            
            x = min(menuWidth, x)
            x = max(0, x)
            
            let tranform = CGAffineTransform(translationX: x, y: 0)
            
            self.menuTVC.view.transform = tranform
            self.navigationController?.view.transform = tranform
            self.darkCover.transform = tranform
            self.darkCover.alpha = x / menuWidth
        } else if gesture.state == .ended {
            handlePanGestureEnded(gesturePosition: translation.x, gestureVelcoity: gesture.velocity(in: self.view).x)
        }
    }
    
    fileprivate func handlePanGestureEnded(gesturePosition: CGFloat, gestureVelcoity: CGFloat) {
        
        if isMenuOpen {
            
            if abs(gestureVelcoity) > velocityThreshold {
                handleHide()
                return
            }
            
            if abs(gesturePosition) < menuWidth / 2 {
                handleOpen()
            } else {
                handleHide()
            }
            
        } else {
            if gesturePosition > velocityThreshold {
                handleOpen()
            }
            
            if gesturePosition < menuWidth / 2 {
                handleHide()
            } else {
                handleOpen()
            }
        }
        
    }
    
    fileprivate func setupMenuController() {
        menuTVC.view.frame = CGRect(x: -menuWidth, y: 0, width: menuWidth, height: self.view.frame.height)
        
        let applicationView = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
        
        applicationView?.addSubview(menuTVC.view)
        
        self.addChild(menuTVC)
    }
    
    @objc func handleOpen() {
        isMenuOpen = true
        performAnimation(transform: CGAffineTransform(translationX: self.menuWidth, y: 0))
    }
    
    
    @objc func handleHide() {
        isMenuOpen = false
        performAnimation(transform: .identity)
    }
    
    
    fileprivate func performAnimation(transform: CGAffineTransform) {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.menuTVC.view.transform = transform
            self.navigationController?.view.transform = transform
            self.darkCover.transform = transform
            self.darkCover.alpha = transform == .identity ? 0 : 1
        })
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        cell.textLabel?.text = "Louis \(indexPath.row)"
        cell.detailTextLabel?.text = "Mbuyu"
        return cell
    }
    
}
