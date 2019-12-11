//
//  Bundle.swift
//  Box-Office-Movies-Core
//
//  Created by Bilal on 10/12/2019.
//  Copyright © 2019 Boxotop. All rights reserved.
//

import Foundation

extension Bundle {

    static var core: Bundle {
        return Bundle(for: ManagerProvider.self)
    }
}
