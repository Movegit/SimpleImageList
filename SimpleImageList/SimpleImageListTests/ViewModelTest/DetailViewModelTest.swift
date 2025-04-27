//
//  DetailViewModelTest.swift
//  SimpleImageListTests
//
//  Created by 배정환 on 3/30/25.
//

import Foundation
import XCTest
@testable import SimpleImageList


final class DetailViewModelTest: XCTestCase {
    var viewModel: DetailViewListType?

    override func setUpWithError() throws {
        try super.setUpWithError()
        viewModel = DetailViewModel(service: PicSumImageService())
    }

    override func tearDownWithError() throws {
        viewModel = nil
        try super.tearDownWithError()
    }

    func testDetailImageSuccess() async throws {
        _ = await viewModel?.loadDetail(imageId: "1")

        XCTAssertTrue(viewModel?.detailModel.id == "1", "detail id is 1")

        XCTAssertFalse(viewModel?.detailModel.id == "0", "detail id is 1")
    }
}
