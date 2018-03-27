//
//  ViewController.swift
//  SideViewManager
//
//  Created by AndrewBoryk on 03/22/2018.
//  Copyright (c) 2018 AndrewBoryk. All rights reserved.
//

import UIKit
import SideViewManager

class ViewController: UIViewController {
    
    private let sideController: UIViewController = {
        let controller = UIViewController()
        controller.view.backgroundColor = .lightGray
        return controller
    }()

    private lazy var manager = SideViewManager(sideController: sideController)
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let originY = UIApplication.shared.statusBarFrame.height + 4
        let sideWidth: CGFloat = 300
        let sideHeight = sideController.view.frame.height - originY * 2
        let offScreenFrame = CGRect(x: view.frame.width, y: originY, width: sideWidth, height: sideHeight)
        let onScreenFrame = CGRect(x: view.frame.width - sideWidth, y: originY, width: sideWidth, height: sideHeight)
        
        manager = SideViewManager(sideController: sideController, onScreenFrame: onScreenFrame, offScreenFrame: offScreenFrame)
        
//        manager.swipeDirection = .vertical
        
//        let sideHeight = view.frame.height
//        manager.offScreenFrame = CGRect(x: 0, y: sideHeight, width: view.frame.width, height: sideHeight)
//
        manager.setSwipeGesture(isEnabled: true)
        manager.setDismissGesture(isEnabled: true)
    }
}

