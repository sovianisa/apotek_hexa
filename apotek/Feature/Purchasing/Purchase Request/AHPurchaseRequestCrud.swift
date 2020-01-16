//
//  AHPurchaseRequestCrud.swift
//  apotek
//
//  Created by Annisa Sofia Noviantina on 20/12/19.
//  Copyright © 2019 Hexa. All rights reserved.
//

import UIKit
import RealmSwift

func getAllPurchaseRequests() -> [AHPurchaseRequest] {
    let realm = try! Realm()
    let listed = realm.objects(AHPurchaseRequest.self).filter("pr_status = 1")
    var list = [AHPurchaseRequest]()
    for item in listed {
        list.append(item)
    }
    return list
}

func savePurchaseRequest(purchaseRequest: AHPurchaseRequest) {
    let realm = try! Realm()
    try! realm.write {
        realm.add(purchaseRequest)
    }
}

func editPurchaseRequest(purchaseRequest: AHPurchaseRequest, newPurchaseRequest: AHPurchaseRequest) {
    let realm = try! Realm()
    try! realm.write {
        if purchaseRequest.isInvalidated == false {
            purchaseRequest.pr_no = newPurchaseRequest.pr_no
            purchaseRequest.pr_create_by = newPurchaseRequest.pr_create_by
            purchaseRequest.pr_created_date = newPurchaseRequest.pr_created_date
            purchaseRequest.pr_notes = newPurchaseRequest.pr_notes
            purchaseRequest.pr_prd_list.removeAll()
            
            for item in newPurchaseRequest.pr_prd_list {
                purchaseRequest.pr_prd_list.append(item)
            }
        }
    }

}

func deletepurchaseRequest(purchaseRequest: AHPurchaseRequest) {
    let realm = try! Realm()
    try! realm.write {
        if purchaseRequest.isInvalidated == false {
            purchaseRequest.pr_status = 0
        }
    }
}
