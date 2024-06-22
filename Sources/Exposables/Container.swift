//
//  Container.swift
//  
//
//  Created by Noah Pikielny on 6/22/23.
//

import SwiftUI

public class ExposableContainer: ObservableObject {
    @Published public var state = Update()
    var view: (ExposedWrapperSet)? = nil
    
    var displayMethod: Display
    
    public init(displayMethod: Display = .inline) {
        self.displayMethod = displayMethod
    }
    
    public func compile(_ mirror: Mirror) -> some View {
        if let view = view { return view }
        
        let exposed = mirror.children
            .compactMap {
                if let exposed = $0.value as? ErasedParameter {
                    let wrapped = exposed.wrapped
                    return wrapped
                }
                return nil
            }
        
        let vw = construct(exposed: exposed)
        self.view = vw
        return vw
    }

    public func compile(exposed: [any ExposedParameter]) -> some View {
        if let view { return view }
        let vw = construct(exposed: exposed.map(\.wrapped))
        self.view = vw
        return vw
    }
    
    public func compile<T: View, K: View>(
        mirror: Mirror,
        customDisplay: () -> T,
        layout: (ExposedWrapperSet, T) -> K
    ) -> K {
        let custom = customDisplay()
        if let view {
            return layout(view, custom)
        }
        
        let exposed = mirror.children
            .compactMap {
                if let exposed = $0.value as? ErasedParameter {
                    let wrapped = exposed.wrapped
                    return wrapped
                }
                return nil
            }
        
        let vw = construct(exposed: exposed)
        self.view = vw
        return layout(vw, custom)
    }
    
    public func compile<T: View, K: View>(
        exposed: [any ExposedParameter],
        customDisplay: () -> T,
        layout: (ExposedWrapperSet, T) -> K
    ) -> K {
        let custom = customDisplay()
        if let view {
            return layout(view, custom)
        }
        let vw = construct(exposed: exposed.map(\.wrapped))
        self.view = vw
        return layout(vw, custom)
    }
    
    private func construct(exposed: [ExposedWrapper]) -> ExposedWrapperSet {
        ExposedWrapperSet(exposed: exposed, displayMethod: displayMethod)
    }
    
    public enum Display {
        case inline
        case separated
        case none
        case onlyDisplay
    }
    
    public struct ExposedWrapperSet: View {
        let exposed: [ExposedWrapper]
        let displayMethod: Display
        
        public var body: some View {
            switch displayMethod {
                case .none:
                    VStack {
                        ForEach(exposed, id: \.id) {
                            $0.padding()
                        }
                    }
                case .separated:
                    VStack {
                        ForEach(exposed, id: \.id) {
                            $0.padding()
                        }
                        Divider()
                        ForEach(exposed, id: \.id) {
                            if let display = $0.display { display.padding() }
                        }
                    }
                case .inline:
                    VStack {
                        ForEach(exposed, id: \.id) {
                            $0.padding()
                            if let display = $0.display { display.padding() }
                        }
                    }
                case .onlyDisplay: info
                    
            }
        }
        
        var info: some View {
            VStack {
                ForEach(exposed, id: \.id) {
                    if let display = $0.display {
                        infoView(display: display, exposed: $0)
                    }
                }
            }
        }
        
        func infoView(display: AnyView, exposed: ExposedWrapper) -> some View {
            HStack {
                if let title = exposed.title {
                    Text(title)
                }
                display
            }
        }
    }
    
}
