import Foundation
import PackagePlugin

@main
struct CountSourceLines : CommandPlugin {
    // Entry
    func performCommand(context: PluginContext, arguments: [String]) async throws {
        let swiftSourceModuleTargets = context.package.allTargets
        // Iterate over the Swift source module targets we were given.
        for (_, target) in swiftSourceModuleTargets.enumerated() {
            var allSourceFiles: Set<URL> = []
            
            let dirURL = URL(fileURLWithPath: target.directory.string)
            if let enumerator = FileManager.default.enumerator(at: dirURL, includingPropertiesForKeys: [.isRegularFileKey], options: [.skipsHiddenFiles]) {
                for case let fileURL as URL in enumerator {
                    let fileAttributes = try fileURL.resourceValues(forKeys:[.isRegularFileKey])
                    // Filter only file with extensions
                    if let isRegularFile = fileAttributes.isRegularFile, isRegularFile {
                        if CountSourceLines.languageExtensions[fileURL.pathExtension] != nil {
                            allSourceFiles.insert(fileURL)
                        }
                    }
                }
            }
            
            // Calculate in parallels
            let languageLines = await withTaskGroup(of: (String, Int).self, returning: [String : Int].self) { group in
                var languageLines: [String: Int] = [:]
                for sourceFile in allSourceFiles {
                    group.addTask {
                        let language = CountSourceLines.languageExtensions[(sourceFile.pathExtension)] ?? "Unknown"
                        let line = await calculateLines(fileURL: sourceFile)
                        return (language, line)
                    }
                }
                
                for await (language, line) in group {
                    languageLines[language] = (languageLines[language] ?? 0) + line
                }
                
                return languageLines
            }
            
            // Print result
            if (false) {
                try await printGUI(target: target, languageLines: languageLines)
            } else {
                try await printCLI(target: target, languageLines: languageLines)
            }
        }
    }
    
    func printGUI(target: Target, languageLines: [String : Int]) async throws {
        // Current Package Plugin use sandbox-exec to launch, and disable the system services
        // So now, it can not launch any GUI part
        return
//        let configuration = NSWorkspace.OpenConfiguration()
//        configuration.arguments = ["Hello World"]
//        try await NSWorkspace.shared.openApplication(at: URL(fileURLWithPath: "/Users/lizhuoli/Downloads/Notification.app"), configuration: configuration)
//        NSWorkspace.shared.launchApplication("Finder")

//        let process = Process()
////        process.executableURL = URL(fileURLWithPath: "/usr/bin/osascript")
//        process.executableURL = URL(fileURLWithPath: "/bin/sh")
//
//        let title = "Count Source Lines"
//        for (language, line) in languageLines {
//            let message = """
//--- Target: \(target.name) ---
//Language: \(language), lines: \(line)
//"""
//            process.arguments = ["-c", "osascript -e 'display notification 123'"]
//
////            let script = NSAppleScript(source: "display notification \"Hello\"")
////            script?.executeAndReturnError(nil)
////            let command = "display notification \"hello\""
//////            \"Hello\"  with title \"\(title)\""
////            process.arguments = ["-e", command]
//            try process.run()
//        }
    }
    
    func printCLI(target: Target, languageLines: [String : Int]) async throws {
        print("--- Target: \(target.name) ---")
        for (language, line) in languageLines {
            print("Language: \(language), lines: \(line)")
        }
    }
    
    func calculateLines(fileURL: URL) async -> Int {
        // Mapped for speed
        guard let data = try? Data(contentsOf: fileURL, options: [.mappedIfSafe]) else {
            return 0
        }
        guard let string = String(data: data, encoding: .utf8) else {
            return 0
        }
        let line = string.components(separatedBy: .newlines).count
        if line > 0 {
            return line - 1
        } else {
            return 0
        }
    }
    
    // Hardcode for current demo
    static let languageExtensions: [String : String] = ["swift": "Swift",
                                                        "c": "C",
                                                        "cc": "C++",
                                                        "m": "Objective-C",
                                                        "mm": "Objective-C++",
                                                        "h": "C/C++ Header",
                                                        "hpp": "C++",
                                                        "cpp": "C++"]
}
