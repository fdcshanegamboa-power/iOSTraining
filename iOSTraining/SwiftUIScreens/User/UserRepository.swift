//
//  UserRepository.swift
//  iOSTraining
//
//  Created by Shane Gamboa - INTERN on 3/3/26.
// User/Repository/UserRepository.swift
import Foundation

protocol UserRepositoryProtocol {
    var currentUser: User? { get }
    var isLoggedIn: Bool { get }

    func login(_ user: User)
    func logout()
    func updateUser(_ user: User)
}

final class UserRepository: UserRepositoryProtocol {
    private let defaults = UserDefaults.standard
    private let userKey = "current_user"

    var currentUser: User? {
        guard let data = defaults.data(forKey: userKey),
              let user = try? JSONDecoder().decode(User.self, from: data) else {
            return nil
        }
        return user
    }

    var isLoggedIn: Bool {
        currentUser != nil
    }

    func login(_ user: User) {
        var updatedUser = user
        updatedUser.lastLoginAt = Date()
        save(updatedUser)
    }

    func logout() {
        defaults.removeObject(forKey: userKey)
    }

    func updateUser(_ user: User) {
        save(user)
    }

    private func save(_ user: User) {
        if let data = try? JSONEncoder().encode(user) {
            defaults.set(data, forKey: userKey)
        }
    }
}
