import Foundation
import PackagePlugin

extension Package {
    /// Any targets defined in this package and its dependencies.
    var allTargets: [Target] {
        var insertedTargetIds = Set<Target.ID>()
        var relevantTargets = [Target]()
        
        func addTargets(_ targets: [Target]) {
            for target in targets {
                guard !insertedTargetIds.contains(target.id) else {
                    continue
                }
                
                relevantTargets.append(target)
                insertedTargetIds.insert(target.id)
            }
        }
        
        func addTargetDependencies(_ target: Target) {
            for dependency in target.dependencies {
                switch dependency {
                case .product(let product):
                    addTargets(product.targets)
                case .target(let target):
                    addTargets([target])
                #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                @unknown default:
                    return
                #endif
                }
            }
        }
        
        // Begin by adding the targets defined in the products
        // vended by this package as these are the most likely to be documented.
        for product in products {
            addTargets(product.targets)
        }
        
        // Then add the remaining targets defined in this package
        addTargets(targets)
        
        // Make a copy of al the targets directly defined in this package
        let topLevelTargets = relevantTargets
        
        // Iterate through them and add their dependencies. This ensures
        // that we always list targets defined in the package before
        // any we depend on from other packages.
        for topLevelTarget in topLevelTargets {
            addTargetDependencies(topLevelTarget)
        }
        
        return relevantTargets
    }
}
