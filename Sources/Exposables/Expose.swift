//
//  ExposedParameter.swift
//
//  Created by Noah Pikielny on 6/17/23.
//
import SwiftUI

@propertyWrapper public class Expose<T: Exposable>: ExposedParameter, ObservableObject {
    public var wrappedValue: T
    public let id = UUID()
    @Published public var state = Update()
    let settings: T.Settings?
    
    public init(wrappedValue: T, settings: T.Settings? = nil) {
        self.wrappedValue = wrappedValue
        self.settings = settings
    }
    
    func makeView(_ state: Update) -> some View {
        T.Interface(settings, wrappedValue: self)
    }
}

extension Expose where T: DisplayableParameter {
    public func display() -> some View {
        ExposeDisplay(exposed: self)
    }
}

public protocol ExposableInterface: View {
    associatedtype ParameterType: Exposable
    
    var wrappedValue: Expose<ParameterType> { get }
    
    init(_ settings: ParameterType.Settings?, wrappedValue: Expose<ParameterType>)
}

extension ExposableInterface {
    public var state: Update { wrappedValue.state }
    public var updateBinding: Binding<ParameterType> {
        Binding(
            get: { wrappedValue.wrappedValue },
            set: {
                wrappedValue.wrappedValue = $0
                wrappedValue.state.objectWillChange.send()
            }
        )
    }
    
    public var binding: Binding<ParameterType> {
        Binding(
            get: { wrappedValue.wrappedValue },
            set: { wrappedValue.wrappedValue = $0 }
        )
    }
}

public protocol Exposable {
    associatedtype Settings
    associatedtype Interface: ExposableInterface where Interface.ParameterType == Self
}

struct ExposedWrapper: View {
    let id: UUID
    let input: any ExposedParameter
    @StateObject var state: Update
    
    init(input: any ExposedParameter) {
        self.id = input.id
        self.input = input
        self._state = StateObject(wrappedValue: input.state)
    }
    
    var body: some View { AnyView(input.makeView(state)) }
}

protocol ExposedParameter: ErasedParameter {
    var id: UUID { get }
    associatedtype Interface: View
    var state: Update { get }
    func makeView(_ state: Update) -> Interface
}

protocol ErasedParameter: AnyObject {
    var wrapped: ExposedWrapper { get }
}

extension ExposedParameter {
    var wrapped: ExposedWrapper { ExposedWrapper(input: self) }
}
