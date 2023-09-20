
import SwiftUI

struct NamedPhoto: Identifiable, Codable, Comparable {
    let id: UUID
    var name: String
    
    static func <(lhs: NamedPhoto, rhs: NamedPhoto) -> Bool {
        lhs.name < rhs.name
    }
}
