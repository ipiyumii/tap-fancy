
import Foundation
import SwiftUI

struct SettingsTab: View {
    @State private var showResetAlert = false
    @State private var notificationsEnabled = NotificationService.shared.isEnabled
    @State private var reminderTime = NotificationService.shared.dailyReminderTime
    
    var body: some View {
        List {
            Section(header: Text("Notifications")) {
                Toggle(isOn: $notificationsEnabled) {
                    HStack {
                        Image(systemName: "bell.fill")
                            .foregroundColor(.orange)
                        Text("Daily Reminder")
                    }
                }
                .onChange(of: notificationsEnabled) { oldValue, newValue in
                    NotificationService.shared.setEnabled(newValue)
                }
                
                if notificationsEnabled {
                    DatePicker(
                        "Reminder Time",
                        selection: $reminderTime,
                        displayedComponents: .hourAndMinute
                    )
                    .onChange(of: reminderTime) { oldValue, newValue in
                        NotificationService.shared.scheduleDailyReminder(at: newValue)
                    }
                }
            }
            
            Section(header: Text("About")) {
                HStack {
                    Text("Version")
                    Spacer()
                    Text("1.0.0")
                        .foregroundColor(.gray)
                }
            }
            
            Section(header: Text("Data")) {
                Button(action: {
                    showResetAlert = true
                }) {
                    HStack {
                        Image(systemName: "trash")
                            .foregroundColor(.red)
                        Text("Reset All Stats")
                            .foregroundColor(.red)
                    }
                }
            }
        }
        .navigationTitle("Settings")
        .alert("Reset All Stats?", isPresented: $showResetAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Reset", role: .destructive) {
                SessionManager.shared.clearAllSessions()
            }
        } message: {
            Text("This will delete all your game history and high scores. This cannot be undone.")
        }
    }
}

