//
//  ViewController.swift
//  vtableAndMessageDispatch
//
//  Created by Chun-Li Cheng on 2023/8/22.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let base: Showable = Base()
        base.show()  // 輸出：This is base protocol.

        let derived: Showable = Derived()
        derived.show()         // 輸出：This is base protocol.
//        if let someDerived = derived as? Derived {
//            someDerived.show() // 輸出：This is derived class.
//            someDerived.fun()
//        }
        print()
        
        // 替換方法
        let method = class_getInstanceMethod(MyClass.self, #selector(MyClass.originalMethod))
//        let originalImplementation = method_getImplementation(method!)
        
        let myObject = MyClass()
        myObject.originalMethod()  // Prints: "This is the original method"
        
//        let newImplementationBlock: @convention(block) (AnyObject) -> Void = { _ in
//            print("This is the replacement method")
//        }
        
        let newImplementationBlock: @convention(block) (String) -> Void = { (stringValue) in
            print("This is the replacement method\(stringValue)")
        }
        let newImplementation = imp_implementationWithBlock(newImplementationBlock)

        method_setImplementation(method!, newImplementation)
        
        myObject.originalMethod()  // Prints: "This is the replacement method"
    }


}

protocol Showable {
    func show()
}

extension Showable {
    func show() {
        print("This is base protocol.")
    }
}

class Base: Showable {
//    func show() {
//        print("This is base protocol.")
//    }
}

class Derived: Base {
    func show() {
        print("This is derived class.")
    }
    func fun() {
        print("123")
    }
    
}

class MyClass: NSObject {
    @objc dynamic func originalMethod() {
        print("This is the original method")
    }
}

