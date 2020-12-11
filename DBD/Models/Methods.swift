import UIKit
import Alamofire

func isVanityURL (_ key: String) -> Bool {
    // 半角英数字と-_　以外の値が一つでもあればvanityURLではない
    let regex = try? NSRegularExpression(pattern: "[^a-zA-Z0-9_-]", options: NSRegularExpression.Options())
    if regex!.firstMatch(in: key, options: NSRegularExpression.MatchingOptions(), range: NSMakeRange(0, key.count)) != nil {
        return false
    }
    return true
}

func isNumber(_ key: String) -> Bool {
    // 数字　以外の値が一つでもあれば数字ではない
    let regex = try? NSRegularExpression(pattern: "[^0-9]", options: NSRegularExpression.Options())
    if regex!.firstMatch(in: key, options: NSRegularExpression.MatchingOptions(), range: NSMakeRange(0, key.count)) != nil {
        return false
    }
    return true
}
