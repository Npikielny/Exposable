//
//  Color.swift
//  
//
//  Created by Noah Pikielny on 6/22/23.
//

import SwiftUI

public struct ExposableColor: Exposable {
    var color: SIMD3<Double>
    public struct Settings {
        let name: String
    }
    
    public struct Interface: ExposableInterface {
        public var wrappedValue: Expose<ExposableColor>
        let settings: Settings?
        public init(_ settings: ExposableColor.Settings?, wrappedValue: Expose<ExposableColor>) {
            self.settings = settings
            self.wrappedValue = wrappedValue
        }
        
        public typealias ParameterType = ExposableColor
        
        
        
        public var body: some View {
            VStack {
                if let name = settings?.name {
                    Text(name)
                }
                GeometryReader { geometry in
                    let side = max(min(geometry.size.width, geometry.size.height) / 2 - 10, 10)
                    HStack {
                        VStack {
                            ForEach(Array(["Red", "Green", "Blue"].enumerated()), id: \.offset) { (index, name) in
                                NumberField(range: 0.0...1.0, title: name, value: Binding<Double>(get: {
                                    wrappedValue.wrappedValue.color[index]
                                }, set: { newValue in
                                    wrappedValue.wrappedValue.color[index] = newValue
                                    wrappedValue.state.send()
                                }))
                            }
                        }
                        let color = wrappedValue.wrappedValue.color
                        Circle()
                            .foregroundColor(Color(red: Double(color.x), green: Double(color.y), blue: Double(color.z)))
                            .frame(width: side, height: side, alignment: .center)
                    }
                }
            }
        }
        
        
    }

    
    
}

extension Color {
    static var windowBackground: Color {
        if #available(macOS 12.0, *) {
            return Color(nsColor: .windowBackgroundColor)
        } else {
            return Color.black.opacity(0.1)
        }
    }
    
    static func optionalColor(_ color: NSColor, fallback: Color = .clear) -> Color {
        if #available(macOS 12.0, *) {
            return Color(nsColor: color)
        } else {
            return fallback
        }
    }
}
