//
//  Toggleable.swift
//  
//
//  Created by Noah Pikielny on 7/6/23.
//

import SwiftUI

public struct ToggleSettings<ParameterType: ToggleExposable> {
    let name: String
    let initialValue: ParameterType
}

public struct ToggleInterface<ParameterType: ToggleExposable>: ExposableInterface  {
    let settings: ParameterType.Settings?
    public var wrappedValue: Expose<ParameterType>
    
    @StateObject var update = Update()
    let containers: [String: ExposableContainer]
    
    public init(_ settings: ParameterType.Settings?, wrappedValue: Exposables.Expose<ParameterType>) {
        self.settings = settings
        self.wrappedValue = wrappedValue
        
        containers = [String: ExposableContainer](
            uniqueKeysWithValues: ParameterType.defaults.map {
                ($0.optionLabel, ExposableContainer())
            }
        )
    }
    
    public var body: some View {
        VStack(alignment: .leading) {
            let title = settings?.name == nil ? "" : "\((settings?.name)!):"

            Picker(title, selection: updateBinding) {
                ForEach(ParameterType.defaults, id: \.optionLabel) {
                    Text($0.optionLabel)
                        .tag($0)
                }
            }
            
            containers[wrappedValue.wrappedValue.optionLabel]!
                .compile(exposed: wrappedValue.wrappedValue.subproperties)
        }
    }
}

public protocol ToggleExposable: Exposable, Hashable, Equatable
where Settings == ToggleSettings<Self>
{
    /// Label to be displayed per option
    var optionLabel: String { get }
    static var defaults: [Self] { get }
    var subproperties: [any ExposedParameter] { get }
}

extension ToggleExposable {
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.optionLabel == rhs.optionLabel
    }
    
    func hash(into hasher: inout Hasher) {
        optionLabel.hash(into: &hasher)
    }
}
