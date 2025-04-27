//
//  DetailViewModel.swift
//  SimpleImageList
//
//  Created by 배정환 on 3/30/25.
//

import Foundation

protocol DetailViewListType {
    func loadDetail(imageId: String) async
    func getContentData() -> String
    var detailModel: PicSumItem { get }
}

class DetailViewModel: DetailViewListType {
    private let service: PicSumImageServiceProtocol
    private(set) var detailModel: PicSumItem = PicSumItem()

    init(service: PicSumImageServiceProtocol) {
        self.service = service
    }

    func loadDetail(imageId: String) async {
        let result = await service.detailImage(imageId: imageId)
        switch result {
        case .success(let response):
            self.detailModel =
            PicSumItem(
                id: response.id ?? "",
                author: response.author ?? "",
                width: response.width ?? 0,
                height: response.height ?? 0,
                url: response.url ?? "",
                downloadUrl: response.downloadUrl ?? ""
            )
        case .failure(let error):
            print(error.localizedDescription)
            self.detailModel = PicSumItem()
        }
    }

    func getContentData() -> String {
        return """
            id: \(self.detailModel.id)
            author: \(self.detailModel.author)
            width: \(self.detailModel.width)
            height: \(self.detailModel.height)
            url: \(self.detailModel.url)
            download_url: \(self.detailModel.downloadUrl)"
            """
    }
}
