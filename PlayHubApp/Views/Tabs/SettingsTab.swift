
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
                HStack(spacing: 16) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 14)
                            .fill(AppTheme.primaryGradient)
                            .frame(width: 56, height: 56)

                        Image(systemName: "gamecontroller.fill")
                            .font(.title2)
                            .foregroundColor(.white)
                    }

                    VStack(alignment: .leading, spacing: 4) {
                        Text("PlayHub")
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundColor(AppTheme.textPrimary)

                        Text("Your Gaming Companion")
                            .font(.caption)
                            .foregroundColor(AppTheme.textSecondary)
                    }

                    Spacer()
                }
                .padding(.vertical, 8)
                .listRowBackground(AppTheme.surfaceLight)
            }

            Section {
                HStack {
                    SettingsIcon(icon: "bell.fill", color: AppTheme.accent)

                    Toggle("Daily Reminder", isOn: $notificationsEnabled)
                        .tint(AppTheme.primary)
                        .onChange(of: notificationsEnabled) { oldValue, newValue in
                            NotificationService.shared.setEnabled(newValue)
                        }
                }
                .listRowBackground(AppTheme.surfaceLight)

                if notificationsEnabled {
                    HStack {
                        SettingsIcon(icon: "clock.fill", color: AppTheme.primary)

                        DatePicker(
                            "Reminder Time",
                            selection: $reminderTime,
                            displayedComponents: .hourAndMinute
                        )
                        .onChange(of: reminderTime) { oldValue, newValue in
                            NotificationService.shared.scheduleDailyReminder(at: newValue)
                        }
                    }
                    .listRowBackground(AppTheme.surfaceLight)

                    HStack {
                        Spacer()
                        Text("We'll remind you to play at this time!")
                            .font(.caption)
                            .foregroundColor(AppTheme.textSecondary)
                        Spacer()
                    }
                    .listRowBackground(AppTheme.surfaceLight)
                }
            } header: {
                Label("Notifications", systemImage: "bell.badge")
                    .foregroundColor(AppTheme.textSecondary)
            }

            Section {
                HStack {
                    SettingsIcon(icon: "info.circle.fill", color: AppTheme.primary)
                    Text("Version")
                        .foregroundColor(AppTheme.textPrimary)
                    Spacer()
                    Text("1.0.0")
                        .foregroundColor(AppTheme.textSecondary)
                }
                .listRowBackground(AppTheme.surfaceLight)

                HStack {
                    SettingsIcon(icon: "person.fill", color: AppTheme.primaryLight)
                    Text("Developer")
                        .foregroundColor(AppTheme.textPrimary)
                    Spacer()
                    Text("Piyumi Imalka")
                        .foregroundColor(AppTheme.textSecondary)
                }
                .listRowBackground(AppTheme.surfaceLight)

                HStack {
                    SettingsIcon(icon: "swift", color: AppTheme.accent)
                    Text("Built with")
                        .foregroundColor(AppTheme.textPrimary)
                    Spacer()
                    Text("SwiftUI")
                        .foregroundColor(AppTheme.textSecondary)
                }
                .listRowBackground(AppTheme.surfaceLight)
            } header: {
                Label("About", systemImage: "info.circle")
                    .foregroundColor(AppTheme.textSecondary)
            }

            Section {
                Button(action: {
                    showResetAlert = true
                }) {
                    HStack {
                        SettingsIcon(icon: "trash.fill", color: AppTheme.error)
                        Text("Reset All Stats")
                            .foregroundColor(AppTheme.error)
                        Spacer()
                        Image(systemName: "chevron.right")
                            .font(.caption)
                            .foregroundColor(AppTheme.textMuted)
                    }
                }
                .listRowBackground(AppTheme.surfaceLight)
            } header: {
                Label("Data", systemImage: "externaldrive")
                    .foregroundColor(AppTheme.textSecondary)
            } footer: {
                Text("This will permanently delete all your game history, high scores, and achievements.")
                    .font(.caption)
                    .foregroundColor(AppTheme.textMuted)
            }

            Section {
                FunFactRow(icon: "hand.tap.fill", color: AppTheme.tapFrenzy, fact: "Tap Frenzy", detail: "Test your speed!")
                    .listRowBackground(AppTheme.surfaceLight)
                FunFactRow(icon: "lightbulb.fill", color: AppTheme.lightItUp, fact: "Light It Up", detail: "Test your reflexes!")
                    .listRowBackground(AppTheme.surfaceLight)
                FunFactRow(icon: "questionmark.circle.fill", color: AppTheme.quizRush, fact: "Quiz Rush", detail: "Test your knowledge!")
                    .listRowBackground(AppTheme.surfaceLight)
            } header: {
                Label("Games", systemImage: "gamecontroller")
                    .foregroundColor(AppTheme.textSecondary)
            }
        }
        .scrollContentBackground(.hidden)
        .background(AppTheme.background)
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
            RoundedRectangle(cornerRadius: 8)
                .fill(color)
                .frame(width: 30, height: 30)

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
        HStack(spacing: 14) {
            SettingsIcon(icon: icon, color: color)

            VStack(alignment: .leading, spacing: 2) {
                Text(fact)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(AppTheme.textPrimary)

                Text(detail)
                    .font(.caption)
                    .foregroundColor(AppTheme.textSecondary)
            }
        }
    }
}

#Preview {
    NavigationStack {
        SettingsTab()
    }
}

