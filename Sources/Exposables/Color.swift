//
//  Color.swift
//  
//
//  Created by Noah Pikielny on 6/22/23.
//

import SwiftUI

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
