//
//  Session.swift
//  loginForm
//
//  Created by prot on 17.03.2020.
//  Copyright © 2020 prot. All rights reserved.
//

import UIKit

class Session {
    private init() {}
    static let shared: Session = .init()
    var token: String = "813c1c16e28b5c1ee4876f3b65e8260a8626dbd18a6f5d06faa9db78225b90b00594512ad33a92c3bf0a0"
    var userId: Int?
}
