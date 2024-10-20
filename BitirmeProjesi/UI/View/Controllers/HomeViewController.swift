//
//  HomeViewController.swift
//  BitirmeProjesi
//
//  Created by Mehmet Faik Ayhan on 9.10.2024.
//

import UIKit
import Kingfisher
import StoreKit

//MARK: Anasayfadaki öğelerin bağlanması ve köprülerin kurulması
 
final class HomeViewController: UIViewController{
    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var segmentedControl: UISegmentedControl!
    @IBOutlet private weak var collectionView: UICollectionView!
    
    @IBOutlet weak var imageViewMain: UIImageView!
    
    
    let viewModel = HomeViewModel() //HomeViewModel'a köprü
    let detailViewModel = ProductDetailViewModel() //ProductDetailViewModel'a köprü
    var productList = [Products]() // Model Products'a köprü
    var collectionViewCell = ProductsCollectionViewCell() //ProductsCollectionViewCell'a köprü (içeriklerin gösterilmesi)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setCollectionView()
        configureCollectionView()
        setSearchBar()
        setViewModel()
        imageViewMain.image = UIImage(named: "banner")
    }
    
    private func setCollectionView(){
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    private func configureCollectionView(){
        let collectionDesign = UICollectionViewFlowLayout() //Anasayfadaki collectionview dizaynı ölçüleri
        collectionDesign.sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        collectionDesign.minimumLineSpacing = 5
        collectionDesign.minimumInteritemSpacing = 5
        let screenWidth = UIScreen.main.bounds.width
        let cellWidth = (screenWidth - 20) / 3
        collectionDesign.itemSize = CGSize(width: cellWidth, height: cellWidth * 1.6)
        collectionView.collectionViewLayout = collectionDesign
        configureButton() //button
    }
    private func setSearchBar(){
        searchBar.delegate = self
        searchBar.searchBarStyle = .minimal
        searchBar.backgroundImage = UIImage()
        searchBar.layer.borderColor = UIColor.lightGray.cgColor

    }
    private func setViewModel(){
        _ = viewModel.productList.subscribe(onNext: { list in //bir arkaplan iş parçacığı var yani ürün listemin yüklenmesini istiyorum
            self.productList = list
            DispatchQueue.main.async {
                self.collectionView.reloadData() //hata ne olursa olsun içerikleri gönder reloadData()
            }
        })
    }
    private func configureButton(){
        collectionViewCell.cartButton?.tintColor = UIColor(red: 113/255, green: 156/255, blue: 111/255, alpha: 1)
    }
    
    override func viewWillAppear(_ animated: Bool) { //segment kontrolüm ve button rengim
        viewModel.loadProducts()
        segmentedControl.selectedSegmentIndex = 0
        configureButton()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) { //Detay ekranında görüntüleme
        if segue.identifier == "toDetay" {
            if let urun = sender as? Products {
                let goToViewController = segue.destination as! ProductDetailViewController
                goToViewController.product = urun
            }
        }
    }
    
    @IBAction private func categoryControl(_ sender: UISegmentedControl) { //SegmentControl sayesinde ürünlerin katehori şeklinde listelenmesi
        let selectedIndex = sender.selectedSegmentIndex
        switch selectedIndex{
        case 0: viewModel.loadProducts()
        case 1: viewModel.segmentedProductList(idList: viewModel.teknoloji) //teknoloji
        case 2: viewModel.segmentedProductList(idList: viewModel.aksesuar) //aksesuar
        case 3: viewModel.segmentedProductList(idList: viewModel.kozmetik) //kkozmetik
        default:
            break
        }
    }
}
