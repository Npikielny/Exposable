//
//  NumericField.swift
//  
//
//  Created by Noah Pikielny on 6/22/23.
//

import SwiftUI

public protocol NumericExposable: Comparable & Numeric & Exposable, DisplayableParameter {
    static func numberField(settings: ClosedRange<Self>?, title: String?, value: Binding<Self>) -> NumberField<Self>
    static func numberSlider(settings: ClosedRange<Self>, title: String?, value: Binding<Self>) -> NumberSlider<Self>
}

public enum NumericSettings<Number: Comparable> {
    case stepper(_ range: ClosedRange<Number>?)
    case slider(_ range: ClosedRange<Number>)
}

public struct NumberFieldInterface<ParameterType: NumericExposable>: ExposableInterface where ParameterType.Settings == NumericSettings<ParameterType> {
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
        switch settings {
            case let .slider(range):
                ParameterType.numberSlider(settings: range, title: title, value: updateBinding)
            case let .stepper(range):
                ParameterType.numberField(settings: range, title: title, value: updateBinding)
            case .none:
                ParameterType.numberField(settings: nil, title: title, value: updateBinding)
        }
    }
}

extension Double: NumericExposable {
    public struct DisplayInterface: ExposableDisplayInterface {
        var parameter: Double
        public init(_ parameter: Double) {
            self.parameter = parameter
        }
        
        public var body: some View {
            Text("\(parameter)")
        }
    }
    
    public static func numberField(settings: ClosedRange<Double>?, title: String?, value: Binding<Double>) -> NumberField<Double> {
        NumberField(range: settings, title: title, value: value)
    }
    
    public static func numberSlider(settings: ClosedRange<Double>, title: String?, value: Binding<Double>) -> NumberSlider<Double> {
        NumberSlider(range: settings, formatter: .doubleFormatter, value: value, preprocessed: value)
    }
    
    public typealias Settings = NumericSettings<Double>
    public typealias Interface = NumberFieldInterface<Self>
}

extension Int: NumericExposable {
    public struct DisplayInterface: ExposableDisplayInterface {
        var parameter: Int
        public init(_ parameter: Int) {
            self.parameter = parameter
        }
        
        public var body: some View {
            Text("\(parameter)")
        }
    }
    
    public static func numberField(settings: ClosedRange<Int>?, title: String?, value: Binding<Int>) -> NumberField<Int> {
        NumberField(range: settings, title: title, value: value)
    }
    
    public static func numberSlider(settings: ClosedRange<Int>, title: String?, value: Binding<Int>) -> NumberSlider<Int> {
        let binding = Binding {
            Double(value.wrappedValue)
        } set: { newValue in
            value.wrappedValue = Int(newValue)
        }

        return NumberSlider<Int>(
            range: Double(settings.lowerBound)...Double(settings.upperBound),
            formatter: .intFormatter,
            value: binding,
            preprocessed: value
        )
    }
    
    public typealias Settings = NumericSettings<Int>
    public typealias Interface = NumberFieldInterface<Self>
}
