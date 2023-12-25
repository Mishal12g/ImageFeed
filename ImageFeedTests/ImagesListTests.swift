import XCTest
@testable import ImageFeed

final class ImagesListTests: XCTestCase {
    func testConvertImagesListViewModel() {
        //given
        let presenter = ImagesListPresenter()
        let photos: [PhotoResult] = [
            PhotoResult(id: "", createdAt: "", width: 1, height: 1, description: "", isLiked: true, urls: UrlsResult(raw: "", full: "", regular: "", small: "", thumb: ""))
        ]
        //when
        presenter.convert(photoResult: photos)
        
        //then
        XCTAssertEqual(presenter.photos.count, 1)
    }
}
