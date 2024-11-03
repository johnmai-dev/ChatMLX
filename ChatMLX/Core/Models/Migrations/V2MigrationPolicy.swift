//
//  V2MigrationPolicy.swift
//  ChatMLX
//
//  Created by John Mai on 2024/10/14.
//

import CoreData

class V2MigrationPolicy: NSEntityMigrationPolicy {
    override func createDestinationInstances(forSource sInstance: NSManagedObject, in mapping: NSEntityMapping, manager: NSMigrationManager) throws {
        let sourceKeys = sInstance.entity.attributesByName.keys
        let sourceValues = sInstance.dictionaryWithValues(forKeys: sourceKeys.map { $0 as String })

        let destinationInstance = NSEntityDescription.insertNewObject(forEntityName: mapping.destinationEntityName!, into: manager.destinationContext)
        let destinationKeys = destinationInstance.entity.attributesByName.keys.map { $0 as String }

        for key in destinationKeys {
            if let value = sourceValues[key] {
                destinationInstance.setValue(value, forKey: key)
            }
        }

        if sourceValues["model"] is String {
            destinationInstance.setValue(nil, forKey: "model")
        }

        manager.associate(sourceInstance: sInstance, withDestinationInstance: destinationInstance, for: mapping)
    }
}
