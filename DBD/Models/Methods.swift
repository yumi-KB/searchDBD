import UIKit

enum ValidationError: Error {
    case invalidLength
    case invalidString
}

/* steamIDかCustomID の入力に適するかを検証 */
func validateIDs(_ input: String) throws {
    guard !((input).isEmpty) else {
        throw ValidationError.invalidLength
    }
    guard (input).count <= 40 else {
        throw ValidationError.invalidLength
    }
    guard isVanityURL(input) else {
        throw ValidationError.invalidString
    }
}

func isVanityURL(_ key: String) -> Bool {
    // 半角英数字と-_　以外の値が一つでもあればvanityURLではない
    let regex = try? NSRegularExpression(pattern: "[^a-zA-Z0-9_-]", options: NSRegularExpression.Options())
    if regex!.firstMatch(in: key, options: NSRegularExpression.MatchingOptions(), range: NSMakeRange(0, key.count)) != nil {
        return false
    }
    return true
}

func isNumber(_ key: String) -> Bool {
    // 数字以外の値が一つでもあれば数字ではない
    let regex = try? NSRegularExpression(pattern: "[^0-9]", options: NSRegularExpression.Options())
    if regex!.firstMatch(in: key, options: NSRegularExpression.MatchingOptions(), range: NSMakeRange(0, key.count)) != nil {
        return false
    }
    return true
}
