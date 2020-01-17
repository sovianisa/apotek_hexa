//
//  AHPurchaseOrderCrud.swift
//  apotek
//
//  Created by Annisa Sofia Noviantina on 17/01/20.
//  Copyright © 2020 Hexa. All rights reserved.
//

import UIKit
import RealmSwift

func getAllPurchaseOrders() -> [AHPurchaseOrder] {
    let realm = try! Realm()
    let listed = realm.objects(AHPurchaseOrder.self).filter("po_status = 1")
    var list = [AHPurchaseOrder]()
    for item in listed {
        list.append(item)
    }
    return list
}

func savePurchaseOrder(purchaseOrder: AHPurchaseOrder) {
    let realm = try! Realm()
    try! realm.write {
        realm.add(purchaseOrder)
    }
}

func editPurchaseOrder(purchaseOrder: AHPurchaseOrder, newPurchaseOrder: AHPurchaseOrder) {
    let realm = try! Realm()
    try! realm.write {
        
        if purchaseOrder.isInvalidated == false {
            purchaseOrder.po_no = newPurchaseOrder.po_no
            purchaseOrder.po_order_date  = newPurchaseOrder.po_order_date
            purchaseOrder.po_pr  = newPurchaseOrder.po_pr
            purchaseOrder.po_sup = newPurchaseOrder.po_sup
            purchaseOrder.po_prd_list.removeAll()
            
            for item in newPurchaseOrder.po_prd_list{
                purchaseOrder.po_prd_list.append(item)
            }
        }
    }

}

func deletepurchaseOrder(purchaseOrder: AHPurchaseOrder) {
    let realm = try! Realm()
    try! realm.write {
        if purchaseOrder.isInvalidated == false {
            purchaseOrder.po_status = 0
        }
    }
}
