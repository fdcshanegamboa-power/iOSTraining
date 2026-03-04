//
//  UserService.swift
//  iOSTraining
//
//  Created by Shane Gamboa - INTERN on 3/3/26.
//
// User/Services/UserService.swift
import Foundation

protocol UserServiceProtocol {
    func authenticate(username: String, password: String) -> User?
    func updateProfile(_ user: User)
    func addAddress(_ address: Address, to user: User) -> User
    func updateAddress(_ address: Address, for user: User) -> User
    func removeAddress(withId id: String, from user: User) -> User
    func setDefaultAddress(withId id: String, for user: User) -> User
}

final class UserService: UserServiceProtocol {
    // Static mock users
    private let staticUsers: [User] = [
        User(
            id: "user_001",
            username: "john_doe",
            email: "john@example.com",
            password: "password123",
            fullName: "John Doe",
            bio: "iOS Developer & Coffee Enthusiast",
            phoneNumber: "+1234567890",
            addresses: [
                Address(
                    id: "addr_001",
                    label: "Home",
                    street: "123 Main St",
                    city: "San Francisco",
                    state: "CA",
                    zipCode: "94102",
                    country: "USA",
                    isDefault: true
                )
            ],
            defaultAddressId: "addr_001",
            createdAt: Date().addingTimeInterval(-86400 * 365)
        ),
        User(
            id: "user_002",
            username: "jane_smith",
            email: "jane@example.com",
            password: "password456",
            fullName: "Jane Smith",
            bio: "Designer & Tech Lover",
            phoneNumber: "+0987654321",
            addresses: [
                Address(
                    id: "addr_002",
                    label: "Office",
                    street: "456 Market St",
                    city: "New York",
                    state: "NY",
                    zipCode: "10001",
                    country: "USA",
                    isDefault: true
                ),
                Address(
                    id: "addr_003",
                    label: "Home",
                    street: "789 Broadway",
                    city: "New York",
                    state: "NY",
                    zipCode: "10002",
                    country: "USA",
                    isDefault: false
                )
            ],
            defaultAddressId: "addr_002",
            createdAt: Date().addingTimeInterval(-86400 * 180)
        )
    ]

    func authenticate(username: String, password: String) -> User? {
        
        return staticUsers.first {
            $0.username == username && $0.password == password
        }
    }

    func updateProfile(_ user: User) {
        // In real app: API call to update user
        // For now: handled by UserManager persistence
    }

    func addAddress(_ address: Address, to user: User) -> User {
        var updatedUser = user
        
        // Build new addresses array with proper default handling
        var newAddresses = updatedUser.addresses.map { addr -> Address in
            var modifiedAddr = addr
            // If new address is default, unset all others
            if address.isDefault {
                modifiedAddr.isDefault = false
            }
            return modifiedAddr
        }
        
        // Append the new address
        newAddresses.append(address)
        
        // If first address, ensure it's default
        if newAddresses.count == 1 {
            newAddresses[0].isDefault = true
            updatedUser.defaultAddressId = address.id
        } else if address.isDefault {
            updatedUser.defaultAddressId = address.id
        }
        
        // Replace entire array in one operation
        updatedUser.addresses = newAddresses

        return updatedUser
    }

    func updateAddress(_ address: Address, for user: User) -> User {
        var updatedUser = user
        if let index = updatedUser.addresses.firstIndex(where: { $0.id == address.id }) {
            // Build new addresses array with proper default handling
            var newAddresses = updatedUser.addresses.enumerated().map { i, addr -> Address in
                if i == index {
                    return address
                } else {
                    var modifiedAddr = addr
                    // If updated address is being set as default, unset all others
                    if address.isDefault {
                        modifiedAddr.isDefault = false
                    }
                    return modifiedAddr
                }
            }
            
            // Replace entire array in one operation
            updatedUser.addresses = newAddresses
            
            if address.isDefault {
                updatedUser.defaultAddressId = address.id
            }
        }
        return updatedUser
    }

    func removeAddress(withId id: String, from user: User) -> User {
        var updatedUser = user
        let wasDefault = updatedUser.defaultAddressId == id
        
        // Build new addresses array without the removed address
        var newAddresses = updatedUser.addresses.filter { $0.id != id }

        // If removed address was default, set new default
        if wasDefault && !newAddresses.isEmpty {
            newAddresses[0].isDefault = true
            updatedUser.defaultAddressId = newAddresses[0].id
        } else if newAddresses.isEmpty {
            updatedUser.defaultAddressId = nil
        }
        
        // Replace entire array in one operation
        updatedUser.addresses = newAddresses

        return updatedUser
    }

    func setDefaultAddress(withId id: String, for user: User) -> User {
        var updatedUser = user
        updatedUser.defaultAddressId = id
        
        // Build new addresses array with updated isDefault flags
        updatedUser.addresses = updatedUser.addresses.map { addr -> Address in
            var modifiedAddr = addr
            modifiedAddr.isDefault = (addr.id == id)
            return modifiedAddr
        }
        
        return updatedUser
    }
}
