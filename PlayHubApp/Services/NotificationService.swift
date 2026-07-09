
import Foundation
import UserNotifications

class NotificationService: ObservableObject {
    static let shared = NotificationService()
    
    @Published var isEnabled = false
    @Published var dailyReminderTime: Date = Date()
    
    private let notificationCenter = UNUserNotificationCenter.current()
    
    init() {
        isEnabled = UserDefaults.standard.bool(forKey: "notificationsEnabled")
        
        if let savedTime = UserDefaults.standard.object(forKey: "reminderTime") as? Date {
            dailyReminderTime = savedTime
        }
    }
    
    func requestPermission() {
        notificationCenter.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                print("notifications allowed")
            } else {
                print("notifications denied")
            }
        }
    }
    
    // schedule notification
    func scheduleDailyReminder(at time: Date) {
        cancelDailyReminder()
        
        let content = UNMutableNotificationContent()
        content.title = "Time to Play! 🎮"
        content.body = "Your daily gaming challenge awaits. Can you beat your high score?"
        content.sound = .default
        
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: time)
        let minute = calendar.component(.minute, from: time)
        
        var dateComponents = DateComponents()
        dateComponents.hour = hour
        dateComponents.minute = minute
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        
        let request = UNNotificationRequest(
            identifier: "dailyGameReminder",
            content: content,
            trigger: trigger
        )
        
        notificationCenter.add(request) { error in
            if error != nil {
                print("error scheduling notifcation")
            }
        }
        
        dailyReminderTime = time
        UserDefaults.standard.set(time, forKey: "reminderTime")
    }
    
    func cancelDailyReminder() {
        notificationCenter.removePendingNotificationRequests(withIdentifiers: ["dailyGameReminder"])
    }
    
    func setEnabled(_ enabled: Bool) {
        isEnabled = enabled
        UserDefaults.standard.set(enabled, forKey: "notificationsEnabled")
        
        if enabled {
            requestPermission()
            scheduleDailyReminder(at: dailyReminderTime)
        } else {
            cancelDailyReminder()
        }
    }
}
