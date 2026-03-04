//
//  AddAddressView.swift
//  iOSTraining
//
//  Created by Shane Gamboa - INTERN on 3/3/26.
//

import SwiftUI

struct AddAddressView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var viewModel = UserViewModel()
    
    @State private var label = "Home"
    @State private var street = ""
    @State private var city = ""
    @State private var state = ""
    @State private var zipCode = ""
    @State private var country = "USA"
    @State private var setAsDefault = false
    
    @State private var showingSaveAlert = false
    @State private var saveMessage = ""
    
    private let primaryColor = Color(red: 248/255, green: 188/255, blue: 60/255)
    private let addressLabels = ["Home", "Office", "Other"]
    
    var onAddressAdded: (() -> Void)?
    
    var body: some View {
        NavigationStack {
            Form {
                labelSection
                addressDetailsSection
                defaultAddressSection
            }
            .navigationTitle("Add Address")
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
                    onAddressAdded?()
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
            Toggle(isOn: $setAsDefault) {
                HStack {
                    Image(systemName: "star.fill")
                        .foregroundStyle(primaryColor)
                    Text("Set as default address")
                }
            }
        } footer: {
            if setAsDefault {
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
        let newAddress = Address(
            label: label,
            street: street.trimmingCharacters(in: .whitespacesAndNewlines),
            city: city.trimmingCharacters(in: .whitespacesAndNewlines),
            state: state.trimmingCharacters(in: .whitespacesAndNewlines),
            zipCode: zipCode.trimmingCharacters(in: .whitespacesAndNewlines),
            country: country.trimmingCharacters(in: .whitespacesAndNewlines),
            isDefault: setAsDefault
        )
        
        viewModel.addAddress(newAddress)
        
        saveMessage = "Address added successfully!"
        showingSaveAlert = true
    }
}

#Preview {
    AddAddressView()
}
