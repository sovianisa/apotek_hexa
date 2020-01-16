//
//  AHFactoryCrud.swift
//  apotek
//
//  Created by Annisa Sofia Noviantina on 19/12/19.
//  Copyright © 2019 Hexa. All rights reserved.
//

import UIKit
import RealmSwift

func getAllFactories() -> [AHFactory] {
    let realm = try! Realm()
    let listed = realm.objects(AHFactory.self).filter("fct_status = 1")
    var list = [AHFactory]()
    for item in listed {
        list.append(item)
    }
    return list
}

func saveFactory(factory: AHFactory) {
    let realm = try! Realm()
    try! realm.write {
        realm.add(factory)
    }
}

func editFactory(factory: AHFactory, newFactory: AHFactory) {
    let realm = try! Realm()
    try! realm.write {
        if factory.isInvalidated == false {
            factory.fct_name = newFactory.fct_name
            factory.fct_city = newFactory.fct_city
            factory.fct_address = newFactory.fct_address
            factory.fct_phone = newFactory.fct_phone

        }
    }

}

func deleteFactory(factory: AHFactory) {
    let realm = try! Realm()
    try! realm.write {
        if factory.isInvalidated == false {
            factory.fct_status = 0
        }
    }
}


