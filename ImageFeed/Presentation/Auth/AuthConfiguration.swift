import Foundation

enum Constaints {
    static let accessKey = "5IS-aMFDyyWSiwCwIPFh66F6IxIo78RYds1myrkvNLQ"
    static let secretKey = "IrxGwL0Zm_LmMOn_PW-CIUwky34daJozoJdNSHWKPAU"
    static let redirectURI = "urn:ietf:wg:oauth:2.0:oob"
    static let accessScope = "public+read_user+write_likes"
    static let defaultBaseURL = URL(string: "https://api.unsplash.com/")!
    static let unsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"
}

struct AuthConfiguration {
    let accessKey: String
    let secretKey: String
    let redirectUri: String
    let accessScope: String
    let defaultBaseURL: URL
    let unsplashAuthorizeURLString: String
        
    static let standart: AuthConfiguration = {
        return AuthConfiguration(accessKey: Constaints.accessKey,
                                 secretKey: Constaints.secretKey,
                                 redirectUri: Constaints.redirectURI,
                                 accessScope: Constaints.accessScope,
                                 defaultBaseURL: Constaints.defaultBaseURL,
                                 unsplashAuthorizeURLString: Constaints.unsplashAuthorizeURLString)
    }()
}
