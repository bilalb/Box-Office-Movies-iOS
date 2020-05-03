//
//  Bundle.swift
//  Box-Office-Movies-Core
//
//  Created by Bilal Benlarbi on 10/12/2019.
//  Copyright © 2019 Bilal Benlarbi. All rights reserved.
//

import Foundation

extension Bundle {

    static var core: Bundle {
        return Bundle(for: ManagerProvider.self)
    }
}
