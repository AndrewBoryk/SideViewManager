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
        
        manager.offScreenFrame = CGRect(x: view.frame.width, y: originY, width: sideWidth, height: sideHeight)
        manager.onScreenFrame = CGRect(x: view.frame.width - sideWidth, y: originY, width: sideWidth, height: sideHeight)
        
        manager.setSwipeGesture(isEnabled: true)
        manager.setDismissGesture(isEnabled: true)
    }
}

