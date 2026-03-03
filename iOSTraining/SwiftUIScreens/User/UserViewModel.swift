//
//  UserViewModel.swift
//  iOSTraining
//
//  Created by Shane Gamboa - INTERN on 3/3/26.
//

import Foundation
import Observation

@Observable
final class UserViewModel {
    private let repository: UserRepositoryProtocol
    private let service: UserServiceProtocol
    
    var isEditMode = false
    var showingSaveAlert = false
    var saveMessage = ""
    
    // Editable fields
    var editedFullName = ""
    var editedBio = ""
    var editedPhoneNumber = ""
    var editedEmail = ""
    
    init(
        repository: UserRepositoryProtocol = UserRepository(),
        service: UserServiceProtocol = UserService()
    ) {
        self.repository = repository
        self.service = service
        loadUserData()
    }
    
    // MARK: - Computed Properties
    
    var currentUser: User? {
        repository.currentUser
    }
    
    var fullName: String {
        currentUser?.fullName ?? "Guest"
    }
    
    var username: String {
        currentUser?.username ?? ""
    }
    
    var email: String {
        currentUser?.email ?? ""
    }
    
    var bio: String {
        currentUser?.bio ?? ""
    }
    
    var phoneNumber: String {
        currentUser?.phoneNumber ?? ""
    }
    
    var defaultAddress: Address? {
        guard let user = currentUser,
              let defaultId = user.defaultAddressId else {
            return nil
        }
        return user.addresses.first { $0.id == defaultId }
    }
    
    var allAddresses: [Address] {
        currentUser?.addresses ?? []
    }
    
    var hasAddress: Bool {
        !allAddresses.isEmpty
    }
    
    var memberSince: String {
        guard let user = currentUser else { return "" }
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: user.createdAt)
    }
    
    var lastLogin: String {
        guard let user = currentUser,
              let lastLoginAt = user.lastLoginAt else {
            return "Never"
        }
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: lastLoginAt)
    }
    
    // MARK: - Actions
    
    func toggleEditMode() {
        if isEditMode {
            // Cancel editing - reset to original values
            loadUserData()
        } else {
            // Enter edit mode - load current values into editable fields
            loadUserData()
        }
        isEditMode.toggle()
    }
    
    func saveProfile() {
        guard var user = currentUser else { return }
        
        // Update user with edited values
        user.fullName = editedFullName.trimmingCharacters(in: .whitespacesAndNewlines)
        user.bio = editedBio.isEmpty ? nil : editedBio.trimmingCharacters(in: .whitespacesAndNewlines)
        user.phoneNumber = editedPhoneNumber.isEmpty ? nil : editedPhoneNumber.trimmingCharacters(in: .whitespacesAndNewlines)
        user.email = editedEmail.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // Save through service and repository
        service.updateProfile(user)
        repository.updateUser(user)
        
        // Exit edit mode
        isEditMode = false
        
        // Show success message
        saveMessage = "Profile updated successfully!"
        showingSaveAlert = true
    }
    
    func addAddress(_ address: Address) {
        guard let user = currentUser else { return }
        let updatedUser = service.addAddress(address, to: user)
        repository.updateUser(updatedUser)
    }
    
    func updateAddress(_ address: Address) {
        guard let user = currentUser else { return }
        let updatedUser = service.updateAddress(address, for: user)
        repository.updateUser(updatedUser)
    }
    
    func removeAddress(withId id: String) {
        guard let user = currentUser else { return }
        let updatedUser = service.removeAddress(withId: id, from: user)
        repository.updateUser(updatedUser)
    }
    
    func setDefaultAddress(withId id: String) {
        guard let user = currentUser else { return }
        let updatedUser = service.setDefaultAddress(withId: id, for: user)
        repository.updateUser(updatedUser)
    }
    
    // MARK: - Private Helpers
    
    private func loadUserData() {
        guard let user = currentUser else { return }
        editedFullName = user.fullName
        editedBio = user.bio ?? ""
        editedPhoneNumber = user.phoneNumber ?? ""
        editedEmail = user.email
    }
}
