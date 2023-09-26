//
//  ExposableDisplay.swift
//  
//
//  Created by Noah Pikielny on 6/22/23.
//

import SwiftUI

public protocol ExposableDisplayInterface: View {
    associatedtype ParameterType
    
    init(_ parameter: ParameterType)
}

public protocol DisplayableParameter: Exposable {
    associatedtype DisplayInterface: ExposableDisplayInterface where DisplayInterface.ParameterType == Self
}

extension DisplayableParameter {
    public static func display(_ exposed: Expose<Self>) -> AnyView? {
        AnyView(ExposeDisplay(exposed: exposed))
    }
}

struct ExposeDisplay<T: DisplayableParameter>: View {
    private let exposed: Expose<T>
    @ObservedObject var state: Update
    
    init(exposed: Expose<T>) {
        self.exposed = exposed
        self._state = ObservedObject(
            wrappedValue: exposed.state
        )
        
    }
    
    var body: some View {
        T.DisplayInterface(exposed.wrappedValue)
    }
}
