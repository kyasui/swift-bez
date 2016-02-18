//
//  BezProject.swift
//  Bez
//
//  Created by Kei Yasui on 2/15/16.
//  Copyright © 2016 Kei Yasui. All rights reserved.
//

import Foundation
import UIKit

struct BezProject {
    var name: String
    var savedImage: UIImage
    
    init(name: String, savedImage: UIImage) {
        self.name = name
        self.savedImage = savedImage
    }
}
