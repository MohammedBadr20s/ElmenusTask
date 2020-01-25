//
//  ViewController.swift
//  elmenusTask
//
//  Created by D-TAG on 1/24/20.
//  Copyright © 2020 elmenus. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SVProgressHUD

class HomeVC: UIViewController {
    
    //MARK:- Outlets
    @IBOutlet weak var TagsCollectionView: UICollectionView!
    @IBOutlet weak var ItemCollectionView: UICollectionView!
    @IBOutlet weak var tagNameLabel: CustomLabel!
    @IBOutlet weak var NestedViewHeight: NSLayoutConstraint!
    
    //MARK:- Properties
    private let tagsCellIdentifier = "TagsCell"
    private let itemCellIdentifier = "ItemsCell"
    var currentTagPage = 0
    var stopLoadingMoreFlag = false
    var loadMore = false
    var loading = false
    var homeViewModel = HomeViewModel()
    var disposeBag = DisposeBag()
    var Tags = [Tag]() {
        didSet {
            DispatchQueue.main.async {
                self.homeViewModel.fetchTags(tagsArr: self.Tags)
                self.TagsCollectionView.reloadData()
            }
        }
    }
    var Items = [Item]() {
        didSet {
            DispatchQueue.main.async {
                self.homeViewModel.fetchItems(ItemsArr: self.Items)
            }
        }
    }
    var current_index = Int()
    //MARK:- Application Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //MARK:- Binding Functions
        SVProgressHUD.show()
        bindTagsCollectionView()
        bindItemsCollectionView()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        //MARK:- Tags list shouldn't be sticky at the top of the screen (scrolls of the screen on scrolling if the content height > screen height)
        if self.ItemCollectionView.contentSize.height > self.view.frame.height {
            self.NestedViewHeight.constant = self.ItemCollectionView.contentSize.height
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        //MARK:- Checking for Network
        if Reachability.isConnectedToNetwork() {
            getTags(currentPage: 0)
            
        } else {
            displayMessage(title: "Error", message: "You Are Offline", status: .error, forController: self)
        }
    }
    
}
//MARK:- Binding Functions
extension HomeVC {
    //MARK:- Bind Tags Collection View
    func bindTagsCollectionView() {
        TagsCollectionView.rx.setDelegate(self).disposed(by: disposeBag)
        TagsCollectionView.register(UINib(nibName: tagsCellIdentifier, bundle: nil), forCellWithReuseIdentifier: tagsCellIdentifier)
        //MARK:- Drawing the Tags CollectionView Layout the equivalent of CellForItem in RxSwift
        homeViewModel.Tags.bind(to: TagsCollectionView.rx.items(cellIdentifier: tagsCellIdentifier, cellType: TagsCell.self)) { index, element, cell in
            cell.config(TagImageURL: self.Tags[index].photoURL ?? "", TagName: self.Tags[index].tagName ?? "", selected: self.Tags[index].selected ?? false)
            
            }.disposed(by: disposeBag)
        //MARK:- Selecting an item from CollectionView the equivalent of DidSelectAtRow in RxSwift
        TagsCollectionView.rx.itemSelected.bind { (indexPath) in
            for i in 0..<self.Tags.count {
                if i == indexPath.row {
                    self.Tags[i].selected = true
                } else {
                    self.Tags[i].selected = false
                }
            }
            self.TagsCollectionView.reloadData()
            var fulltagname = (self.Tags[indexPath.row].tagName ?? "").components(separatedBy: "-")
            self.tagNameLabel.text = fulltagname[1].trim()
            if Reachability.isConnectedToNetwork() {
                self.getItems(TagName: fulltagname[1].trim())
            } else {
                displayMessage(title: "Error", message: "You Are Offline", status: .error, forController: self)
            }
            }.disposed(by: disposeBag)
    }//END OF Bind Tags Collection View
    //MARK:- Bind ItemsCollectionView
    func bindItemsCollectionView() {
        ItemCollectionView.rx.setDelegate(self).disposed(by: disposeBag)
        ItemCollectionView.register(UINib(nibName: itemCellIdentifier, bundle: nil), forCellWithReuseIdentifier: itemCellIdentifier)
        homeViewModel.Items.bind(to: ItemCollectionView.rx.items(cellIdentifier: itemCellIdentifier, cellType: ItemsCell.self)) { index, element, cell in
            cell.config(ItemImageURL: self.Items[index].photoURL ?? "", ItemName: self.Items[index].name ?? "")
            }.disposed(by: disposeBag)
        
        ItemCollectionView.rx.itemSelected.bind { (indexPath) in
            print(self.Items[indexPath.row].name ?? "")
            self.current_index = indexPath.row
            self.performSegue(withIdentifier: "showDetails", sender: nil)
            }.disposed(by: disposeBag)
    }//END OF Bind ItemsCollectionView
    //MARK:- Prepare For Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? ItemDetailsVC {
            destination.product_URL = self.Items[current_index].photoURL ?? ""
            destination.product_description = self.Items[current_index].itemDescription ?? ""
            destination.title = self.Items[current_index].name ?? ""
        }
    }//END OF Prepare For Segue
}
//Function to Get Data from View Model
extension HomeVC {
    //MARK:- Getting Tag list
    func getTags(currentPage: Int) {
        homeViewModel.getTags(PageNumber: currentPage).subscribe(onNext: { (Tags) in
            //MARK:- Handling Pagination
            if self.loadMore  {
                self.Tags.append(contentsOf: Tags)
                self.loading = false
                if Tags.count == 0 {
                    self.loadMore = false
                    self.stopLoadingMoreFlag = true
                }
            } else {
                self.Tags = Tags
                self.loadMore = true
            }
            self.currentTagPage += 1
            //MARK:- Loading the first TagName's Items
            if currentPage == 0 {
                var fulltagname = (self.Tags[0].tagName ?? "").components(separatedBy: "-")
                self.tagNameLabel.text = fulltagname[1].trim()
                
                if Reachability.isConnectedToNetwork() {
                    self.getItems(TagName: fulltagname[1].trim())
                } else {
                    displayMessage(title: "Error", message: "You Are Offline", status: .error, forController: self)
                }
                
            }
            SVProgressHUD.dismiss()
            
        }, onError: { (error) in
            displayMessage(title: "", message: error.localizedDescription, status: .error, forController: self)
        }).disposed(by: disposeBag)
    }//END OF Getting Tag list
    //MARK:- Loading Items Function
    func getItems(TagName: String) {
        homeViewModel.getItems(tagName: TagName).subscribe(onNext: { (Items) in
            self.Items = Items
            self.ItemCollectionView.reloadData()
            SVProgressHUD.dismiss()
        }, onError: { (error) in
            displayMessage(title: "", message: error.localizedDescription, status: .error, forController: self)
        }).disposed(by: disposeBag)
    }//END of Loading Items Function
}
extension HomeVC: UICollectionViewDelegateFlowLayout {
    //MARK:- Drawing Collection View Cell Layout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout:
        UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == TagsCollectionView {
            let flowayout = collectionViewLayout as? UICollectionViewFlowLayout
            let space: CGFloat = (flowayout?.minimumInteritemSpacing ?? 0.0) + (flowayout?.sectionInset.left ?? 0.0) + (flowayout?.sectionInset.right ?? 0.0)
            let size:CGFloat = (collectionView.frame.size.width - space) / 2.5
            return CGSize(width: size, height: 100)
        } else {
            let flowayout = collectionViewLayout as? UICollectionViewFlowLayout
            let space: CGFloat = (flowayout?.minimumInteritemSpacing ?? 0.0) + (flowayout?.sectionInset.left ?? 0.0) + (flowayout?.sectionInset.right ?? 0.0)
            let size:CGFloat = (collectionView.frame.size.width - space) / 2
            return CGSize(width: size, height: 150)
        }
    }//END of Function Drawing Collection View Cell Layout
    //MARK:- Handling The Infinite Scrolling in Tags CollectionView
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == TagsCollectionView {
            if !stopLoadingMoreFlag && !loading {
                let RightEdge = scrollView.contentOffset.x + (scrollView.frame.size.width)
                if (RightEdge + CGFloat(self.currentTagPage) >= scrollView.contentSize.width - 100) {
                    // Load next batch of products
                    print("\(self.currentTagPage)")
                    self.loading = true
                    self.getTags(currentPage: self.currentTagPage)
                }
            }
            
        }
        
    }//END of Function scrollViewDidScroll
}
