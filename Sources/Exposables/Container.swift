//
//  Container.swift
//  
//
//  Created by Noah Pikielny on 6/22/23.
//

import SwiftUI

public class ExposableContainer: ObservableObject {
    @Published public var state = Update()
    var view: AnyView? = nil
    
    public init() {}
    
    public func compile(_ mirror: Mirror) -> some View {
        if let view = view { return view }
        let vw = AnyView(mirror.stackExposedViews(mirror))
        self.view = vw
        return vw
    }
    
    func compile(exposed: [any ExposedParameter]) -> some View {
        if let view = view { return view }
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
    func stackExposedViews(_ mirror: Mirror) -> some View {
        let exposed = mirror.children
            .compactMap {
                if let exposed = $0.value as? ErasedParameter {
                    let wrapped = exposed.wrapped
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
