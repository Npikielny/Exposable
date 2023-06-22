//
//  Container.swift
//  
//
//  Created by Noah Pikielny on 6/22/23.
//

import SwiftUI

class ExposableContainer: ObservableObject {
    @Published var state = Update()
    var view: AnyView?
    
    func compile(_ mirror: Mirror) -> some View {
        if let view = view { return view }
        let vw = AnyView(mirror.stackExposedViews(mirror, state: state))
        self.view = vw
        return vw
    }
}

extension Mirror {
    func stackExposedViews(_ mirror: Mirror, state: Update) -> some View {
        let exposed = mirror.children
            .compactMap {
                if let exposed = $0.value as? ErasedParameter {
                    return exposed.wrapped
                }
                return nil
            }
        
        return VStack {
            ForEach(exposed, id: \.id) {
                let _ = print($0.id)
                $0
            }
        }
    }
}
