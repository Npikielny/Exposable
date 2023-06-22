//
//  Display.swift
//  
//
//  Created by Noah Pikielny on 6/22/23.
//

import SwiftUI

public protocol ExposableDisplayInterface: View {
    associatedtype ParameterType
    
    init(_ parameter: ParameterType)
}

public protocol DisplayableParameter {
    associatedtype DisplayInterface: ExposableDisplayInterface where DisplayInterface.ParameterType == Self
}

struct ExposeDisplay<T: Exposable & DisplayableParameter>: View {
    private let exposed: Expose<T>
    @StateObject var state: Update
    
    init(exposed: Expose<T>) {
        self.exposed = exposed
        self._state = StateObject(
            wrappedValue: exposed.state
        )
        
    }
    
    var body: some View {
        T.DisplayInterface(exposed.wrappedValue)
    }
}
