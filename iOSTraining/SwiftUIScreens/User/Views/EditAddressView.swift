//
//  EditAddressView.swift
//  iOSTraining
//
//  Created by Shane Gamboa - INTERN on 3/3/26.
//

import SwiftUI

struct EditAddressView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var viewModel = UserViewModel()
    
    let address: Address
    
    @State private var label: String
    @State private var street: String
    @State private var city: String
    @State private var state: String
    @State private var zipCode: String
    @State private var country: String
    @State private var isDefault: Bool
    
    @State private var showingSaveAlert = false
    @State private var saveMessage = ""
    
    private let primaryColor = Color(red: 248/255, green: 188/255, blue: 60/255)
    private let addressLabels = ["Home", "Office", "Other"]
    
    var onAddressUpdated: (() -> Void)?
    
    init(address: Address, onAddressUpdated: (() -> Void)? = nil) {
        self.address = address
        self.onAddressUpdated = onAddressUpdated
        
        // Initialize @State properties
        _label = State(initialValue: address.label)
        _street = State(initialValue: address.street)
        _city = State(initialValue: address.city)
        _state = State(initialValue: address.state)
        _zipCode = State(initialValue: address.zipCode)
        _country = State(initialValue: address.country)
        _isDefault = State(initialValue: address.isDefault)
    }
    
    var body: some View {
        NavigationStack {
            Form {
                labelSection
                addressDetailsSection
                defaultAddressSection
            }
            .navigationTitle("Edit Address")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(primaryColor, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarColorScheme(.light, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        saveAddress()
                    }
                    .fontWeight(.semibold)
                    .disabled(!isValidAddress)
                }
            }
            .alert("Success", isPresented: $showingSaveAlert) {
                Button("OK") {
                    onAddressUpdated?()
                    dismiss()
                }
            } message: {
                Text(saveMessage)
            }
        }
    }
    
    // MARK: - Sections
    
    private var labelSection: some View {
        Section {
            Picker("Label", selection: $label) {
                ForEach(addressLabels, id: \.self) { label in
                    Text(label).tag(label)
                }
            }
            .pickerStyle(.segmented)
        } header: {
            Text("Address Type")
        }
    }
    
    private var addressDetailsSection: some View {
        Section {
            TextField("Street Address", text: $street)
                .textInputAutocapitalization(.words)
            
            TextField("City", text: $city)
                .textInputAutocapitalization(.words)
            
            HStack {
                TextField("State", text: $state)
                    .textInputAutocapitalization(.characters)
                    .frame(maxWidth: .infinity)
                
                TextField("ZIP Code", text: $zipCode)
                    .keyboardType(.numberPad)
                    .frame(maxWidth: .infinity)
            }
            
            TextField("Country", text: $country)
                .textInputAutocapitalization(.words)
        } header: {
            Text("Address Details")
        } footer: {
            Text("Please provide your complete delivery address.")
                .font(.caption)
        }
    }
    
    private var defaultAddressSection: some View {
        Section {
            Toggle(isOn: $isDefault) {
                HStack {
                    Image(systemName: "star.fill")
                        .foregroundStyle(primaryColor)
                    Text("Set as default address")
                }
            }
        } footer: {
            if isDefault {
                Text("This address will be used as your primary delivery address.")
                    .font(.caption)
            }
        }
    }
    
    // MARK: - Validation
    
    private var isValidAddress: Bool {
        !street.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !city.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !state.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !zipCode.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !country.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    // MARK: - Actions
    
    private func saveAddress() {
        let updatedAddress = Address(
            id: address.id, // Keep the same ID
            label: label,
            street: street.trimmingCharacters(in: .whitespacesAndNewlines),
            city: city.trimmingCharacters(in: .whitespacesAndNewlines),
            state: state.trimmingCharacters(in: .whitespacesAndNewlines),
            zipCode: zipCode.trimmingCharacters(in: .whitespacesAndNewlines),
            country: country.trimmingCharacters(in: .whitespacesAndNewlines),
            isDefault: isDefault
        )
        
        viewModel.updateAddress(updatedAddress)
        
        saveMessage = "Address updated successfully!"
        showingSaveAlert = true
    }
}

#Preview {
    EditAddressView(
        address: Address(
            label: "Home",
            street: "123 Main St",
            city: "San Francisco",
            state: "CA",
            zipCode: "94102",
            country: "USA",
            isDefault: true
        )
    )
}
