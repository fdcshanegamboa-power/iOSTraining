//
//  ProfileView.swift
//  iOSTraining
//
//  Created by Shane Gamboa - INTERN on 3/3/26.
//

import SwiftUI

struct ProfileView: View {
    @State private var viewModel = UserViewModel()
    @State private var showingAddAddressSheet = false
    @State private var addressToEdit: Address?
    
    private let primaryColor = Color(red: 248/255, green: 188/255, blue: 60/255)
    
    var body: some View {
        Form {
            profileHeaderSection
            profileInformationSection
            addressSection
            accountMetadataSection
        }
        .navigationTitle("Profile")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(primaryColor, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbarColorScheme(.light, for: .navigationBar)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                editButton
            }
        }
        .alert("Success", isPresented: $viewModel.showingSaveAlert) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(viewModel.saveMessage)
        }
        .sheet(isPresented: $showingAddAddressSheet) {
            AddAddressView {
                // Refresh after address is added
                viewModel = UserViewModel()
            }
        }
        .sheet(item: $addressToEdit) { address in
            EditAddressView(address: address) {
                // Refresh after address is updated
                viewModel = UserViewModel()
            }
        }
        .onAppear {
            // Refresh data when view appears to reflect any changes made from other screens
            viewModel = UserViewModel()
        }
    }
    
    // MARK: - Profile Header
    
    private var profileHeaderSection: some View {
        Section {
            VStack(spacing: 16) {
                // Profile Image
                ZStack {
                    Circle()
                        .fill(Color(.systemGray5))
                        .frame(width: 100, height: 100)
                    
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .foregroundStyle(Color(.systemGray3))
                        .frame(width: 100, height: 100)
                }
                
                // User name and username
                VStack(spacing: 4) {
                    Text(viewModel.fullName)
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Text("@\(viewModel.username)")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 8)
        }
        .listRowBackground(Color.clear)
    }
    
    // MARK: - Profile Information
    
    private var profileInformationSection: some View {
        Section {
            if viewModel.isEditMode {
                // Edit mode - show text fields
                LabeledContent("Full Name") {
                    TextField("Enter full name", text: $viewModel.editedFullName)
                        .multilineTextAlignment(.trailing)
                }
                
                LabeledContent("Email") {
                    TextField("Enter email", text: $viewModel.editedEmail)
                        .keyboardType(.emailAddress)
                        .textInputAutocapitalization(.never)
                        .multilineTextAlignment(.trailing)
                }
                
                LabeledContent("Phone") {
                    TextField("Enter phone number", text: $viewModel.editedPhoneNumber)
                        .keyboardType(.phonePad)
                        .multilineTextAlignment(.trailing)
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Bio")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    
                    TextEditor(text: $viewModel.editedBio)
                        .frame(minHeight: 80)
                        .scrollContentBackground(.hidden)
                        .background(Color(.systemGray6))
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                }
                .padding(.vertical, 4)
                
            } else {
                // View mode - show read-only info
                infoRow(label: "Full Name", value: viewModel.fullName, icon: "person.fill")
                infoRow(label: "Email", value: viewModel.email, icon: "envelope.fill")
                infoRow(label: "Phone", value: viewModel.phoneNumber.isEmpty ? "Not provided" : viewModel.phoneNumber, icon: "phone.fill")
                
                if !viewModel.bio.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        Label("Bio", systemImage: "text.alignleft")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        
                        Text(viewModel.bio)
                            .font(.body)
                    }
                    .padding(.vertical, 4)
                }
            }
        } header: {
            Text("Profile Information")
        } footer: {
            if viewModel.isEditMode {
                Button(action: viewModel.saveProfile) {
                    HStack {
                        Spacer()
                        Text("Save Changes")
                            .fontWeight(.semibold)
                        Spacer()
                    }
                    .padding()
                    .background(primaryColor)
                    .foregroundStyle(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                .buttonStyle(.plain)
                .padding(.top, 8)
            }
        }
    }
    
    // MARK: - Address Section
    
    private var addressSection: some View {
        Section {
            if viewModel.hasAddress {
                ForEach(viewModel.allAddresses) { address in
                    addressRow(address)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            addressToEdit = address
                        }
                        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                            Button(role: .destructive) {
                                viewModel.removeAddress(withId: address.id)
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                        .swipeActions(edge: .leading, allowsFullSwipe: false) {
                            if !address.isDefault {
                                Button {
                                    viewModel.setDefaultAddress(withId: address.id)
                                } label: {
                                    Label("Set Default", systemImage: "star.fill")
                                }
                                .tint(primaryColor)
                            }
                        }
                        .contextMenu {
                            Button {
                                addressToEdit = address
                            } label: {
                                Label("Edit", systemImage: "pencil")
                            }
                            
                            if !address.isDefault {
                                Button {
                                    viewModel.setDefaultAddress(withId: address.id)
                                } label: {
                                    Label("Set as Default", systemImage: "star.fill")
                                }
                            }
                            
                            Divider()
                            
                            Button(role: .destructive) {
                                viewModel.removeAddress(withId: address.id)
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                }
            } else {
                HStack {
                    Image(systemName: "mappin.slash")
                        .foregroundStyle(.secondary)
                    Text("No address added")
                        .foregroundStyle(.secondary)
                }
            }
            
            Button {
                showingAddAddressSheet = true
            } label: {
                HStack {
                    Image(systemName: "plus.circle.fill")
                        .foregroundStyle(primaryColor)
                    Text("Add New Address")
                        .foregroundStyle(primaryColor)
                }
            }
        } header: {
            HStack {
                Text("Addresses")
                Spacer()
                if viewModel.defaultAddress != nil {
                    Text("Default: \(viewModel.defaultAddress?.label ?? "")")
                        .font(.caption)
                        .foregroundStyle(primaryColor)
                }
            }
        } footer: {
            Text("Tap to edit • Swipe right to set default • Swipe left to delete")
                .font(.caption)
        }
    }
    
    private func addressRow(_ address: Address) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Label {
                    Text(address.label)
                        .fontWeight(.semibold)
                } icon: {
                    Image(systemName: address.isDefault ? "house.fill" : "mappin.circle.fill")
                        .foregroundStyle(address.isDefault ? primaryColor : .secondary)
                }
                
                Spacer()
                
                if address.isDefault {
                    Text("Default")
                        .font(.caption)
                        .fontWeight(.medium)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(primaryColor.opacity(0.2))
                        .foregroundStyle(primaryColor)
                        .clipShape(Capsule())
                }
            }
            
            VStack(alignment: .leading, spacing: 2) {
                Text(address.street)
                Text("\(address.city), \(address.state) \(address.zipCode)")
                Text(address.country)
            }
            .font(.subheadline)
            .foregroundStyle(.secondary)
        }
        .padding(.vertical, 4)
    }
    
    // MARK: - Account Metadata
    
    private var accountMetadataSection: some View {
        Section("Account Information") {
            infoRow(label: "Member Since", value: viewModel.memberSince, icon: "calendar")
            infoRow(label: "Last Login", value: viewModel.lastLogin, icon: "clock.fill")
        }
    }
    
    // MARK: - Helper Views
    
    private var editButton: some View {
        Button {
            viewModel.toggleEditMode()
        } label: {
            Text(viewModel.isEditMode ? "Cancel" : "Edit")
                .fontWeight(.medium)
        }
    }
    
    private func infoRow(label: String, value: String, icon: String) -> some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundStyle(primaryColor)
                .frame(width: 24)
            
            Text(label)
                .foregroundStyle(.primary)
            
            Spacer()
            
            Text(value)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.trailing)
        }
    }
}

#Preview {
    NavigationStack {
        ProfileView()
    }
}
