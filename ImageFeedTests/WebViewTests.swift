import XCTest
@testable import ImageFeed

final class WebViewTests: XCTestCase {
    func testViewControllerCallsViewDidLoad() {
        //given
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let webViewVC = storyBoard.instantiateViewController(withIdentifier: "WebViewViewController") as! WebViewViewController
        let presenter = WebViewPresenterSpy()
        webViewVC.presenter = presenter
        presenter.view = webViewVC
        
        //when
        _ = webViewVC.view
        
        //then
        XCTAssertTrue(presenter.viewDidLoadCalled)
    }
    
    func testPresenterCallsLoadRequest() {
        //given
        let viewController = WebViewViewControllerSpy()
        let helper = AuthHelper()
        let presenter = WebViewPresenter(authHelper: helper)
        viewController.presenter = presenter
        presenter.view = viewController
        
        //when
        presenter.viewDidLoad()
        
        //then
        XCTAssertTrue(viewController.loadRequestCalled)
    }
    
    func testProgressVisibleWhenLessThenOne() {
        //given
        let authHelper = AuthHelper()
        let presenter = WebViewPresenter(authHelper: authHelper)
        let progress: Float = 0.6
        
        //when
        let shouldHideProgress = presenter.shouldHideProgress(for: progress)
        
        //then
        XCTAssertFalse(shouldHideProgress)
    }
    
    func testProgressHiddenWhenOne() {
        //given
        let authHelper = AuthHelper()
        let presenter = WebViewPresenter(authHelper: authHelper)
        let progress: Float = 1
        
        //when
        let shouldHideProgress = presenter.shouldHideProgress(for: progress)
        
        //then
        XCTAssertTrue(shouldHideProgress)
    }
    
    func testAuthHelperAuthURL() {
        //given
        let configuration = AuthConfiguration.standart
        let helper = AuthHelper(configuration: configuration)
        
        //when
        let url = helper.authURL()
        let urlString = url!.absoluteString
        
        //then
        XCTAssertTrue(urlString.contains(configuration.accessKey))
        XCTAssertTrue(urlString.contains(configuration.accessScope))
        XCTAssertTrue(urlString.contains(configuration.redirectUri))
        XCTAssertTrue(urlString.contains("code"))
    }
    
    func testCodeFromURL() {
        //given
        let helper = AuthHelper()
        var urlComponentrs = URLComponents(string: "https://unsplash.com/oauth/authorize/native")
        urlComponentrs?.queryItems = [URLQueryItem(name: "code", value: "test code")]
        let url = urlComponentrs?.url
        
        //when
        let code = helper.code(from: url!)
        
        //then
        XCTAssertEqual(code, "test code")
    }
}

final class WebViewPresenterSpy: WebViewPresenterProtocol {
    var viewDidLoadCalled: Bool = false
    var view: WebViewViewControllerProtocol?
    
    func viewDidLoad() {
        viewDidLoadCalled = true
    }
    
    func didUpdateProgressValue(_ newValue: Double) {}
    
    func code(from url: URL) -> String? {
        nil
    }
}

final class WebViewViewControllerSpy: WebViewViewControllerProtocol {
    var loadRequestCalled: Bool = false
    var presenter: ImageFeed.WebViewPresenterProtocol?
    
    func load(request: URLRequest) {
        loadRequestCalled = true
    }
    
    func setProgressValue(newValue: Float) {
        
    }
    
    func setProgressHindden(_ isHidden: Bool) {
        
    }
}
