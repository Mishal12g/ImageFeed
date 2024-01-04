import XCTest
@testable import ImageFeed

final class ProfileTests: XCTestCase {
    func testExitProfile() {
        //given
        let vc = ProfileViewController()
        let presenter = ProfilePresenterSpy()
        vc.configure(presenter)
        presenter.view = vc
        
        //when
        vc.onExitButton()
        
        //then
        XCTAssertTrue(presenter.exitProfileCalled)
    }
    
    func testCleanTokenProfile() {
        //given
        let vc = ProfileViewController()
        let presenter = ProfilePresenterSpy()
        vc.configure(presenter)
        presenter.view = vc
        let alertModel = presenter.exitProfileAction()
        
        //when
        alertModel.completion()
        
        //then
        XCTAssertTrue(presenter.token.isEmpty)
    }
}

class ProfilePresenterSpy: ProfilePresenterProtocol {
    var view: ProfileViewControllerProtocol?
    var token = "token"
    var exitProfileCalled: Bool = false
    
    func exitProfileAction() -> AlertModel {
        let model = AlertModel(title: "Пока, пока!",
                               message: "Уверены что хотите выйти?",
                               buttonText: "Да",
                               buttonText2: "Нет"){
            self.cleanToken()
        }
        
        exitProfileCalled = true
        return model
    }
    
    func cleanToken() {
        token = ""
    }
}
