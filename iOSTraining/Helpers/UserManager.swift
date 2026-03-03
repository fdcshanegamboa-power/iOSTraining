//
//  UserManager.swift
//  iOSTraining
//
//  Created by Shane Gamboa - INTERN on 3/3/26.
// User/Manager/UserManager.swift
import Foundation
import Observation

@Observable
final class UserManager {
    static let shared = UserManager()

    private let repository: UserRepositoryProtocol
    private let service: UserServiceProtocol

    private(set) var currentUser: User?

    var isLoggedIn: Bool {
        currentUser != nil
    }

    var defaultAddress: Address? {
        guard let user = currentUser,
              let defaultId = user.defaultAddressId else {
            return nil
        }
        return user.addresses.first { $0.id == defaultId }
    }

    init(
        repository: UserRepositoryProtocol = UserRepository(),
        service: UserServiceProtocol = UserService()
    ) {
        self.repository = repository
        self.service = service
        self.currentUser = repository.currentUser
    }

    func login(username: String, password: String) -> Bool {
        guard let user = service.authenticate(username: username, password: password) else {
            return false
        }

        repository.login(user)
        self.currentUser = user

        // Reload cart for this user
        CartManager.shared.reloadCart()

        return true
    }

    func logout() {
        repository.logout()
        self.currentUser = nil

        // Clear cart
        CartManager.shared.reloadCart()
    }

    func updateProfile(fullName: String, bio: String?, phoneNumber: String?) {
        guard var user = currentUser else { return }

        user.fullName = fullName
        user.bio = bio
        user.phoneNumber = phoneNumber

        service.updateProfile(user)
        repository.updateUser(user)
        self.currentUser = user
    }

    func addAddress(_ address: Address) {
        guard let user = currentUser else { return }
        let updatedUser = service.addAddress(address, to: user)
        repository.updateUser(updatedUser)
        self.currentUser = updatedUser
    }

    func updateAddress(_ address: Address) {
        guard let user = currentUser else { return }
        let updatedUser = service.updateAddress(address, for: user)
        repository.updateUser(updatedUser)
        self.currentUser = updatedUser
    }

    func removeAddress(withId id: String) {
        guard let user = currentUser else { return }
        let updatedUser = service.removeAddress(withId: id, from: user)
        repository.updateUser(updatedUser)
        self.currentUser = updatedUser
    }

    func setDefaultAddress(withId id: String) {
        guard let user = currentUser else { return }
        let updatedUser = service.setDefaultAddress(withId: id, for: user)
        repository.updateUser(updatedUser)
        self.currentUser = updatedUser
    }
}
