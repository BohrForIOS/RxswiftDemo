//
//  ViewController.swift
//  Observable_and_Bind
//
//  Created by jiangbo on 2019/11/12.
//  Copyright © 2019 ManlyCamera. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift


class ViewController: UIViewController {
 var circleView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
         setup()
    }

    func setup() {
        // Add circle view
        circleView = UIView(frame: CGRect(origin: view.center, size: CGSize(width: 100.0, height: 100.0)))
        circleView.layer.cornerRadius = circleView.frame.width / 2.0
        circleView.center = view.center
        circleView.backgroundColor = .green
        view.addSubview(circleView)
        
        // Add gesture recognizer
        let gestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(circleMoved(_:)))
        circleView.addGestureRecognizer(gestureRecognizer)
    }
    
   @objc func circleMoved(_ recognizer: UIPanGestureRecognizer) {
        let location = recognizer.location(in: view)
    UIView.animate(withDuration: 0.1) {
            self.circleView.center = location
        }
    }
}

