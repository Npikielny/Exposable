//
//  ExposedParameter.swift
//
//  Created by Noah Pikielny on 6/17/23.
//
import SwiftUI

@propertyWrapper public class Expose<T: Exposable>: ExposedParameter, ObservableObject {
    public let title: String?
    public var wrappedValue: T
    public let id = UUID()
    @Published public var state = Update()
    let settings: T.Settings?
    
    public init(wrappedValue: T, title: String? = nil, settings: T.Settings? = nil) {
        self.wrappedValue = wrappedValue
        self.title = title
        self.settings = settings
    }
    
    public func makeView() -> some View {
        T.Interface(settings, title: title, wrappedValue: self)
    }
    
    public var display: AnyView? {
        T.display(self)
    }
}

public protocol ExposableInterface: View {
    associatedtype ParameterType: Exposable
    
    var title: String? { get }
    var wrappedValue: Expose<ParameterType> { get }
    
    init(_ settings: ParameterType.Settings?, title: String?, wrappedValue: Expose<ParameterType>)
}

extension ExposableInterface {
    public var state: Update { wrappedValue.state }
    public var updateBinding: Binding<ParameterType> {
        Binding(
            get: { wrappedValue.wrappedValue },
            set: {
                wrappedValue.wrappedValue = $0
                wrappedValue.state.send()
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
    
    static func display(_ exposed: Expose<Self>) -> AnyView?
}

extension Exposable {
    static public func display(_ exposed: Expose<Self>) -> AnyView? { nil }
}

public struct ExposedWrapper: View {
    let id: UUID
    let input: any ExposedParameter
    @StateObject var state: Update
    var title: String? { input.title }
    
    init(input: any ExposedParameter) {
        self.id = input.id
        self.input = input
        self._state = StateObject(wrappedValue: input.state)
    }
    
    public var body: some View { AnyView(input.makeView()) }
    var display: AnyView? { input.display }
}

public protocol ExposedParameter: ErasedParameter {
    var id: UUID { get }
    var title: String? { get }
    associatedtype Interface: View
    var state: Update { get }
    func makeView() -> Interface
    var display: AnyView? { get }
}

public protocol ErasedParameter: AnyObject {
    var wrapped: ExposedWrapper { get }
}

extension ExposedParameter {
    public var wrapped: ExposedWrapper { ExposedWrapper(input: self) }
}
