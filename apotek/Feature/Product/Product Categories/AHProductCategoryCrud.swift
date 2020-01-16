//
//  AHProductCategoryCrud.swift
//  apotek
//
//  Created by Annisa Sofia Noviantina on 19/12/19.
//  Copyright © 2019 Hexa. All rights reserved.
//

import UIKit
import RealmSwift

func getAllProductCategories() -> [AHProductCategory] {
    let realm = try! Realm()
    let listed = realm.objects(AHProductCategory.self).filter("pc_status = 1")
    var list = [AHProductCategory]()
    for item in listed {
        list.append(item)
    }
    return list
}

func saveProductCategory(category: AHProductCategory) {
    let realm = try! Realm()
    try! realm.write {
        realm.add(category)
    }
}

func editProductCategory(category: AHProductCategory, newCategory: AHProductCategory) {
    let realm = try! Realm()
    try! realm.write {
        if category.isInvalidated == false {
            category.pc_name = newCategory.pc_name
            category.pc_information = newCategory.pc_information
        }
    }

}

func deletecategory(category: AHProductCategory) {
    let realm = try! Realm()
    try! realm.write {
        if category.isInvalidated == false {
            category.pc_status = 0
        }
    }
}
