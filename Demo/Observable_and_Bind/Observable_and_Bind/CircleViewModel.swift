//
//  CircleViewModel.swift
//  Observable_and_Bind
//
//  Created by jiangbo on 2019/11/12.
//  Copyright © 2019 ManlyCamera. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class CircleViewModel {
    var centerVariable = Variable<CGPoint?> // Create one variable that will be changed and observed
    var backgroundColorObservable: Observable! // Create observable that will change backgroundColor based on center
    
    init() {
        setup()
    }
    
    setup() {
    }
}
