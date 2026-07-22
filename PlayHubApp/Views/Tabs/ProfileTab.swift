
import Foundation
import SwiftUI

struct ProfileTab: View {
    @StateObject private var viewModel = ProfileVM()
    @State private var showDeleteAlert = false

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                if viewModel.hasProfile && !viewModel.isEditing {
                    profileDisplayView
                } else {
                    profileEditView
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
        }
        .background(AppTheme.background)
        .navigationTitle("Profile")
        .overlay(
            ToastBanner(
                message: "Profile saved!",
                icon: "checkmark.circle.fill",
                color: AppTheme.success,
                isShowing: $viewModel.showSaveSuccess
            )
        )
        .alert("Delete Profile?", isPresented: $showDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                viewModel.deleteProfile()
            }
        } message: {
            Text("This will remove all your profile information. This action cannot be undone.")
        }
    }

    var profileDisplayView: some View {
        VStack(spacing: 20) {
            VStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(AppTheme.primaryGradient)
                        .frame(width: 90, height: 90)

                    Text(viewModel.profile.avatarEmoji)
                        .font(.system(size: 44))
                }
                .shadow(color: AppTheme.primary.opacity(0.4), radius: 10, x: 0, y: 4)

                VStack(spacing: 6) {
                    Text(viewModel.profile.name)
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(AppTheme.textPrimary)

                    Text("@\(viewModel.profile.username)")
                        .font(.subheadline)
                        .foregroundColor(AppTheme.textSecondary)
                }

                if !viewModel.profile.bio.isEmpty {
                    Text(viewModel.profile.bio)
                        .font(.body)
                        .foregroundColor(AppTheme.textSecondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 20)
                }
            }
            .padding(.vertical, 24)
            .frame(maxWidth: .infinity)
            .background(AppTheme.surfaceLight)
            .cornerRadius(20)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(AppTheme.primary.opacity(0.2), lineWidth: 1)
            )

            // Profile Info
            VStack(spacing: 0) {
                ProfileInfoRow(
                    icon: "gamecontroller.fill",
                    label: "Favorite Game",
                    value: viewModel.profile.favoriteGame,
                    color: AppTheme.accent
                )

                Divider()
                    .background(AppTheme.textMuted.opacity(0.3))
                    .padding(.leading, 56)

                ProfileInfoRow(
                    icon: "calendar",
                    label: "Member Since",
                    value: viewModel.memberSince,
                    color: AppTheme.primary
                )
            }
            .background(AppTheme.surfaceLight)
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(AppTheme.primary.opacity(0.15), lineWidth: 1)
            )

            // Action 
            VStack(spacing: 12) {
                Button(action: {
                    viewModel.startEditing()
                }) {
                    HStack {
                        Image(systemName: "pencil")
                        Text("Edit Profile")
                    }
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(
                        RoundedRectangle(cornerRadius: 14)
                            .fill(AppTheme.primary)
                    )
                    .shadow(color: AppTheme.primary.opacity(0.4), radius: 8, x: 0, y: 4)
                }

                Button(action: {
                    showDeleteAlert = true
                }) {
                    HStack {
                        Image(systemName: "trash")
                        Text("Delete Profile")
                    }
                    .font(.headline)
                    .foregroundColor(AppTheme.error)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(
                        RoundedRectangle(cornerRadius: 14)
                            .fill(AppTheme.error.opacity(0.15))
                    )
                }
            }
            .padding(.top, 8)
        }
    }

    var profileEditView: some View {
        VStack(spacing: 24) {
            // Header
            VStack(spacing: 8) {
                Text(viewModel.hasProfile ? "Edit Profile" : "Create Profile")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(AppTheme.textPrimary)

                Text("Tell us about yourself")
                    .font(.subheadline)
                    .foregroundColor(AppTheme.textSecondary)
            }
            .padding(.top, 8)

            // Avatar 
            VStack(spacing: 12) {
                Text("Choose Avatar")
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(AppTheme.textSecondary)
                    .frame(maxWidth: .infinity, alignment: .leading)

                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 6), spacing: 12) {
                    ForEach(viewModel.avatarOptions, id: \.self) { emoji in
                        Button(action: {
                            viewModel.profile.avatarEmoji = emoji
                        }) {
                            Text(emoji)
                                .font(.title2)
                                .frame(width: 48, height: 48)
                                .background(
                                    Circle()
                                        .fill(viewModel.profile.avatarEmoji == emoji ?
                                              AppTheme.primary.opacity(0.3) : AppTheme.surface)
                                )
                                .overlay(
                                    Circle()
                                        .stroke(viewModel.profile.avatarEmoji == emoji ?
                                                AppTheme.primary : Color.clear, lineWidth: 2)
                                )
                        }
                    }
                }
            }
            .padding(20)
            .background(AppTheme.surfaceLight)
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(AppTheme.primary.opacity(0.15), lineWidth: 1)
            )

            // Form 
            VStack(spacing: 16) {
                ProfileTextField(
                    label: "Name",
                    placeholder: "Your name",
                    text: $viewModel.profile.name,
                    icon: "person.fill"
                )

                ProfileTextField(
                    label: "Username",
                    placeholder: "Choose a username",
                    text: $viewModel.profile.username,
                    icon: "at"
                )

                ProfileTextField(
                    label: "Bio",
                    placeholder: "Tell us about yourself (optional)",
                    text: $viewModel.profile.bio,
                    icon: "text.quote"
                )

                VStack(alignment: .leading, spacing: 10) {
                    HStack(spacing: 8) {
                        Image(systemName: "gamecontroller.fill")
                            .foregroundColor(AppTheme.accent)
                            .font(.subheadline)
                        Text("Favorite Game")
                            .font(.subheadline)
                            .foregroundColor(AppTheme.textSecondary)
                    }

                    Picker("Favorite Game", selection: $viewModel.profile.favoriteGame) {
                        ForEach(viewModel.gameOptions, id: \.self) { game in
                            Text(game).tag(game)
                        }
                    }
                    .pickerStyle(.segmented)
                }
            }
            .padding(20)
            .background(AppTheme.surfaceLight)
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(AppTheme.primary.opacity(0.15), lineWidth: 1)
            )

            // Action 
            VStack(spacing: 12) {
                Button(action: {
                    viewModel.saveProfile()
                }) {
                    HStack {
                        Image(systemName: "checkmark")
                        Text("Save Profile")
                    }
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(
                        RoundedRectangle(cornerRadius: 14)
                            .fill(viewModel.profile.isComplete ?
                                  AppTheme.primary : AppTheme.textMuted)
                    )
                    .shadow(color: viewModel.profile.isComplete ?
                            AppTheme.primary.opacity(0.4) : Color.clear,
                            radius: 8, x: 0, y: 4)
                }
                .disabled(!viewModel.profile.isComplete)

                if viewModel.hasProfile {
                    Button(action: {
                        viewModel.cancelEditing()
                    }) {
                        Text("Cancel")
                            .font(.headline)
                            .foregroundColor(AppTheme.textSecondary)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                    }
                }
            }
            .padding(.top, 4)
        }
    }
}

struct ProfileInfoRow: View {
    let icon: String
    let label: String
    let value: String
    let color: Color

    var body: some View {
        HStack(spacing: 14) {
            ZStack {
                Circle()
                    .fill(color.opacity(0.12))
                    .frame(width: 42, height: 42)

                Image(systemName: icon)
                    .foregroundColor(color)
                    .font(.body)
            }

            VStack(alignment: .leading, spacing: 2) {
                Text(label)
                    .font(.caption)
                    .foregroundColor(AppTheme.textSecondary)

                Text(value)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(AppTheme.textPrimary)
            }

            Spacer()
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
    }
}

struct ProfileTextField: View {
    let label: String
    let placeholder: String
    @Binding var text: String
    let icon: String

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 8) {
                Image(systemName: icon)
                    .foregroundColor(AppTheme.primary)
                    .font(.subheadline)
                Text(label)
                    .font(.subheadline)
                    .foregroundColor(AppTheme.textSecondary)
            }

            TextField(placeholder, text: $text)
                .foregroundColor(AppTheme.textPrimary)
                .padding(14)
                .background(AppTheme.surface)
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(AppTheme.primary.opacity(0.2), lineWidth: 1)
                )
        }
    }
}

#Preview {
    NavigationStack {
        ProfileTab()
    }
}