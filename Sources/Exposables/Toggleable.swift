//
//  Toggleable.swift
//  
//
//  Created by Noah Pikielny on 7/6/23.
//

import SwiftUI

public struct ToggleInterface<ParameterType: ToggleExposable>: ExposableInterface  {
    public let title: String?
    public let wrappedValue: Expose<ParameterType>
    
    @StateObject var update = Update()
    let containers: [String: ExposableContainer]
    
    public init(_ settings: ParameterType.Settings?, title: String? = nil, wrappedValue: Exposables.Expose<ParameterType>) {
        self.wrappedValue = wrappedValue
        self.title = title
        
        containers = [String: ExposableContainer](
            uniqueKeysWithValues: ParameterType.defaults.map {
                ($0.optionLabel, ExposableContainer(displayMethod: .none))
            }
        )
    }
    
    public var body: some View {
        VStack(alignment: .leading) {
            let title = title == nil ? "" : "\((title)!):"

            Picker(title, selection: updateBinding) {
                ForEach(ParameterType.defaults, id: \.optionLabel) {
                    Text($0.optionLabel)
                        .tag($0)
                }
            }
            
            containers[wrappedValue.wrappedValue.optionLabel]!
                .compile(exposed: wrappedValue.wrappedValue.subproperties)
        }.padding(.vertical)
    }
}

public protocol ToggleExposable: Exposable, Hashable, Equatable
where Settings == ()
{
    /// Label to be displayed per option
    var optionLabel: String { get }
    static var defaults: [Self] { get }
    var subproperties: [any ExposedParameter] { get }
}

extension ToggleExposable {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.optionLabel == rhs.optionLabel
    }
    
    public func hash(into hasher: inout Hasher) {
        optionLabel.hash(into: &hasher)
    }
}
