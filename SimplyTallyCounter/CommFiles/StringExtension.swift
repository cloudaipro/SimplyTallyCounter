//
//  StringExtension.swift
//  SimplyScanner
//
//  Created by Alex on 2022-11-02.
//

import Foundation

extension String {
    
    // MARK: Index
    public func index(from: Int) -> Index {
        return self.index(startIndex, offsetBy: from)
    }
    
    public func index(of character: Character) -> Int? {
        return self.firstIndex(of: character)?.utf16Offset(in: self)
    }
    
    public func firstIndex(of string: String) -> Int? {
        return self.range(of: string)?.lowerBound.utf16Offset(in: self)
    }
    
    public func lastIndexOfString(of string: String) -> Int? {
        return self.range(of: string, options: .backwards)?.lowerBound.utf16Offset(in: self)
    }
    
    // MARK: Substrings
    public func substring(from: Int) -> String {
        let fromIndex = index(from: from)
        return self[fromIndex...].string
    }

    public func substring(to: Int) -> String {
        let toIndex = index(from: to)
        return self[..<toIndex].string
    }

    public func substring(range: Range<Int>) -> String {
        let startIndex = index(from: range.lowerBound)
        let endIndex = index(from: range.upperBound)
        return self[startIndex..<endIndex].string
    }
    public func substring(from: Int, to: Int) -> String {
        let fromIndex = index(from: from)
        let toIndex = index(from: to)
        return self[fromIndex..<toIndex].string
    }

    public func substring(before: String) -> String {
        if let range = self.range(of: before) {
            return self[self.startIndex..<range.lowerBound].string
        }
        return self
    }
    
    public func substring(after: String) -> String {
        if let range = self.range(of: after) {
            return self[range.upperBound...].string
        }
        return self
    }
    
    public func between(_ l: String, _ r: String) -> String {
        if let rangeLeft = self.range(of: l),
            let rangeRight = self.range(of: r) {
            return self[rangeLeft.upperBound..<rangeRight.lowerBound].string
        }
        return self
    }
    
    
    // MARK: - Replace
    public func replace(_ occurencesOf: String, with: String) -> String {
        return self.replacingOccurrences(of: occurencesOf, with: with)
    }
    
    public func replace(_ occurencesOf: String..., with: String) -> String {
        var result = self
        occurencesOf.forEach {
            s in
            result = result.replacingOccurrences(of: s, with: with)
        }
        return result
    }
    
    public func replace(regularExpression: String, with: String) -> String {
        return self.replacingOccurrences(of: regularExpression, with: with, options: .regularExpression)
    }
    
    // MARK: - Is number
    public var isNumber: Bool {
        return !isEmpty && range(of: "[^0-9]", options: .regularExpression) == nil
    }
    
    // MARK: - Is alphabetic
    public var isAlphabetic: Bool {
        return !isEmpty && range(of: "[^a-zA-Z]", options: .regularExpression) == nil
    }
    
    // MARK: - Is alphanumeric
    public var isAlphanumeric: Bool {
        return !isEmpty && range(of: "[^a-zA-Z0-9]", options: .regularExpression) == nil
    }
    
    // MARK: - Extractions of characters
    public var numberString: String {
        return replace(regularExpression: "[^0-9]", with: "")
    }
    
    public var alphabeticString: String {
        return replace(regularExpression: "[^a-zA-Z]", with: "")
    }
    
    public var alphanumericString: String {
        return replace(regularExpression: "[^a-zA-Z0-9]", with: "")
    }
    
    //MARK: - Charachter set
    public var set: CharacterSet {
        return CharacterSet(charactersIn: self)
    }
    
    // MARK: - String
    public func split(_ separator: String) -> [String] {
        return self.components(separatedBy: separator)
    }
    
    public func split(_ set: CharacterSet) -> [String] {
        return self.components(separatedBy: set)
    }
    
    // MARK: - Camel case
    public var camelCase: String {
        return self.lowercased()
            .replace("-", with: " ")
            .replace("_", with: " ")
            .split(separator: " ")
            .map { return $0.lowercased().capitalized }
            .joined()
    }
    
    // MARK: - Snake case
    public var snakeCase: String {
        return self.lowercased()
            .replace("-", with: " ")
            .replace("_", with: " ")
            .split(separator: " ")
            .map { return $0.lowercased() }
            .join("_")
    }
    
    // MARK: - Latin
    public var latin: String {
        return self.folding(options: .diacriticInsensitive, locale: .current)
    }
    
    // MARK: - Lines
    public var lines: [String] {
        return self.components(separatedBy: CharacterSet.newlines)
    }
    
    // MARK: - Slugging
    public func slugify(withSeparator separator: String = "-") -> String {
        let slugCharacterSet = NSCharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789\(separator)")
        return latin
            .lowercased()
            .components(separatedBy: slugCharacterSet.inverted)
            .filter { $0 != "" }
            .join(separator)
       }
    
    // MARK: - Is empty
    public var isEmpty: Bool {
        return self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).count == 0
    }
    
    // MARK: - Collapse whitespaces
    public func collapseWhiteSpaces() -> String {
        return components(separatedBy: CharacterSet.whitespacesAndNewlines)
            .filter { $0.isEmpty == false }
            .joined(separator: " ")
    }
    
    // MARK: - Prefix
    public func has(prefix: String) -> Bool {
        return self.hasPrefix(prefix)
    }
    
    public func remove(prefix: String) -> String {
        guard self.hasPrefix(prefix) else { return self }
        return String(self.dropFirst(prefix.count))
    }
    
    public func removePrefix(before: String, included: Bool = false) -> String {
        guard let index = self.firstIndex(of: before) else { return self }
        return self.substring(from: included == true ? index + 1 : index)
    }
    
    // MARK: - Suffix
    public func has(suffix: String) -> Bool {
        return self.hasSuffix(suffix)
    }
    
    public func remove(suffix: String) -> String {
        guard self.hasSuffix(suffix) else { return self }
        return String(self.dropLast(suffix.count))
    }
    /*
    public func removeSuffix(after: String, included: Bool = false) -> String {
        guard let index = self.lastIndex(of: after) else { return self }
        return self.substring(to: included == true ? index : index + 1)
    }
    */
    // MARK: - Trim
    public func trim(in set: CharacterSet = CharacterSet.whitespacesAndNewlines) -> String {
        return self.trimmingCharacters(in: set)
    }
    
    public func trimLeft(in set: CharacterSet = CharacterSet.whitespacesAndNewlines) -> String {
        return self.replace(regularExpression: "^\\s+", with: "")
    }
    
    public func trimRight(in set: CharacterSet = CharacterSet.whitespacesAndNewlines) -> String {
        return self.replace(regularExpression: "\\s+$", with: "")
    }
    
    // MARK: - Pad
    public func pad(_ string: String, times: Int) -> String {
        let pad = (0..<times).reduce("") {
            acc, value in
            "\(acc)\(string)"
        }
        return pad + self + pad
    }
    
    public func padLeft(_ string: String, times: Int) -> String {
        return (0..<times).reduce("") {
            acc, value in
            "\(acc)\(string)"
        } + self
    }
    
    public func padRight(_ string: String, times: Int) -> String {
        return self + (0..<times).reduce("") {
            acc, value in
            "\(acc)\(string)"
        }
    }
    
    // MARK: - Number of occurencies
    public func count(string: String) -> Int {
        return self.split(string).count - 1
    }
    
    // MARK: - Conversions
    public func toBool() -> Bool? {
        return Bool(self)
    }
    
    public func toInt() -> Int? {
        return Int(self)
    }
    
    public func toFloat() -> Float? {
        return Float(self)
    }
    
    public func toDouble() -> Double? {
        return Double(self)
    }
    
    // MARK: - Initials
    public var initials: String {
        return self.components(separatedBy: CharacterSet.init(charactersIn: " -_\n\r")).map {
            $0.substring(to: 1).capitalized
        }.join(" ")
    }
    
    // MARK: - Subscripts
    public subscript (bounds: CountableClosedRange<Int>) -> String {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return String(self[start...end])
    }

    public subscript (bounds: CountableRange<Int>) -> String {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return String(self[start..<end])
    }
    
    public subscript(i: Int) -> String {
        get {
            return self.substring(range: i..<i+1)
        }
    }
    
    // MARK: - contain Invalid Characters
    public func containInvalidCharacters() -> Bool {
        let invalidCharacterSet: String = #"/\\*?"<>|:"#
        let uniCodes = "\u{201c}\u{201d}\u{2044}\u{2039}\u{203A}\u{204E}"  // UnicodeScalar /\*?"<>|:
        // \u{201d}: Right Quotation marks "
        // \u{201c}: Left Quotation marks "
        // \u{2044}: Slash /
        // \u{2039}: Guillemets <
        // \u{203A}: Guillemets >
        // \u{204E}: The asterisk *
        let returnValue = self.range(of: "[\(invalidCharacterSet)\(uniCodes)]", options: .regularExpression)
//        let range = NSRange(location: 0, length: self.utf16.count)
//        let regex = try! NSRegularExpression(pattern: "[\(invalidCharacterSet)]")
//        let returnValue = regex.firstMatch(in: self, options: [.], range: range) != nil
        return (returnValue != nil)
    }
}

/// String syntax sugar extension
extension String {
    var ns: NSString {
        return self as NSString
    }
    var lastPathComponent: String {
        return ns.lastPathComponent
    }
    var stringByDeletingPathExtension: String {
        return ns.deletingPathExtension
    }
}

extension Array where Element == String {
    public func join(_ separator: String) -> String {
        return self.joined(separator: separator)
    }
}

extension Substring {
    public var string: String {
        return String(self)
    }
}
