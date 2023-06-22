# Expose

Package that facilitates linked properties with UI for user interaction.

 For any type that conforms to the `Exposable` protocol, tag variables in any `SwiftUI View` with the `@Expose` property wrapper. 
 These properties will be located by the `ExposableContainer` type when a Mirror of the view is passed to its compile function 
