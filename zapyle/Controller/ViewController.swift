//
//  ViewController.swift
//  zapyle
//
//  Created by Siddharth Kumar on 19/05/18.
//  Copyright © 2018 Siddharth Kumar. All rights reserved.
//


import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController {
    
    var gridCollectionView: UICollectionView!
    var gridLayout: GridLayout!
    //var scrollableCategoryView:UIScrollView!
    let productDataModel = ProductDataModel()
    var productFullView = UIImageView()
    
    private let api = "https://www.zapyle.com/filters/getEProducts/0/?&i_collection=high-street-fashion&product_category=32,145,5&perpage=48"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        initView()
        getProductData()
    }
    
    
    func initView(){
        
        gridLayout = GridLayout()
        gridCollectionView = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: gridLayout)
        gridCollectionView.backgroundColor = UIColor.white
        gridCollectionView.showsVerticalScrollIndicator = false
        gridCollectionView.showsHorizontalScrollIndicator = false
        gridCollectionView.dataSource = self
        gridCollectionView.delegate = self
        gridCollectionView!.register(GridCell.self, forCellWithReuseIdentifier: "cell")
        self.view.addSubview(gridCollectionView)
        
        var frame = gridCollectionView.frame
        frame.size.height = self.view.frame.size.height*0.9
        frame.size.width = self.view.frame.size.width
        frame.origin.x = 0
        frame.origin.y = self.view.frame.size.height*0.1
        gridCollectionView.frame = frame
        
//        scrollableCategoryView = UIScrollView()
//        view.addSubview(scrollableCategoryView)
//
//        var scrollFrame = gridCollectionView.frame
//        scrollFrame.size.height = self.view.frame.size.height*0.1
//        scrollFrame.size.width = self.view.frame.size.width
//        scrollFrame.origin.x = 0
//        scrollFrame.origin.y = self.view.frame.size.height*0.05
//        scrollableCategoryView.frame = scrollFrame
//        scrollableCategoryView.translatesAutoresizingMaskIntoConstraints = false
        
        //The view which appears on tapping a product
        productFullView = UIImageView(frame:self.view.frame)
        productFullView.contentMode = .scaleAspectFit
        productFullView.backgroundColor = UIColor.white
        productFullView.isUserInteractionEnabled = true
        productFullView.alpha = 0
        self.view.addSubview(productFullView)
        
        let dismissOnTap = UITapGestureRecognizer(target: self, action: #selector(hideProductFullView))
        productFullView.addGestureRecognizer(dismissOnTap)
        
    }
    
    
    func getProductData() {
        
        Alamofire.request(api, method: .get).responseJSON {
            response in
            if response.result.isSuccess {
                let ProductJSON : JSON = JSON(response.result.value!)
                self.updateProductDataModel(json: ProductJSON)
            }
            else {
                print("Error \(String(describing: response.result.error))")
            }
        }
    }
    
    
    
    func updateProductDataModel(json : JSON) {
        for obj in (json["data"]["data"].arrayValue) {
            productDataModel.brand.append(obj["_source"]["i_brand"].stringValue)
            productDataModel.title.append(obj["_source"]["title"].stringValue)
            productDataModel.price.append(obj["_source"]["original_price"].intValue)
            productDataModel.imageUrl.append(obj["_source"]["image"].stringValue)
            
        }
        updateUIWithProductData()
    }
    
    
    
    func updateUIWithProductData() {
        gridCollectionView.reloadData()
    }
    
    
    func showProductFullView(of image:UIImage) {
        
        productFullView.transform = CGAffineTransform(scaleX: 0, y: 0)
        productFullView.contentMode = .scaleAspectFit
        
        UIView.animate(withDuration: 0.5, delay: 0, options: [.curveEaseOut], animations:{[unowned self] in
            
            self.productFullView.image = image
            self.productFullView.alpha = 1
            self.productFullView.transform = CGAffineTransform(scaleX: 1, y: 1)
            
            }, completion: nil)
    }
    
    @objc func hideProductFullView() {
        
        UIView.animate(withDuration: 0.5, delay: 0, options: [.curveEaseOut], animations:{[unowned self] in
            self.productFullView.alpha = 0
            }, completion: nil)
    }
    
}


extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return productDataModel.title.count
        
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! GridCell
        cell.backgroundColor = UIColor.white
        cell.imageView.contentMode = .scaleAspectFill
        cell.imageView.clipsToBounds = true
        cell.brandLabel.text = "\(productDataModel.brand[indexPath.row].uppercased())"
        cell.titleLabel.text = "\(productDataModel.title[indexPath.row])"
        cell.priceLabel.text = "₹ \(productDataModel.price[indexPath.row])"
        
        if let imageUrl:URL = URL(string: productDataModel.imageUrl[indexPath.row]){
            
            // Start background thread so that image loading does not make app unresponsive
            DispatchQueue.global(qos: .userInitiated).async {
                
                if let imageData:NSData = NSData(contentsOf: imageUrl){
                    
                    // When from background thread, UI needs to be updated on main queue
                    DispatchQueue.main.async {
                        
                        let image = UIImage(data: imageData as Data)
                        cell.imageView.image = image
                        
                    }
                }
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cell = collectionView.cellForItem(at: indexPath) as! GridCell
        
        if let image = cell.imageView.image {
            self.showProductFullView(of: image)
        } else {
            print("no photo")
        }
    }
    
    
}

