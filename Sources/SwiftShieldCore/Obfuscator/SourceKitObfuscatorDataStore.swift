import Foundation

enum ObfuscateType {
    case format
    case replace
    case random
}

final class SourceKitObfuscatorDataStore {
    var processedUsrs = Set<String>()
    var obfuscationDictionary = [String: String]()
    var obfuscatedNames = Set<String>()
    var usrRelationDictionary = [String: SKResponseDictionary]()
    var indexedFiles = [IndexedFile]()
    var plists = Set<File>()
    var inheritsFromX = [String: [String: Bool]]()
    var fileForUSR = [String: File]()
    var obfuscateFormat: String?
    
    func obfuscateType() -> ObfuscateType {
        guard let obfuscateFormat = self.obfuscateFormat else {
            return .random
        }
        if obfuscateFormat.contains("%rp") {
            return obfuscateFormat.components(separatedBy: "%rp").count == 2 ? .replace : .random
        }
        if obfuscateFormat.contains("%@") {
            return .format
        }
        return .random
    }
}
