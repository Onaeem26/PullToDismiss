//
//  ActionMenu.swift
//  PullToReach
//
//  Created by Osama Naeem on 26/02/2019.
//  Copyright © 2019 NexThings. All rights reserved.
//

import UIKit
protocol ActionMenuDelegate {
    func changeViewControllerBackgroundColor(toggle: Bool)
}

class ActionMenu: NSObject, UIScrollViewDelegate {
    
    // MARK: - PROPERTIES
    let blackView : UIView = {
        let view = UIView()
        view.backgroundColor = .black
        return view
    }()
    let actionView : UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        return view
    }()
    
    lazy var cancelButton : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("✕", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        button.backgroundColor = .white
        button.setTitleColor(.gray, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleCancelButton), for: .touchUpInside)
        button.layer.cornerRadius = 15
        button.clipsToBounds = true
        return button
    }()
    
    lazy var cancelButtonForeground : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("✕", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        button.backgroundColor = .red
        button.setTitleColor(.white, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleCancelButton), for: .touchUpInside)
        button.layer.cornerRadius = 15
        button.clipsToBounds = true
        return button
    }()
    
    let maskLayer = CAShapeLayer()
    
    lazy var menuScrollView : UIScrollView = {
       let scrollview = UIScrollView()
        scrollview.backgroundColor = .white
        scrollview.delegate = self
        scrollview.translatesAutoresizingMaskIntoConstraints = false
       return scrollview
    }()
     let height : CGFloat = 350
     let padding : CGFloat = 40
    
    var delegate : ActionMenuDelegate?
    var toggle : Bool = false
    // MARK: - INIT
    override init() {
        super.init()
        
    }
    
    // MARK: - CONFIGURATION
    func configureActionMenu() {
        
        guard let window = UIApplication.shared.keyWindow else { return }
        blackView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleDismissGesture))
        blackView.addGestureRecognizer(tapGesture)
        window.addSubview(blackView)
        window.addSubview(actionView)
        
        actionView.addSubview(cancelButton)
        cancelButton.rightAnchor.constraint(equalTo: actionView.rightAnchor, constant: -8).isActive = true
        cancelButton.topAnchor.constraint(equalTo: actionView.topAnchor, constant: 10).isActive = true
        cancelButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        cancelButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        
        actionView.addSubview(cancelButtonForeground)
        cancelButtonForeground.rightAnchor.constraint(equalTo: cancelButton.rightAnchor).isActive = true
        cancelButtonForeground.topAnchor.constraint(equalTo: cancelButton.topAnchor).isActive = true
        cancelButtonForeground.leftAnchor.constraint(equalTo: cancelButton.leftAnchor ).isActive = true
        cancelButtonForeground.bottomAnchor.constraint(equalTo: cancelButton.bottomAnchor).isActive = true
        
        actionView.addSubview(menuScrollView)
        menuScrollView.contentSize = CGSize(width: actionView.frame.width, height: 450)
        menuScrollView.rightAnchor.constraint(equalTo: actionView.rightAnchor).isActive = true
        menuScrollView.leftAnchor.constraint(equalTo: actionView.leftAnchor).isActive = true
        menuScrollView.topAnchor.constraint(equalTo: actionView.topAnchor, constant: 50).isActive = true
        menuScrollView.bottomAnchor.constraint(equalTo: actionView.bottomAnchor).isActive = true
        
       
        cancelButtonForeground.layer.mask = maskLayer
        cancelButtonForeground.layer.masksToBounds = true
    }
    func showActionMenu() {
        
        guard let window = UIApplication.shared.keyWindow else { return }
        
        blackView.frame = window.frame
        blackView.alpha = 0
        let yValue = window.frame.height - (height + height / 2)
        let width = window.frame.width - (padding * 2)
        
        actionView.frame = CGRect(x: padding, y: window.frame.height, width: width, height: height)
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut, animations:{
            self.blackView.alpha = 1
            self.actionView.frame = CGRect(x: self.padding, y: yValue, width: width, height: self.height)
        })
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let goal : CGFloat = 80
        let contentOffset =  scrollView.contentOffset.y
        let progress = -contentOffset / goal
        let finalProgress = max(0, min(1, progress))
        updateActionMenu(progress: finalProgress)
    }
    
    func updateActionMenu(progress: CGFloat) {
        let newgoal : CGFloat = 0.75
        let newprogress = progress / newgoal
        let finalProgress = max(0, min(1, newprogress))
        let height = cancelButtonForeground.frame.height * finalProgress
        let buttonrect = CGRect(x: 0, y: cancelButtonForeground.frame.height, width: cancelButtonForeground.frame.width, height: -height)
        print(buttonrect)
        let mask = UIBezierPath(rect: buttonrect)
        maskLayer.path = mask.cgPath
       
        switch progress {
        case _ where progress >= 0.75 && progress < 1:
            let goalScale : CGFloat = 1.3
            let newProgress = (progress - 0.75) / 0.25
            let scaling = 1 + (goalScale - 1) * newProgress
            cancelButtonForeground.transform = CGAffineTransform(scaleX: scaling, y: scaling)
        case ...0.75:
            cancelButtonForeground.transform = CGAffineTransform.identity
        case 1:
            handleDismissGesture()
        default:
            break
        }
    }

    @objc func handleDismissGesture() {
        guard let window = UIApplication.shared.keyWindow else { return }
        let width = window.frame.width - (padding * 2)
    
        UIView.animate(withDuration: 0.3) {
            self.blackView.alpha = 0
            self.actionView.frame = CGRect(x: self.padding, y: window.frame.height, width: width, height: self.height)
        }
    }
    
    @objc func handleCancelButton() {
        toggle = !toggle
        guard let window = UIApplication.shared.keyWindow else { return }
        let width = window.frame.width - (padding * 2)
        
        UIView.animate(withDuration: 0.3, animations: {
            self.blackView.alpha = 0
            self.actionView.frame = CGRect(x: self.padding, y: window.frame.height, width: width, height: self.height)
        }) { (success) in
            self.delegate?.changeViewControllerBackgroundColor(toggle: self.toggle)
        }
    }
    
    
}



