//
//  AHDashboardMenuViewController.swift
//  apotek
//
//  Created by Annisa Sofia Noviantina on 18/12/19.
//  Copyright © 2019 Hexa. All rights reserved.
//

import UIKit

class AHDashboardMenuViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var collectionView: UICollectionView!


    let menuHeaders = ["Product", "Drugs", "Purchasing", "Sales", "Stock"]

    let menuProducts = ["Product \nCategories", "Factories", "Product", "Product \nUnits", "Product Units \nPrice"]
    let menuProductImages = ["menu-categories", "menu-factories", "menu-products", "menu-product-units", "menu-unit-price"]

    let menuDrugs = ["Class of Drugs", "Personalize \nMedicine", "Convertion \nHistory"]
    let menuDrugImages = ["menu-class-of-drug", "menu-personalized", "menu-convertion"]

    let menuPurchasing = ["Purchase \nRequest", "Purchase \nOrder", "Receiving", "Supplier"]
    let menuPurchasingImages = ["menu-purchase-order", "menu-purchase", "menu-receiving", "menu-supplier"]

    let menuStock = ["Stock \nUnit", "Shops"]
    let menuStockImages = ["menu-stock-unit", "menu-shops"]

    let menuSales = ["Transaction"]
    let menuSaleImages = ["menu-transaction"]

    let sectionInsets = UIEdgeInsets(top: 50.0, left: 40.0, bottom: 50.0, right: 40.0)
    let itemsPerRow: CGFloat = 4


    override func viewDidLoad() {
        super.viewDidLoad()
        settingUp()
    }

    func settingUp() {
        self.title = "Apotek Hexa"
        collectionView.backgroundColor = #colorLiteral(red: 0.7540688515, green: 0.7540867925, blue: 0.7540771365, alpha: 0.933005137)
        collectionView.reloadData()
    }

    // MARK: - Collection View Data source
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return menuHeaders.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return menuProducts.count
        } else if section == 1 {
            return menuDrugs.count
        } else if section == 2 {
            return menuPurchasing.count
        } else if section == 3 {
            return menuSales.count
        } else {
            return menuStock.count
        }
    }


    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AHMenuCollectionViewCell",
            for: indexPath) as! AHMenuCollectionViewCell

        var title = ""
        var imageName = ""

        if indexPath.section == 0 {
            title = menuProducts[indexPath.row]
            imageName = menuProductImages[indexPath.row]
        } else if indexPath.section == 1 {
            title = menuDrugs[indexPath.row]
            imageName = menuDrugImages[indexPath.row]
        } else if indexPath.section == 2 {
            title = menuPurchasing[indexPath.row]
            imageName = menuPurchasingImages[indexPath.row]
        } else if indexPath.section == 3 {
            title = menuSales[indexPath.row]
            imageName = menuSaleImages[indexPath.row]
        } else {
            title = menuStock[indexPath.row]
            imageName = menuStockImages[indexPath.row]
        }

        cell.setCell(image: UIImage(named: imageName) ?? UIImage(), title: title)

        return cell
    }



    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 80.0)
    }


    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        print("ava check :\(indexPath.section), \(indexPath.row)")
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                goToProductCategoriesPage()
            } else if indexPath.row == 1 {
                goToFactoryPage()
            } else if indexPath.row == 2 {
                goToProductPage()
            } else if indexPath.row == 3 {
                goToProductUnit()
            } else if indexPath.row == 4 {
                goToProductUnitPrice()
            }
        } else if indexPath.section == 1 {
            if indexPath.row == 0 {
                goToClassOfDrugPage()
            }
        } else if indexPath.section == 2 {
            if indexPath.row == 0 {
                goToPurchaseRequestPage()
            } else if indexPath.row == 3 {
                goToSupplierPage()
            }
        } else if indexPath.section == 4 {
            if indexPath.row == 1 {
                goToShopPage()
            }
        }
    }

    func goToFactoryPage() {
        let storyboard = UIStoryboard(name: "AHFactory", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "AHFactoryListViewController") as! AHFactoryListViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }

    func goToProductCategoriesPage() {
        let storyboard = UIStoryboard(name: "AHProductCategory", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "AHProductCategoryListViewController") as! AHProductCategoryListViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }

    func goToClassOfDrugPage() {
        let storyboard = UIStoryboard(name: "AHClassOfDrug", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "AHClassOfDrugListViewController") as! AHClassOfDrugListViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }

    func goToSupplierPage() {
        let storyboard = UIStoryboard(name: "AHSupplier", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "AHSupplierListViewController") as! AHSupplierListViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }

    func goToShopPage() {
        let storyboard = UIStoryboard(name: "AHShop", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "AHShopListViewController") as! AHShopListViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }

    func goToProductPage() {
        let storyboard = UIStoryboard(name: "AHProduct", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "AHProductListViewController") as! AHProductListViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }

    func goToPurchaseRequestPage() {
        let storyboard = UIStoryboard(name: "AHPurchaseRequest", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "AHPurchaseRequestListViewController") as! AHPurchaseRequestListViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }

    func goToProductUnit() {
        let storyboard = UIStoryboard(name: "AHProductUnit", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "AHProductUnitListViewController") as! AHProductUnitListViewController
        self.navigationController?.pushViewController(vc, animated: true)

    }

    func goToProductUnitPrice() {
        let storyboard = UIStoryboard(name: "AHProductUnitPrice", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "AHProductUnitPriceListViewController") as! AHProductUnitPriceListViewController
        self.navigationController?.pushViewController(vc, animated: true)
        
    }


}

//MARK: - Collection View Flow Layout Delegate
extension AHDashboardMenuViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath) -> CGSize {
        //2
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow

        return CGSize(width: widthPerItem, height: 200)
    }

    func collectionView(_ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }


    func collectionView(_ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        // 1
        switch kind {
            // 2
        case UICollectionView.elementKindSectionHeader:
            // 3
            guard let headerView = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: "\(HeaderCollectionReusableView.self)",
                for: indexPath) as? HeaderCollectionReusableView
                else {
                    fatalError("Invalid view type")
            }

            let title = menuHeaders[indexPath.section]
            headerView.headerTitle.text = title
            return headerView
        default:
            // 4
            assert(false, "Invalid element type")
        }
    }


}

