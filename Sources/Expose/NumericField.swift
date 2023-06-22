//
//  NumericField.swift
//  
//
//  Created by Noah Pikielny on 6/22/23.
//

import SwiftUI

public struct NumericSettings<T: Numeric & Comparable> {
    let range: ClosedRange<T>?
    let title: String?
}

public protocol NumericExposable: Comparable & Numeric & Exposable {
    static func numberField(settings: Settings?, value: Binding<Self>) -> NumberField<Self>
}

public struct NumberFieldInterface<ParameterType: NumericExposable>: ExposableInterface where ParameterType.Settings == NumericSettings<ParameterType> {
    public let wrappedValue: Expose<ParameterType>
    public let settings: ParameterType.Settings?
    @StateObject var state: Update
    public init(_ settings: ParameterType.Settings?, wrappedValue: Expose<ParameterType>) {
        self.wrappedValue = wrappedValue
        self.settings = settings
        self._state = StateObject(wrappedValue: wrappedValue.state)
    }
    
    public var body: some View {
        ParameterType.numberField(settings: settings, value: updateBinding)
    }
}

extension Double: NumericExposable {
    public static func numberField(settings: Settings?, value: Binding<Double>) -> NumberField<Double> {
        NumberField(range: settings?.range, title: settings?.title, value: value)
    }
    
    public typealias Settings = NumericSettings<Self>
    public typealias Interface = NumberFieldInterface<Self>
}

extension Int: NumericExposable {
    public static func numberField(settings: Settings?, value: Binding<Int>) -> NumberField<Int> {
        NumberField(range: settings?.range, title: settings?.title, value: value)
    }
    
    public typealias Settings = NumericSettings<Self>
    public typealias Interface = NumberFieldInterface<Self>
}
