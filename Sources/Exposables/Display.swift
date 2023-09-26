//
//  Display.swift
//  
//
//  Created by Noah Pikielny on 8/4/23.
//

import SwiftUI

@propertyWrapper
struct Display<T, K: View>: View {
    var wrappedValue: () -> T
    
    var display: (T) -> K
    
    var body: some View {
        display(wrappedValue())
    }
}
