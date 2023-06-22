//
//  State.swift
//  
//
//  Created by Noah Pikielny on 6/22/23.
//

import SwiftUI

public class Update: ObservableObject {
    var id = UUID()
    
    func send() {
        objectWillChange.send()
    }
    
    public static func == (lhs: Update, rhs: Update) -> Bool { lhs.id == rhs.id }
}

extension Update: Hashable {
    public func hash(into hasher: inout Hasher) {
        id.hash(into: &hasher)
    }
}
