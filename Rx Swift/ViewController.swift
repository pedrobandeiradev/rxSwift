//
//  ViewController.swift
//  Rx Swift
//
//  Created by Superdigital on 25/03/19.
//  Copyright © 2019 Superdigital. All rights reserved.
//

import UIKit
import RxSwift

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        _ = Observable.of("Hello RxSwift!")
    }


}

