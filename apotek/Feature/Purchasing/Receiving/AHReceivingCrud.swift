//
//  AHReceivingCrud.swift
//  apotek
//
//  Created by Annisa Sofia Noviantina on 17/01/20.
//  Copyright © 2020 Hexa. All rights reserved.
//

import UIKit
import RealmSwift

func getAllReceivings() -> [AHReceiving] {
    let realm = try! Realm()
    let listed = realm.objects(AHReceiving.self).filter("rec_status = 1")
    var list = [AHReceiving]()
    for item in listed {
        list.append(item)
    }
    return list
}

func saveReceiving(receiving: AHReceiving) {
    let realm = try! Realm()
    try! realm.write {
        realm.add(receiving)
    }
}

func editReceiving(receiving: AHReceiving, newReceiving: AHReceiving) {
    let realm = try! Realm()
    try! realm.write {
    
        if receiving.isInvalidated == false {
            receiving.rec_no = newReceiving.rec_no
            receiving.rec_date = newReceiving.rec_date
            receiving.rec_po = newReceiving.rec_po
            receiving.rec_prd_list.removeAll()
            
            for item in newReceiving.rec_prd_list{
                receiving.rec_prd_list.append(item)
            }
        }
    }

}

func deleteReceiving(receiving: AHReceiving) {
    let realm = try! Realm()
    try! realm.write {
         if receiving.isInvalidated == false {
            receiving.rec_status = 0
        }
    }
}

