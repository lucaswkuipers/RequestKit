import Foundation

extension URL?: ExpressibleByStringLiteral,
                ExpressibleByUnicodeScalarLiteral,
                ExpressibleByExtendedGraphemeClusterLiteral {
    public init(stringLiteral value: StringLiteralType) {
        self = URL(string: value)
    }
}
