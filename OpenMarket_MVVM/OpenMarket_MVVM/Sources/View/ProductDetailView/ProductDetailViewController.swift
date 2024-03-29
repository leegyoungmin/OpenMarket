//
//  ProductDetailViewController.swift
//  OpenMarket_MVVM
//
//  Copyright (c) 2023 Minii All rights reserved.

import Combine
import UIKit

final class ProductDetailViewController: UIViewController {
    private let contentScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.backgroundColor = .systemBackground
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    
    private let contentView: UIView = {
        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        return contentView
    }()
    
    private let pageCollectionView: ProductThumbnailCollectionView = {
        let collectionView = ProductThumbnailCollectionView()
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(
            ProductDetailImageCell.self,
            forCellWithReuseIdentifier: ProductDetailImageCell.identifier
        )
        collectionView.isPagingEnabled = true
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    private let pageControl: UIPageControl = {
        let control = UIPageControl()
        control.hidesForSinglePage = false
        control.numberOfPages = 5
        control.translatesAutoresizingMaskIntoConstraints = false
        control.pageIndicatorTintColor = .black
        control.currentPageIndicatorTintColor = .red
        control.layer.backgroundColor = UIColor.systemGroupedBackground.cgColor
        control.layer.cornerRadius = 10
        return control
    }()
    
    private let informationView: ProductDetailInformationView = {
        let view = ProductDetailInformationView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    weak var coordinator: ProductDetailCoordinator?
    private let viewModel: ProductDetailViewModel
    private var cancellables = Set<AnyCancellable>()
    
    init(viewModel: ProductDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        viewModel = ProductDetailViewModel(id: 0)
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pageCollectionView.detailImagesDelegate = self
        
        configureUI()
        
        bindFromViewModel()
        bindToViewModel()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        coordinator?.didFinishDetail()
    }
}

extension ProductDetailViewController: ProductDetailScrollDelegate {
    func productDetailCollectionView(
        collectionView: UICollectionView,
        numberOfImages imagesCount: Int
    ) {
        pageControl.numberOfPages = imagesCount
    }
    
    func productDetailCollectionView(
        collectionView: UICollectionView,
        currentIndex index: Int
    ) {
        pageControl.currentPage = index
    }
}

private extension ProductDetailViewController {
    func bindFromViewModel() {
        viewModel.$product
            .compactMap { $0 }
            .receive(on: DispatchQueue.main)
            .sink { product in
                self.pageCollectionView.setImageDatas(with: product.images)
                self.informationView.updateData(with: product)
            }
            .store(in: &cancellables)
        
        viewModel.$isDeleteProduct
            .filter { $0 }
            .receive(on: DispatchQueue.main)
            .sink { _ in
                self.coordinator?.popDetailViewController()
            }
            .store(in: &cancellables)
    }
    
    func bindToViewModel() {
        pageControl.currentPageChangedPublisher
            .sink {
                self.pageCollectionView.scrollToItem(
                    at: IndexPath(row: $0, section: 0),
                    at: .centeredHorizontally,
                    animated: true
                )
            }
            .store(in: &cancellables)
    }
}

private extension ProductDetailViewController {
    func configureUI() {
        view.backgroundColor = .systemBackground
        configureNavigationBar()
        configureHierarchy()
        makeConstraints()
    }
    
    func configureHierarchy() {
        view.addSubview(contentScrollView)
        contentScrollView.addSubview(contentView)
        
        [pageCollectionView, pageControl, informationView].forEach {
            contentView.addSubview($0)
        }
    }
    
    func makeConstraints() {
        NSLayoutConstraint.activate([
            contentScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contentScrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            contentScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            contentScrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.leadingAnchor.constraint(equalTo: contentScrollView.leadingAnchor),
            contentView.topAnchor.constraint(equalTo: contentScrollView.topAnchor),
            contentView.trailingAnchor.constraint(equalTo: contentScrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: contentScrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: contentScrollView.widthAnchor),
            
            pageCollectionView.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor),
            pageCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            pageCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            pageCollectionView.heightAnchor.constraint(equalToConstant: 300),
            
            pageControl.centerXAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.centerXAnchor),
            pageControl.topAnchor.constraint(equalTo: pageCollectionView.bottomAnchor, constant: 12),
            
            informationView.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: 12),
            informationView.topAnchor.constraint(equalTo: pageControl.bottomAnchor, constant: 12),
            informationView.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor, constant: -12),
            informationView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    func configureNavigationBar() {
        let editAction = UIAction { _ in
            let controller = self.configureEditActionSheet()
            self.present(controller, animated: true)
        }
        let editButton = UIBarButtonItem(
            image: UIImage(systemName: "pencil.circle"),
            primaryAction: editAction
        )
        navigationItem.rightBarButtonItem = editButton
    }
    
    func configureEditActionSheet() -> UIAlertController {
        let controller = AlertConcreteBuilder(style: .actionSheet)
            .setAction(title: "삭제", style: .destructive) { _ in
                let deleteController = self.configureDeleteAlert()
                self.present(deleteController, animated: true)
            }
            .setAction(title: "수정", style: .default) { _ in
                guard let product = self.viewModel.product else { return }
                self.coordinator?.presentModifyViewController(with: product)
            }
            .setAction(title: "취소", style: .cancel, completion: nil)
            .generate()
        
        return controller
    }
    
    func configureDeleteAlert() -> UIAlertController {
        let controller = AlertConcreteBuilder(style: .alert)
            .setTitle(with: "상품 삭제")
            .setMessage(with: "정말 삭제하시겠습니까?\n삭제를 원하시면 비밀번호를 작성해주세요.")
            .addTextField()
            .setAction(title: "취소", style: .cancel, completion: nil)
            .generate()
        
        let confirmAction = UIAlertAction(title: "확인", style: .default) { _ in
            guard let textField = controller.textFields?.first,
                  let password = textField.text else { return }
            
            self.viewModel.deleteProduct(password: password)
        }
        
        controller.addAction(confirmAction)
        
        return controller
    }
}
