//
//  MainViewController.swift
//  SimpleImageList
//
//  Created by 배정환 on 3/30/25.
//

import Foundation
import UIKit

enum MyImageListSection: Int {
    case mainImageList
    case emptyImageList
}

class MainViewController: UIViewController {
    private let viewModel: MainViewListType
    private lazy var headerView = MainHeaderView(title: "Pic List")
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.createLayout())
        collectionView.isScrollEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = .white

        collectionView.register(MainImageCollectionViewCell.self,
                                forCellWithReuseIdentifier: MainImageCollectionViewCell.cellReuseIdentifier)
        collectionView.register(EmptyImageCollectionViewCell.self,
                                forCellWithReuseIdentifier: EmptyImageCollectionViewCell.cellReuseIdentifier)

        collectionView.accessibilityIdentifier = "MainViewCollectionView"

        return collectionView
    }()

    private let sectionList: [MyImageListSection] = [.mainImageList, .emptyImageList]

    public init(viewModel: MainViewListType) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - VC lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setUp()
        bind()
    }
}

// MARK: - SetUp
extension MainViewController {
    private func setUp() {
        view.backgroundColor = .white
        view.addSubview(headerView)
        view.addSubview(collectionView)

        headerView.snp.makeConstraints { [weak self] make in
            guard let self else { return }
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            make.leading.equalTo(self.view.safeAreaLayoutGuide.snp.leading)
            make.trailing.equalTo(self.view.safeAreaLayoutGuide.snp.trailing)
            make.height.equalTo(60)
        }

        collectionView.snp.makeConstraints { [weak self] make in
            guard let self else { return }
            make.top.equalTo(self.headerView.snp.bottom)
            make.leading.equalTo(self.view.safeAreaLayoutGuide.snp.leading)
            make.trailing.equalTo(self.view.safeAreaLayoutGuide.snp.trailing)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
        }
    }

    private func bind() {
        Task { [weak self] in
            guard let self else { return }
            _ = await self.viewModel.loadData(initialize: true)

            self.collectionView.dataSource = self
            self.collectionView.delegate = self
            self.collectionView.reloadData()
        }
    }
}

// MARK: - createCollectionView layout
extension MainViewController {
    private func createLayout() -> UICollectionViewCompositionalLayout {
        UICollectionViewCompositionalLayout { (section, _) -> NSCollectionLayoutSection? in
            guard let sectionType = MyImageListSection(rawValue: section) else {return nil}
            switch sectionType {
            case .mainImageList:
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                      heightDimension: .absolute(90.0))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                       heightDimension: .absolute(90.0))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                let section = NSCollectionLayoutSection(group: group)
                section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)

                return section
            case .emptyImageList:
                let itemSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .absolute(122)
                )

                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)

                let groupSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .absolute(122)
                )
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

                // Section
                let section = NSCollectionLayoutSection(group: group)
                section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
                return section
            }
        }
    }
}

extension MainViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let sectionType = sectionList[indexPath.section]
        switch sectionType {
        case .mainImageList:
            let item = viewModel.picList[indexPath.row]
            let viewModel: DetailViewListType = DetailViewModel(service: PicSumImageService())
            let vc = DetailImageViewController(viewModel: viewModel, imageId: item.id)
            self.navigationController?.pushViewController(vc, animated: true)
        case .emptyImageList:
            break
        }
    }

    func collectionView(_ collectionView: UICollectionView,
                        willDisplay cell: UICollectionViewCell,
                        forItemAt indexPath: IndexPath) {
        if indexPath.row == viewModel.picList.count - 1 {
            Task { [weak self] in
                guard let self else { return }
                if self.viewModel.isLoadingData == false && self.viewModel.hasNext {
                    _ = await self.viewModel.loadData(initialize: false)
                    self.collectionView.reloadData()
                }
            }
        }
    }
}

extension MainViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sectionList.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let sectionType = sectionList[section]
        switch sectionType {
        case .mainImageList:
            return viewModel.picList.count
        case .emptyImageList:
            return viewModel.picList.isEmpty == true ? 1 : 0
        }
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let sectionType = sectionList[indexPath.section]
        switch sectionType {
        case .mainImageList:
            guard let item = viewModel.picList[safe: indexPath.row],
                    let cell = collectionView.dequeueReusableCell(
                        withReuseIdentifier: MainImageCollectionViewCell.cellReuseIdentifier,
                        for: indexPath
                    ) as? MainImageCollectionViewCell else {
                return UICollectionViewCell()
            }

            cell.bindingCell(data: item)

            return cell
        case .emptyImageList:
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: EmptyImageCollectionViewCell.cellReuseIdentifier,
                for: indexPath
            ) as? EmptyImageCollectionViewCell else {
                return UICollectionViewCell()
            }

            return cell
        }
    }
}
