//
//  NumberField.swift
//  
//
//  Created by Noah Pikielny on 6/22/23.
//

import SwiftUI

public struct NumberField<Number: Numeric & Comparable>: View {
    var range: ClosedRange<Number>? = nil
    var title: String?
    var formatter: NumberFormatter
    @Binding var value: Number
    @Binding var preprocessed: Number
    
    init(
        range: ClosedRange<Double>? = nil,
        title: String? = nil,
        value: Binding<Double>
    ) where Number == Double {
        self.range = range
        self.title = title
        _value = value
        formatter = .doubleFormatter
        _preprocessed = Binding(get: {
            value.wrappedValue
        }, set: { v in
            if let range = range {
                value.wrappedValue = range.clamp(value: v)
            } else {
                value.wrappedValue = v
            }
        })
    }
    
    init(
        range: ClosedRange<Int>? = nil,
        title: String? = nil,
        value: Binding<Int>
    ) where Number == Int {
        self.range = range
        self.title = title
        _value = value
        _preprocessed = Binding(get: {
            value.wrappedValue
        }, set: { v in
            if let range = range {
                value.wrappedValue = range.clamp(value: v)
            } else {
                value.wrappedValue = v
            }
        })
        formatter = .intFormatter
    }
    
    public var body: some View {
        HStack {
            if let title = title {
                Text(title + ":")
                Spacer()
            }
            TextField("", value: $value, formatter: formatter)
                .textFieldStyle(.plain)
                .frame(width: 50)
                .padding(5)
                .cornerRadius(5)
            Stepper("") {
                value += 1
            } onDecrement: {
                value -= 1
            }

        }
    }
}

extension NumberFormatter {
    static let intFormatter = NumberFormatter()
    static let doubleFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.alwaysShowsDecimalSeparator = true
        return formatter
    }()
}

extension ClosedRange {
    func clamp(value: Bound) -> Bound {
        Swift.max(Swift.min(value, upperBound), lowerBound)
    }
}

struct NumberInput_Previews: PreviewProvider {
    static var previews: some View {
        NumberField(title: "Chunks", value: .constant(1.0))
        NumberField(value: .constant(1))
    }
}

