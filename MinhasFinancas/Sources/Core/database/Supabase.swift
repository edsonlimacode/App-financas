//
//  Supabase.swift
//  MinhasFinancas
//
//  Created by edson lima on 13/02/26.
//

import Foundation
import Supabase

private enum SupabaseConfig {
    private static let values: [String: Any] = {
        guard
            let path = Bundle.main.path(forResource: "Secrets", ofType: "plist"),
            let values = NSDictionary(contentsOfFile: path) as? [String: Any]
        else {
            fatalError("Secrets.plist is missing from the app bundle.")
        }

        return values
    }()

    static let url: URL = {
        guard
            let urlString = values["SUPABASE_URL"] as? String,
            let url = URL(string: urlString),
            !urlString.isEmpty
        else {
            fatalError("SUPABASE_URL is missing from Secrets.plist.")
        }

        return url
    }()

    static let key: String = {
        guard
            let key = values["SUPABASE_KEY"] as? String,
            !key.isEmpty
        else {
            fatalError("SUPABASE_KEY is missing from Secrets.plist.")
        }

        return key
    }()
}

let supabase = SupabaseClient(
    supabaseURL: SupabaseConfig.url,
    supabaseKey: SupabaseConfig.key,
    options: SupabaseClientOptions(
        auth: .init(
            emitLocalSessionAsInitialSession: true
        )
    )
)
