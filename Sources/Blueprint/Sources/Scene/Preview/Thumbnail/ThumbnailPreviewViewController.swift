//
//  ThumbnailPreviewController.swift
//  Blueprint
//
//  Created by Euigyom Kim on 2023/05/11.
//  Copyright (c) 2023 WantedLab Inc.. All rights reserved.
//

import UIKit
import Photos
import PhotosUI

import Montage

// MARK: - ThumbnailPreviewController

final class ThumbnailPreviewController: BaseViewController {
    typealias Item = ThumbnailPreview.ViewModel.Item
    typealias DataSource = UICollectionViewDiffableDataSource<String, Item>
    typealias Snapshot = NSDiffableDataSourceSnapshot<String, Item>
    
    private lazy var collectionView: UICollectionView = {
        var config = UICollectionLayoutListConfiguration(appearance: .plain)
        config.showsSeparators = false
        config.backgroundColor = .clear
        let layout = UICollectionViewCompositionalLayout.list(using: config)
        return UICollectionView(frame: view.bounds, collectionViewLayout: layout)
    }()
    
    private lazy var itemStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        return view
    }()
    
    lazy var dataSource: DataSource = makeDataSource()
    
    var interactor: ThumbnailPreviewRequestLogic?

    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        
        interactor?.process(ThumbnailPreview.Request.OnLoad())
    }
}

extension ThumbnailPreviewController {
    private func setupViews() {
        title = "Thumbnail"
        
        setupNavigationItem()
        setupCollectionView()
    }
    
    private func setupNavigationItem() {
        navigationItem.rightBarButtonItem = .init(customView: itemStackView)
    }
    
    private func setupCollectionView() {
        view.addSubview(collectionView)
        setContentScrollView(collectionView)
        
        collectionView.backgroundColor = .clear
        collectionView.register(ThumbnailItemCell.self)
        
        collectionView.snp.makeConstraints {
            $0.top.left.right.equalTo(view.safeAreaLayoutGuide)
            $0.bottom.equalToSuperview()
        }
    }
}

extension ThumbnailPreviewController {
    private func makeDataSource() -> DataSource {
        let dataSource = DataSource(collectionView: collectionView) { collectionView, indexPath, item in
            let cell = collectionView.dequeueReusableCell(forIndexPath: indexPath) as ThumbnailItemCell
            cell.configure(with: item)
            return cell
        }
        
        return dataSource
    }
}

// MARK: - ThumbnailPreviewDisplayLogic

extension ThumbnailPreviewController: ThumbnailPreviewDisplayLogic {
    func display(_ viewModel: ThumbnailPreview.ViewModel.List) {
        var snapshot = dataSource.snapshot()
        snapshot.deleteAllItems()
        snapshot.appendSections([""])
        snapshot.appendItems(viewModel.items)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    func display(_ viewModel: ThumbnailPreview.ViewModel.ButtonGroup) {
        itemStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        viewModel.buttons.forEach { button in
            let item = UIButton(configuration: .plain(), primaryAction: UIAction() { [self] _ in
                self.interactor?.process(
                    ThumbnailPreview.Request.OnExecuteUserAction(action: button.userAction)
                )
            })
            
            item.setImage(.init(systemName: button.imageName), for: .normal)
            item.isSelected = button.selected
            
            if let menu = makeMenuForButton(from: button) {
                item.menu = menu
                item.showsMenuAsPrimaryAction = true
            }
            
            itemStackView.addArrangedSubview(item)
        }
    }
    
    func display(_ viewModel: ThumbnailPreview.ViewModel.ImagePicker) {
        var pickerConfiguration = PHPickerConfiguration()
        pickerConfiguration.filter = .images
        pickerConfiguration.selectionLimit = 1
        
        let imagePicker = PHPickerViewController(configuration: pickerConfiguration)
        imagePicker.delegate = self
        present(imagePicker, animated: true)
    }
    
    private func makeMenuForButton(from viewModel: ThumbnailPreview.ViewModel.Button) -> UIMenu? {
        guard let submenus = viewModel.submenus else { return nil }
        
        return UIMenu(children: submenus.map { submenu in
            UIAction(
                title: submenu.text,
                image: .init(systemName: submenu.imageName),
                attributes: submenu.enabled ? [] : [.disabled]
            ) { [self] _ in
                self.interactor?.process(
                    ThumbnailPreview.Request.OnExecuteUserAction(action: submenu.userAction)
                )
            }
        })
    }
}

extension ThumbnailPreviewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        guard let itemProvider = results.first?.itemProvider else { return }
        guard itemProvider.canLoadObject(ofClass: UIImage.self) else { return }
        
        itemProvider.loadObject(ofClass: UIImage.self) { [weak self] image, _ in
            DispatchQueue.main.async {
                guard let selectedImage = image as? UIImage else { return }
                
                self?.interactor?.process(
                    ThumbnailPreview.Request.OnExecuteUserAction(
                        action: .selectedImage(selectedImage)
                    )
                )
                
                picker.dismiss(animated: true)
            }
        }
    }
}
