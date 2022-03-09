import Foundation

public enum SwiftSwiftAssembler {
    public static func generate(
        projectPath: String,
        scheme: String,
        conversionMap: String?,
        obfuscateFormat: String?,
        modulesToIgnore: Set<String>,
        namesToIgnore: Set<String>,
        ignorePublic: Bool,
        dryRun: Bool,
        verbose: Bool,
        printSourceKitQueries: Bool
    ) -> SwiftShieldController {
        let logger = Logger(
            verbose: verbose,
            printSourceKit: printSourceKitQueries
        )

        let projectFile = File(path: projectPath)
        let taskRunner = TaskRunner()
        let infoProvider = SchemeInfoProvider(
            projectFile: projectFile,
            schemeName: scheme,
            taskRunner: taskRunner,
            logger: logger,
            modulesToIgnore: modulesToIgnore
        )

        let dataStore = SourceKitObfuscatorDataStore.init()
        if let mapPath = conversionMap {
            if let mapString = try? File(path: mapPath).read() {
                if let conversionMapObj = ConversionMap(mapString: mapString) {
                    dataStore.obfuscationDictionary = conversionMapObj.obfuscationDictionary
                    logger.log("--- Use old map file to obfuscate, map count = \(conversionMapObj.obfuscationDictionary.keys.count)")
                }
            }
        }
        
        dataStore.obfuscateFormat = obfuscateFormat
        
        let sourceKit = SourceKit(logger: logger)
        let obfuscator = SourceKitObfuscator(
            sourceKit: sourceKit,
            logger: logger,
            dataStore: dataStore,
            namesToIgnore: namesToIgnore,
            ignorePublic: ignorePublic
        )

        let interactor = SwiftShieldInteractor(
            schemeInfoProvider: infoProvider,
            logger: logger,
            obfuscator: obfuscator
        )

        return SwiftShieldController(
            interactor: interactor,
            logger: logger,
            dryRun: dryRun
        )
    }
}
