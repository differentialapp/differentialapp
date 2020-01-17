//
//  Factor.swift
//  diagSwiftRealm
//
//  Created by Brian Clow on 1/11/20.
//  Copyright © 2020 Brian Clow. All rights reserved.
//

import Foundation
import RealmSwift

class Factor: Object {
    
    @objc dynamic var name: String?
    @objc dynamic var chiefComplaint1: String?
    @objc dynamic var chiefComplaint2: String?
    @objc dynamic var chiefComplaint3: String?
    @objc dynamic var diagnosis: String?
    @objc dynamic var posLR: Double = 10.0
    @objc dynamic var negLR: Double = 1.0
    @objc dynamic var source: String?
    
}
