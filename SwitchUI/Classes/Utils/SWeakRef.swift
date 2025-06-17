//
//  SWeakRef.swift
//  SWEasyLanguage-Online
//
//  Created by swain wang on 2024/6/13.
//

import Foundation

class SWeakRef<T> where T: AnyObject {

    private(set) weak var value: T?

    init(value: T?){
        self.value=value
    }
}
