//
//  LoginViewModel.swift
//  MinhasFinancas
//
//  Created by edson lima on 13/02/26.
//

import Foundation
import Supabase

enum ValidationType {
    case login
    case register
}

@MainActor
class AuthViewModel {

    func login(email: String, password: String) async throws {
        try await supabase.auth.signIn(
            email: email,
            password: password
        )
    }

    func register(name: String, email: String, password: String) async throws {

        try await supabase.auth.signUp(
            email: email,
            password: password,
            data: ["name": .string(name)]
        )

    }

    func signOut() async throws {
        try await supabase.auth.signOut()
    }
    
    func isValid(name: String? = nil, email: String?, password: String?, validationType: ValidationType) -> Bool {

        switch validationType {
        case .login:
            return (email?.trimmingCharacters(in: .whitespaces).isEmpty ?? true)
                || (password?.trimmingCharacters(in: .whitespaces).isEmpty ?? true)
        case .register:
            return (name?.trimmingCharacters(in: .whitespaces).isEmpty ?? true)
                || (email?.trimmingCharacters(in: .whitespaces).isEmpty ?? true)
                || (password?.trimmingCharacters(in: .whitespaces).isEmpty ?? true)
        }
    }
}
