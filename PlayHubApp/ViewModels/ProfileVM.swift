import Foundation

class ProfileVM: ObservableObject {
    @Published var profile: UserProfile
    @Published var isEditing = false
    @Published var showSaveSuccess = false

    private let manager = ProfileManager.shared

    let avatarOptions = ["😎", "🎮", "🏆", "⭐", "🔥", "💪", "🎯", "🚀", "💎", "🌟", "🦊", "🐱"]
    let gameOptions = ["Tap Frenzy", "Light It Up", "Quiz Rush"]

    init() {
        self.profile = manager.loadProfile() ?? UserProfile()
    }

    var hasProfile: Bool {
        manager.hasProfile && profile.isComplete
    }

    func saveProfile() {
        manager.saveProfile(profile)
        showSaveSuccess = true
        isEditing = false

        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.showSaveSuccess = false
        }
    }

    func startEditing() {
        isEditing = true
    }

    func cancelEditing() {
        profile = manager.loadProfile() ?? UserProfile()
        isEditing = false
    }

    func deleteProfile() {
        manager.deleteProfile()
        profile = UserProfile()
        isEditing = false
    }

    var memberSince: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: profile.joinDate)
    }
}