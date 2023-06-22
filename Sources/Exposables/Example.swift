//
//  SwiftUIView.swift
//  
//
//  Created by Noah Pikielny on 6/22/23.
//

import SwiftUI

struct SwiftUIView: View {
    @Expose var message: String
    @StateObject var container = ExposableContainer()
    
    init() {
        let exposed = Expose(wrappedValue: "", settings: "Insert message")
        self._message = exposed
    }
    
    var body: some View {
        VStack {
            Text("Hello, World!")
            container.compile(Mirror(reflecting: self))
            Text(message)
            _message.display()
        }
        .padding()
    }
}

extension Text: ExposableDisplayInterface {
    public typealias ParameterType = String
}

extension String: DisplayableParameter {
    public typealias DisplayInterface = Text
}

extension String: Exposable {
    public typealias Settings = String
    
    public struct Interface: ExposableInterface {
        public var wrappedValue: Expose<String>
        
        let title: Settings?
        @StateObject var state: Update
        public init(_ settings: String?, wrappedValue: Expose<String>) {
            title = settings
            self.wrappedValue = wrappedValue
            self._state = StateObject(wrappedValue: wrappedValue.state)
        }
        
        public typealias ParameterType = String
        
        
        
        public var body: some View {
            TextField(
                title ?? "",
                text: updateBinding
            )
        }
        
    }
    
    
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        SwiftUIView()
    }
}
