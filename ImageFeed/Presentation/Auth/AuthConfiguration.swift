import Foundation

let AccessKey = "5IS-aMFDyyWSiwCwIPFh66F6IxIo78RYds1myrkvNLQ"
let SecretKey = "IrxGwL0Zm_LmMOn_PW-CIUwky34daJozoJdNSHWKPAU"
let RedirectURI = "urn:ietf:wg:oauth:2.0:oob"
let AccessScope = "public+read_user+write_likes"
let DefaultBaseURL = URL(string: "https://api.unsplash.com/")!
let UnsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"

struct AuthConfiguration {
    let accessKey: String
    let secretKey: String
    let redirectUri: String
    let accessScope: String
    let defaultBaseURL: URL
    let unsplashAuthorizeURLString: String
    
    init(accessKey: String, secretKey: String, redirectUri: String, accessScope: String, defaultBaseURL: URL, unsplashAuthorizeURLString: String) {
        self.accessKey = accessKey
        self.secretKey = secretKey
        self.redirectUri = redirectUri
        self.accessScope = accessScope
        self.defaultBaseURL = defaultBaseURL
        self.unsplashAuthorizeURLString = unsplashAuthorizeURLString
    }
    
    static let standart: AuthConfiguration = {
        return AuthConfiguration(accessKey: AccessKey,
                                 secretKey: SecretKey,
                                 redirectUri: RedirectURI,
                                 accessScope: AccessScope,
                                 defaultBaseURL: DefaultBaseURL,
                                 unsplashAuthorizeURLString: UnsplashAuthorizeURLString)
    }()
}
