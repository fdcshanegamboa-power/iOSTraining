//
//  User.swift
//  iOSTraining
//
//  Created by Shane Gamboa - INTERN on 3/3/26.
//
// User/Models/User.swift
import Foundation

struct User: Codable, Identifiable {
    let id: String
    var username: String
    var email: String
    var password: String // For static accounts only

    // Profile fields
    var fullName: String
    var bio: String?
    var phoneNumber: String?
    var profileImageURL: String?

    // Addresses
    var addresses: [Address]
    var defaultAddressId: String?

    // Metadata
    var createdAt: Date
    var lastLoginAt: Date?

    init(
        id: String,
        username: String,
        email: String,
        password: String,
        fullName: String,
        bio: String? = nil,
        phoneNumber: String? = nil,
        profileImageURL: String? = nil,
        addresses: [Address] = [],
        defaultAddressId: String? = nil,
        createdAt: Date = Date(),
        lastLoginAt: Date? = nil
    ) {
        self.id = id
        self.username = username
        self.email = email
        self.password = password
        self.fullName = fullName
        self.bio = bio
        self.phoneNumber = phoneNumber
        self.profileImageURL = profileImageURL
        self.addresses = addresses
        self.defaultAddressId = defaultAddressId
        self.createdAt = createdAt
        self.lastLoginAt = lastLoginAt
    }
}

struct Address: Codable, Identifiable {
    let id: String
    var label: String // "Home", "Office", "Other"
    var street: String
    var city: String
    var state: String
    var zipCode: String
    var country: String
    var isDefault: Bool

    init(
        id: String = UUID().uuidString,
        label: String,
        street: String,
        city: String,
        state: String,
        zipCode: String,
        country: String,
        isDefault: Bool = false
    ) {
        self.id = id
        self.label = label
        self.street = street
        self.city = city
        self.state = state
        self.zipCode = zipCode
        self.country = country
        self.isDefault = isDefault
    }
}
