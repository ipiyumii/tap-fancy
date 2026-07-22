
import Foundation
import SwiftUI

struct SettingsTab: View {
    @State private var showResetAlert = false
    @State private var showResetConfirmation = false
    @State private var notificationsEnabled = NotificationService.shared.isEnabled
    @State private var reminderTime = NotificationService.shared.dailyReminderTime

    var body: some View {
        List {
            Section {
                HStack(spacing: 15) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 15)
                            .fill(
                                LinearGradient(
                                    gradient: Gradient(colors: [Color.purple, Color.blue]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 60, height: 60)

                        Image(systemName: "gamecontroller.fill")
                            .font(.title)
                            .foregroundColor(.white)
                    }

                    VStack(alignment: .leading, spacing: 4) {
                        Text("PlayHub")
                            .font(.title2)
                            .fontWeight(.bold)

                        Text("Your Gaming Companion")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }

                    Spacer()
                }
                .padding(.vertical, 5)
            }

            Section {
                HStack {
                    SettingsIcon(icon: "bell.fill", color: .orange)

                    Toggle("Daily Reminder", isOn: $notificationsEnabled)
                        .onChange(of: notificationsEnabled) { oldValue, newValue in
                            NotificationService.shared.setEnabled(newValue)
                        }
                }

                if notificationsEnabled {
                    HStack {
                        SettingsIcon(icon: "clock.fill", color: .blue)

                        DatePicker(
                            "Reminder Time",
                            selection: $reminderTime,
                            displayedComponents: .hourAndMinute
                        )
                        .onChange(of: reminderTime) { oldValue, newValue in
                            NotificationService.shared.scheduleDailyReminder(at: newValue)
                        }
                    }

                    HStack {
                        Spacer()
                        Text("We'll remind you to play at this time!")
                            .font(.caption)
                            .foregroundColor(.gray)
                        Spacer()
                    }
                }
            } header: {
                Label("Notifications", systemImage: "bell.badge")
            }

            Section {
                HStack {
                    SettingsIcon(icon: "info.circle.fill", color: .blue)
                    Text("Version")
                    Spacer()
                    Text("1.0.0")
                        .foregroundColor(.gray)
                }

                HStack {
                    SettingsIcon(icon: "person.fill", color: .green)
                    Text("Developer")
                    Spacer()
                    Text("Piyumi Imalka")
                        .foregroundColor(.gray)
                }

                HStack {
                    SettingsIcon(icon: "swift", color: .orange)
                    Text("Built with")
                    Spacer()
                    Text("SwiftUI")
                        .foregroundColor(.gray)
                }
            } header: {
                Label("About", systemImage: "info.circle")
            }

            Section {
                Button(action: {
                    showResetAlert = true
                }) {
                    HStack {
                        SettingsIcon(icon: "trash.fill", color: .red)
                        Text("Reset All Stats")
                            .foregroundColor(.red)
                        Spacer()
                        Image(systemName: "chevron.right")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                }
            } header: {
                Label("Data", systemImage: "externaldrive")
            } footer: {
                Text("This will permanently delete all your game history, high scores, and achievements.")
                    .font(.caption)
            }

            Section {
                FunFactRow(icon: "hand.tap.fill", color: .orange, fact: "Tap Frenzy", detail: "Test your speed!")
                FunFactRow(icon: "lightbulb.fill", color: .yellow, fact: "Light It Up", detail: "Test your reflexes!")
                FunFactRow(icon: "questionmark.circle.fill", color: .green, fact: "Quiz Rush", detail: "Test your knowledge!")
            } header: {
                Label("Games", systemImage: "gamecontroller")
            }
        }
        .navigationTitle("Settings")
        .alert("Reset All Stats?", isPresented: $showResetAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Reset", role: .destructive) {
                SessionManager.shared.clearAllSessions()
                showResetConfirmation = true
            }
        } message: {
            Text("This will delete all your game history and high scores. This action cannot be undone.")
        }
        .alert("Stats Reset", isPresented: $showResetConfirmation) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("All your stats have been reset. Time for a fresh start!")
        }
    }
}

struct SettingsIcon: View {
    let icon: String
    let color: Color

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 6)
                .fill(color)
                .frame(width: 28, height: 28)

            Image(systemName: icon)
                .font(.system(size: 14))
                .foregroundColor(.white)
        }
    }
}

struct FunFactRow: View {
    let icon: String
    let color: Color
    let fact: String
    let detail: String

    var body: some View {
        HStack(spacing: 12) {
            SettingsIcon(icon: icon, color: color)

            VStack(alignment: .leading, spacing: 2) {
                Text(fact)
                    .font(.subheadline)
                    .fontWeight(.medium)

                Text(detail)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
        }
    }
}

#Preview {
    NavigationStack {
        SettingsTab()
    }
}

