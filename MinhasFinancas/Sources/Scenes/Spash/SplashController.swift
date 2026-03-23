//
//  ViewController.swift
//  MinhasFinancas
//
//  Created by edson lima on 12/02/26.
//

import LocalAuthentication
import UIKit
import Supabase

class SplashController: UIViewController {

    private let splashView = SplashView()
    private let authViewModel = AuthViewModel()
    private let flowCoordinator: SplashFlowDelegate?

    init(flowCoordinator: SplashFlowDelegate) {
        self.flowCoordinator = flowCoordinator
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        Task {
            
            do {
               let _ = try await supabase.auth.user()
                
                if UserDefaultsManager.isFaceIdEnabled()  {
                    askForFaceId()
                } else {
                    self.flowCoordinator?.navigateToLogin()
                }
                
            } catch {
                print("error \(error.localizedDescription)")
                try await supabase.auth.signOut()
                self.flowCoordinator?.navigateToLogin()
                return
            }
        }
    }

    override func loadView() {
        self.view = splashView
    }

    private func askForFaceId() {
        let context = LAContext()
        var authError: NSError?

        if context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &authError) {

            context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: "Acesso a seu faceID e requirido!") {
                success,
                error in

                DispatchQueue.main.async {
                    if success {
                        //remove a bolinha de notificação do app.
                        UNUserNotificationCenter.current().setBadgeCount(0)
                        
                        self.flowCoordinator?.navigateToHome()
                    } else {
                        if let error = error as? LAError {
                            print("Erro no faceID: \(error.localizedDescription)")
                            self.flowCoordinator?.navigateToLogin()
                        }
                    }
                }
            }
        } else {
            print("Erro desconhecido na autenticação? \(authError?.localizedDescription ?? "Error desconhecido")")
            self.flowCoordinator?.navigateToLogin()
        }
    }
}
