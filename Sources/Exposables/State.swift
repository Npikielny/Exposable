//
//  State.swift
//  
//
//  Created by Noah Pikielny on 6/22/23.
//

import SwiftUI

public class Update: ObservableObject {
    var id = UUID()
    weak var parent: Update?
    
    init(parent: Update? = nil) {
        self.parent = parent
    }
    
    public func send() {
        parent?.send()
        objectWillChange.send()
    }
    
    public static func == (lhs: Update, rhs: Update) -> Bool { lhs.id == rhs.id }
}

extension Update: Hashable {
    public func hash(into hasher: inout Hasher) {
        id.hash(into: &hasher)
    }
}
