import Foundation
import CommonCrypto
import CryptoSwift

public extension Applepie where Base == String {
    
    public func md5() -> String {
        return base.md5()
    }
    public func sha1() -> String {
        return base.sha1()
    }
    public func sha224() -> String {
        return base.sha224()
    }
    public func sha256() -> String {
        return base.sha256()
    }
    public func sha384() -> String {
        return base.sha384()
    }
    public func sha512() -> String {
        return base.sha512()
    }
    public func aesEncrypt(key: String, iv: String) -> String? {
        if let aes = try? AES(key: key, iv: iv) {
            return (try? aes.encrypt([UInt8](base.data(using: .utf8)!)))?.toBase64()
        }
        return nil
    }
    public func aesDecrypt(key: String, iv: String) -> String? {
        if let aes = try? AES(key: key, iv: iv), let decrypted = try? aes.decrypt(Array(base64: base)) {
            return String(bytes: Data(decrypted).bytes, encoding: .utf8)
        }
        return nil
    }
    
    public func urlEncode() -> String? {
        return base.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)?
            .replacingOccurrences(of: "&", with: "%26")
            .replacingOccurrences(of: "+", with: "%2B")
            .replacingOccurrences(of: "=", with: "%3D")
    }
    
    public func urlDecode() -> String? {
        return base.removingPercentEncoding
    }
    
    func base64Encode() -> String {
        return Data(base.utf8).base64EncodedString()
    }
    func base64Decode() -> String? {
        guard let data = Data(base64Encoded: base) else {
            return nil
        }
        return String(data: data, encoding: .utf8)
    }
    
    func unicodeDecode() -> String {
        let str = NSMutableString(string: base)
        str.replaceOccurrences(of: "\\U", with: "\\u", options: [], range: NSMakeRange(0, str.length))
        CFStringTransform(str, nil, "Any-Hex/Java" as NSString, true)
        str.replaceOccurrences(of: "\\\"", with: "\"", options: [], range: NSMakeRange(0, str.length))
        return str as String
    }
    
}
