//
//  Container.swift
//  
//
//  Created by Noah Pikielny on 6/22/23.
//

import SwiftUI

public class ExposableContainer: ObservableObject {
    @Published public var state: Update
    var view: AnyView?
    
    public init(parent: Update? = nil) {
        self.state = Update(parent: parent)
    }
    
    public func compile(_ mirror: Mirror) -> some View {
        if let view = view { return view }
        let vw = AnyView(mirror.stackExposedViews(mirror, state))
        self.view = vw
        return vw
    }
    
    func compile(exposed: [any ExposedParameter]) -> some View {
        if let view = view { return view }
        exposed.forEach { $0.state.parent = state }
        let vw = AnyView(VStack {
            ForEach(exposed.map(\.wrapped), id: \.id) {
                $0
            }
        })
        self.view = vw
        return vw
    }
}

extension Mirror {
    func stackExposedViews(_ mirror: Mirror, _ state: Update) -> some View {
        let exposed = mirror.children
            .compactMap {
                if let exposed = $0.value as? ErasedParameter {
                    let wrapped = exposed.wrapped
                    wrapped.state.parent = state
                    return wrapped
                }
                return nil
            }
        
        return VStack {
            ForEach(exposed, id: \.id) {
                $0
            }
        }
    }
}
