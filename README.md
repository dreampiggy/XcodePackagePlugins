# XcodePackagePlugins

Collection of userful and intersting Xcode 14 [Package Plugins](https://developer.apple.com/videos/play/wwdc2022/110359/)

## Count Source Lines

Count the line of source code from the whole Swift Package. Supports Swift/Objective-C/C/C++ as well.

### Usage

```
swift package plugin count-source-lines
--- Target: XcodePackagePlugins ---
Language: Swift, lines: 6
--- Target: XcodePackagePluginsTests ---
Language: Swift, lines: 11
```

Example on [SDWebImageSwiftUI](https://github.com/SDWebImage/SDWebImageSwiftUI)

```
swift package plugin count-source-lines
--- Target: SDWebImageSwiftUI ---
Language: Swift, lines: 2286
--- Target: SDWebImage ---
Language: C/C++ Header, lines: 7551
Language: Objective-C, lines: 13344
```

## Regenerate Contributors List

Regenerate the list of all contributors into current package, write into the CONTRIBUTORS.txt file.

### Usage

```
swift package plugin --allow-writing-to-package-directory regenerate-contributors-list
Writing 1 contributors to /Users/lizhuoli/Documents/GitHub/XcodePackagePlugins/CONTRIBUTORS.txt
```
