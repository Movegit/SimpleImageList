//
//  DetailImageViewController.swift
//  SimpleImageList
//
//  Created by 배정환 on 3/30/25.
//

import Foundation
import UIKit

class DetailImageViewController: UIViewController {
    private let viewModel: DetailViewListType
    private lazy var headerView = DetailHeaderView(title: "detailImage")
    private let imageId: String

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.customFont(.Body1)
        label.textColor = UIColor.customColor(.pink100)

        return label
    }()

    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()

        return imageView
    }()

    private lazy var contentLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.customFont(.Subtitle3)
        label.textColor = UIColor.customColor(.pink100)
        label.numberOfLines = 0

        return label
    }()

    init(viewModel: DetailViewListType, imageId: String) {
        self.imageId = imageId
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

// MARK: - Setup
extension DetailImageViewController {
    private func setUp() {
        view.backgroundColor = .white
        view.addSubview(headerView)
        headerView.snp.makeConstraints { [weak self] make in
            guard let self else { return }
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            make.leading.equalTo(self.view.safeAreaLayoutGuide.snp.leading)
            make.trailing.equalTo(self.view.safeAreaLayoutGuide.snp.trailing)
            make.height.equalTo(60)
        }

        view.addSubview(imageView)
        imageView.snp.makeConstraints { [weak self] make in
            guard let self else { return }
            make.top.equalTo(self.headerView.snp.bottom)
            make.leading.equalTo(self.view.safeAreaLayoutGuide.snp.leading)
            make.trailing.equalTo(self.view.safeAreaLayoutGuide.snp.trailing)
            make.height.equalTo(200)
        }

        view.addSubview(contentLabel)
        contentLabel.snp.makeConstraints { [weak self] make in
            guard let self else { return }
            make.top.equalTo(self.imageView.snp.bottom)
            make.leading.equalTo(self.view.safeAreaLayoutGuide.snp.leading).inset(15)
            make.trailing.equalTo(self.view.safeAreaLayoutGuide.snp.trailing).inset(15)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
        }
    }

    private func bind() {
        Task { [weak self] in
            guard let self else { return }
            _ = await self.viewModel.loadDetail(imageId: self.imageId)
            self.imageView.kf.setImage(with: URL(string: self.viewModel.detailModel.downloadUrl))
            self.contentLabel.text = self.viewModel.getContentData()
        }

        headerView.onBackButtonTapped = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
    }
}
