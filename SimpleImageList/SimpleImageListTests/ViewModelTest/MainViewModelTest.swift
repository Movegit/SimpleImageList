//
//  MainViewModelTest.swift
//  SimpleImageListTests
//
//  Created by 배정환 on 3/30/25.
//

import Foundation
import XCTest
@testable import SimpleImageList

final class MainViewModelTest: XCTestCase {

    var viewModel: MainViewListType?

    override func setUpWithError() throws {
        try super.setUpWithError()
        viewModel = MainViewModel(picsumService: PicSumImageService(), defaultPageSize: 30)
    }

    override func tearDownWithError() throws {
        viewModel = nil
        try super.tearDownWithError()
    }

    func testGetImageSuccess() async {
        _ = await viewModel?.loadData(initialize: true)
        let picList = viewModel?.picList ?? []
        XCTAssertFalse(picList.isEmpty, "picList가 비어있음")
    }
}
