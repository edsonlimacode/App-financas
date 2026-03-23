//
//  UserDetailsManager.swift
//  MinhasFinancas
//
//  Created by edson lima on 07/03/26.
//

import Foundation
import UIKit
import Supabase

class UserDefaultsManager {

    static func enableFaceId() {
        UserDefaults.standard.set(true, forKey: "faceIdEnabled")
        UserDefaults.standard.synchronize()
    }
    
    static func desableFaceId() {
        UserDefaults.standard.set(false, forKey: "faceIdEnabled")
        UserDefaults.standard.synchronize()
    }

    static func isFaceIdEnabled() -> Bool {
        let facedIdEnabled = UserDefaults.standard.bool(forKey: "faceIdEnabled")
        return facedIdEnabled
    }

    static func setImageProfile(image: UIImage) async {
        
        do {
            let userId = try await supabase.auth.user().id
            
            if let imageProfile = image.jpegData(compressionQuality: 1.0) {
                UserDefaults.standard.set(imageProfile, forKey: "picture-\(userId)")
                UserDefaults.standard.synchronize()
            }
        } catch {
            print("Erro ao salvar imagem: \(error.localizedDescription)")
        }
        
      
    }

    static func getImageProfile() async -> UIImage? {
        
        do {
            
            let userId = try await supabase.auth.user().id
            
            if let imageData = UserDefaults.standard.data(forKey: "picture-\(userId)") {
                return UIImage(data: imageData)
            }
        } catch {
            print("Erro ao carregar imagem: \(error.localizedDescription)")
        }
    
        return UIImage(named: "avatar")
    }
}
