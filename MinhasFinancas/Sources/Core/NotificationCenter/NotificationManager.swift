//
//  NotificationCenter.swift
//  MinhasFinancas
//
//  Created by edson lima on 11/03/26.
//

import Foundation
import Supabase
import UserNotifications

class NotificationManager {

    static let shared = NotificationManager()

    func setupNotification(dueDate: String) {

        let startDate = dueDate.convertToDate()

        let content = UNMutableNotificationContent()
        content.title = "Lembre-se"
        content.body = "Você tem contas a pagar ou receber hoje. Confira no app!"
        content.sound = .default
        content.badge = 1

        guard let userId = supabase.auth.currentUser?.id else { return }

        //Como o identifier (userId) é o mesmo a notificação será sempre sobrescrita cada vez que lançada,
        //passando (dueDate) que sempre muda, a notificação e criada para cada data.
        let identifier = "client_id_\(userId)_date_\(dueDate)"

        var components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: startDate)
        components.hour = 6
        components.minute = 0

        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)

        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error adding notification: \(error.localizedDescription)")
            } else {
                print("Notificação agendada com sucesso!")
            }
        }
    }
}
