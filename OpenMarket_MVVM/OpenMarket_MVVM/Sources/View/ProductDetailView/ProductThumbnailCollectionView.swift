//
//  ProductThumbnailCollectionView.swift
//  OpenMarket_MVVM
//
//  Copyright (c) 2023 Minii All rights reserved.

import UIKit

protocol ProductDetailScrollDelegate: AnyObject {
    func productDetailCollectionView(
        collectionView: UICollectionView,
        numberOfImages imagesCount: Int
    )
    
    func productDetailCollectionView(
        collectionView: UICollectionView,
        currentIndex index: Int
    )
}

class ProductThumbnailCollectionView: UICollectionView {
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        
        delegate = self
        dataSource = self
    }
    
    weak var detailImagesDelegate: ProductDetailScrollDelegate?
    private var imageDatas: [ImageData] = []
    
    convenience init() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        self.init(frame: .zero, collectionViewLayout: layout)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setImageDatas(with datas: [ImageData]) {
        self.imageDatas = datas
        detailImagesDelegate?.productDetailCollectionView(
            collectionView: self,
            numberOfImages: datas.count
        )
        self.reloadData()
    }
}

extension ProductThumbnailCollectionView: UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return imageDatas.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: ProductDetailImageCell.identifier,
            for: indexPath
        )
        
        guard let cell = cell as? ProductDetailImageCell else {
            return UICollectionViewCell()
        }
        
        let item = imageDatas[indexPath.row]
        cell.setImage(with: item.url)
        
        return cell
    }
}

extension ProductThumbnailCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        return .zero
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        return collectionView.bounds.size
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let width = scrollView.frame.width
        let page = Int(scrollView.contentOffset.x / width)
        detailImagesDelegate?.productDetailCollectionView(
            collectionView: self,
            currentIndex: page
        )
    }
}
