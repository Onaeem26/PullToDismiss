//
//  ViewController.swift
//  PullToReach
//
//  Created by Osama Naeem on 26/02/2019.
//  Copyright © 2019 NexThings. All rights reserved.
//

import UIKit

class ViewController: UIViewController, ActionMenuDelegate {

    //MARK: - PROPERTIES
    lazy var actionMenu : ActionMenu = {
        let menu = ActionMenu()
        menu.delegate = self
        return menu
    }()
    
    
    //MARK: - INIT
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        title = "Pull To Reach"
        view.backgroundColor = .white
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Actions", style: .done, target: self, action: #selector(handleActionButton))
    }
    
    
    
    //MARK: - CONFIGURATIONS
    @objc func handleActionButton() {
        actionMenu.configureActionMenu()
        actionMenu.showActionMenu() // A strong reference is required for the actionMenu so that the target is not lost
    }
    
    func changeViewControllerBackgroundColor(toggle: Bool) {
        toggle ? (view.backgroundColor = .red) : (view.backgroundColor = .white)
    }

}

