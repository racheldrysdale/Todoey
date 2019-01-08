//
//  Category.swift
//  Todoey
//
//  Created by Rachel Drysdale on 07/01/2019.
//  Copyright © 2019 Rachel Drysdale. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
	@objc dynamic var name: String = ""
	let items = List<Item>()
}
