//
//  NumericField.swift
//  
//
//  Created by Noah Pikielny on 6/22/23.
//

import SwiftUI

public protocol NumericExposable: Comparable & Numeric & Exposable {
    static func numberField(settings: Settings?, title: String?, value: Binding<Self>) -> NumberField<Self>
}

public struct NumberFieldInterface<ParameterType: NumericExposable>: ExposableInterface where ParameterType.Settings == ClosedRange<ParameterType> {
    public let title: String?
    public let wrappedValue: Expose<ParameterType>
    public let settings: ParameterType.Settings?
    @StateObject var state: Update
    public init(_ settings: ParameterType.Settings?, title: String?, wrappedValue: Expose<ParameterType>) {
        self.wrappedValue = wrappedValue
        self.settings = settings
        self._state = StateObject(wrappedValue: wrappedValue.state)
        self.title = title
    }
    
    public var body: some View {
        ParameterType.numberField(settings: settings, title: title,  value: updateBinding)
    }
}

extension Double: NumericExposable {
    public static func numberField(settings: Settings?, title: String?, value: Binding<Double>) -> NumberField<Double> {
        NumberField(range: settings, title: title, value: value)
    }
    
    public typealias Settings = ClosedRange<Double>
    public typealias Interface = NumberFieldInterface<Self>
}

extension Int: NumericExposable {
    public static func numberField(settings: Settings?, title: String?, value: Binding<Int>) -> NumberField<Int> {
        NumberField(range: settings, title: title, value: value)
    }
    
    public typealias Settings = ClosedRange<Int>
    public typealias Interface = NumberFieldInterface<Self>
}
