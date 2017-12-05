//
//  ClassInfo.swift
//  DIMockServer
//
//  Created by Piotr Adamczak on 03.07.2017.
//  Copyright © 2017 DigitalIndiana. All rights reserved.
//

import Foundation

struct ClassInfo : CustomStringConvertible, Equatable {
    let classObject: AnyClass
    let className: String
    
    init?(_ classObject: AnyClass?) {
        guard classObject != nil else { return nil }
        
        self.classObject = classObject!
        
        let cName = class_getName(classObject)!
        self.className = String(cString: cName)
    }
    
    var superClassInfo: ClassInfo? {
        let superClassObject: AnyClass? = class_getSuperclass(self.classObject)
        return ClassInfo(superClassObject)
    }
    
    var description: String {
        return self.className
    }
    
    var nameInNamespace : String? {
        let classNameComponents = self.className.components(separatedBy: ".")
        return classNameComponents.last
    }
    
    static func ==(lhs: ClassInfo, rhs: ClassInfo) -> Bool {
        return lhs.className == rhs.className
    }
    
    static func subclassList(for aClass:AnyClass) -> [ClassInfo] {
        
        let motherClassInfo = ClassInfo(aClass)!
        var subclassList = [ClassInfo]()
        
        var count = UInt32(0)
        let classList = objc_copyClassList(&count)!
        
        for i in 0..<Int(count) {
            if let classInfo = ClassInfo(classList[i]),
               let superClassInfo = classInfo.superClassInfo,
                   superClassInfo == motherClassInfo
            {
                subclassList.append(classInfo)
            }
        }

        return subclassList
    }
}
