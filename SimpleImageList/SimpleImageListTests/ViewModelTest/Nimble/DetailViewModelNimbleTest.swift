//
//  DetailViewModelNimbleTest.swift
//  SimpleImageListTests
//
//  Created by 배정환 on 4/5/25.
//

import Foundation
import Quick
import Nimble
@testable import SimpleImageList

class DetailViewModelNimbleSpec: QuickSpec {

    override class func spec() {
        var viewModel: DetailViewListType?
        let timeout: Int = ProcessInfo.processInfo.environment["SIMULATOR_DEVICE_NAME"] != nil ? 10 : 5

        beforeEach {
            viewModel = DetailViewModel(service: PicSumImageService())
        }

        afterEach {
            viewModel = nil
        }

        describe("DetailViewModel") {
            context("loadDetail 호출 시") {
                it("detailModel의 id가 '1'이어야 한다") {
                    waitUntil(timeout: .seconds(timeout)) { done in
                        Task {
                            _ = await viewModel?.loadDetail(imageId: "1")

                            // Nimble assertion
                            expect(viewModel?.detailModel.id).to(equal("1"), description: "detail id가 1이 아님")
                            expect(viewModel?.detailModel.id).toNot(equal("0"), description: "detail id가 0임 (예상치 못한 값)")
                            done()
                        }
                    }
                }
            }
        }
    }
}
