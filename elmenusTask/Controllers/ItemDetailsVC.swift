//
//  ItemDetailsVC.swift
//  elmenusTask
//
//  Created by D-TAG on 1/25/20.
//  Copyright © 2020 elmenus. All rights reserved.
//

import UIKit

class ItemDetailsVC: UIViewController {

    //MARK:- Outlets
    @IBOutlet weak var imageHeight: NSLayoutConstraint!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var ProductImageView: UIImageView!
    @IBOutlet weak var ProductDescription: UITextView!
    @IBOutlet weak var currentViewHeight: NSLayoutConstraint!
    //MARK:- Properties
    let headerViewMaxHeight: CGFloat = 300
    let headerViewMinHeight: CGFloat = 30 + UIApplication.shared.statusBarFrame.height
    var product_description = String()
    var product_URL = String()
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.delegate = self
        // Do any additional setup after loading the view.
        //MARK:- Getting Data
        getDetails(ProductImageURL: product_URL, ProductDescription: product_description)
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        //MARK:- Expanding the current View Height
        if !self.ProductDescription.text.isEmpty {
            let contentSize = self.ProductDescription.sizeThatFits(self.ProductDescription.bounds.size)
            self.currentViewHeight.constant = contentSize.height + 500
        }
    }
    //MARK:- Function to get View Data
    func getDetails(ProductImageURL: String, ProductDescription: String) {
        self.ProductDescription.text = ProductDescription
        let contentSize = self.ProductDescription.sizeThatFits(self.ProductDescription.bounds.size)
        self.ProductDescription.frame.size.height = contentSize.height
        
        if ProductImageURL != "" {
            guard let imageURL = URL(string: ProductImageURL) else { return }
            self.ProductImageView.kf.setImage(with: imageURL)
        }
    }
}

extension ItemDetailsVC: UIScrollViewDelegate {
    //MARK:- Animation ofr transformation the Product image into a toolbar and vice versa
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let y: CGFloat = scrollView.contentOffset.y
        let newHeaderViewHeight = imageHeight.constant - y
        
        if newHeaderViewHeight > headerViewMaxHeight {
            imageHeight.constant = headerViewMaxHeight
        } else if newHeaderViewHeight < headerViewMinHeight {
            imageHeight.constant = headerViewMinHeight
        } else {
            imageHeight.constant = newHeaderViewHeight
            scrollView.contentOffset.y = 0 // block scroll view
        }
    }
}
