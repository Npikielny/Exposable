//
//  SwiftUIView.swift
//  
//
//  Created by Noah Pikielny on 6/22/23.
//

import SwiftUI

struct SwiftUIView: View {
    @Expose var message: String
    @Expose var background = ColorSelect.black
    @StateObject var container = ExposableContainer()
    
    init() {
        let exposed = Expose(wrappedValue: "", settings: "Insert message")
        self._message = exposed
    }
    
    @ViewBuilder
    func backgroundVStack(builder: @escaping () -> some View) -> some View {
        VStack {
            builder()
        }
        .background(background.color)
//        if case let .select(expose) = background {
//            VStack {
//                builder()
//            }
//            .background(expose.wrappedValue.color)
//        } else {
//            VStack {
//                builder()
//            }
//        }
    }
    
    var body: some View {
        let _ = print(background)
        VStack {
            Text("Hello, World!")
            container.compile(Mirror(reflecting: self))
            Text(message)
            _message.display()
        }
        .frame(width: 500, height: 300)
        .background(background.color)
        .padding()
    }
}

enum BackgroundSelect: ToggleExposable {
//    typealias Settings = ToggleSettings<BackgroundSelect>
    typealias Interface = ToggleInterface<BackgroundSelect>

    case none
    case select(Expose<ColorSelect>)

    var optionLabel: String {
        switch self {
            case .none: return "None"
            case .select: return "Select"
        }
    }

    static var defaults: [BackgroundSelect] {
        [
            .none,
            .select(Expose(wrappedValue: ColorSelect.black))
        ]
    }

    var subproperties: [any ExposedParameter] {
        switch self {
            case .none: return []
            case let .select(color): return [color]
        }
    }
}

enum ColorSelect: ToggleExposable {
    typealias Interface = ToggleInterface<ColorSelect>

    case red
    case blue
    case black
    case custom(Expose<ExposableColor>)

    var optionLabel: String {
        switch self {
            case .red: return "Red"
            case .blue: return "Blue"
            case .black: return "Black"
            case .custom(_): return "Custom"
        }
    }

    static var defaults: [ColorSelect] {
        [
            .red,
            .blue,
            .black,
            .custom(Expose(wrappedValue: ExposableColor(color: SIMD3<Double>(0, 1, 0))))
        ]
    }

    var subproperties: [any ExposedParameter] {
        switch self {
            case .red, .blue, .black: return []
            case let .custom(color): return [color]
        }
    }
    
    var color: Color {
        switch self {
            case .red: return Color.red
            case .blue: return Color.blue
            case .black: return Color.black
            case let .custom(exposed):
                let vec = exposed.wrappedValue.color
                return Color(
                    red: vec.x,
                    green: vec.y,
                    blue: vec.z
                )
        }
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
