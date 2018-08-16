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

    private lazy var manager = verticalManager
    
    private var horizontalManager: SideViewManager {
        let originY = UIApplication.shared.statusBarFrame.height + 4
        let sideWidth: CGFloat = 300
        let sideHeight = sideController.view.frame.height - originY * 2
        let startingFrame = CGRect(x: view.frame.width, y: originY, width: sideWidth, height: sideHeight)
        let endingFrame = CGRect(x: view.frame.width - sideWidth, y: originY, width: sideWidth, height: sideHeight)
        
        let manager = SideViewManager(controller: sideController, startingFrame: startingFrame, endingFrame: endingFrame)
        manager.swipeDirection = .horizontal
        
        return manager
    }
    
    private var verticalManager: SideViewManager {
        let sideHeight = view.frame.height
        let startingFrame = CGRect(x: 0, y: sideHeight, width: view.frame.width, height: sideHeight)
        let endingFrame = CGRect(x: 0, y: 0, width: view.frame.width, height: sideHeight)
        
        let manager = SideViewManager(controller: sideController, startingFrame: startingFrame, endingFrame: endingFrame)
        manager.swipeDirection = .vertical
        return manager
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        manager.setSwipeGesture(isEnabled: true)
        manager.setDismissGesture(isEnabled: true)
    }
}

