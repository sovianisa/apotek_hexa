//
//  AHClassOfDrugCrud.swift
//  apotek
//
//  Created by Annisa Sofia Noviantina on 19/12/19.
//  Copyright © 2019 Hexa. All rights reserved.
//

import UIKit
import RealmSwift

func getAllClassOfDrugs() -> [AHClassOfDrug] {
    let realm = try! Realm()
    let listed = realm.objects(AHClassOfDrug.self).filter("cod_status = 1")
    var list = [AHClassOfDrug]()
    for item in listed {
        list.append(item)
    }
    return list
}

func saveClassOfDrug(drug: AHClassOfDrug) {
    let realm = try! Realm()
    try! realm.write {
        realm.add(drug)
    }
}

func editClassOfDrug(drug: AHClassOfDrug, newDrug: AHClassOfDrug) {
    let realm = try! Realm()
    try! realm.write {
        if drug.isInvalidated == false {
            drug.cod_name = newDrug.cod_name
            drug.cod_information = newDrug.cod_information
        }
    }

}

func deleteClassOfDrug(drug: AHClassOfDrug) {
    let realm = try! Realm()
    try! realm.write {
        if drug.isInvalidated == false {
            drug.cod_status = 0
        }
    }
}
