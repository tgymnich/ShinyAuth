//
//  ErrorView.swift
//  ShinyAuth
//
//  Created by Tim Gymnich on 25.08.20.
//

import SwiftUI

protocol ErrorHandler {
    func handle<T: View>(_ error: Error?, in view: T, errorHandler: @escaping () -> Void) -> AnyView
}

struct AlertErrorHandler: ErrorHandler {
    private let id = UUID()
    
    struct Presentation: Identifiable {
        let id: UUID
        let error: Error
        let errorHandler: () -> Void
    }
    
    func makeAlert(for presentation: Presentation) -> Alert {
        let error = presentation.error
        
        return Alert(title: Text("An error occured"),
                     message: Text(error.localizedDescription),
                     dismissButton: .default(Text("Dismiss"), action: presentation.errorHandler))
    }
    
    func handle<T: View>(_ error: Error?, in view: T, errorHandler: @escaping () -> Void) -> AnyView {
        var presentation = error.map { Presentation(
            id: id,
            error: $0,
            errorHandler: errorHandler
        )}
        
        // We need to convert our model to a Binding value in
        // order to be able to present an alert using it:
        let binding = Binding(
            get: { presentation },
            set: { presentation = $0 }
        )
        
        return AnyView(view.alert(item: binding, content: makeAlert))
    }
}

struct ErrorHandlerEnvironmentKey: EnvironmentKey {
    static var defaultValue: ErrorHandler = AlertErrorHandler()
}

extension EnvironmentValues {
    var errorHandler: ErrorHandler {
        get { self[ErrorHandlerEnvironmentKey.self] }
        set { self[ErrorHandlerEnvironmentKey.self] = newValue }
    }
}

extension View {
    func handlingErrors(using handler: ErrorHandler) -> some View {
        environment(\.errorHandler, handler)
    }
}

struct ErrorEmittingViewModifier: ViewModifier {
    @Environment(\.errorHandler) var handler
    var error: Error?
    var errorHandler: () -> Void

    func body(content: Content) -> some View {
        handler.handle(error, in: content, errorHandler: errorHandler)
    }
}

extension View {
    func emittingError(_ error: Error?, errorHandler: @escaping () -> Void) -> some View {
        modifier(ErrorEmittingViewModifier(error: error, errorHandler: errorHandler))
    }
}
