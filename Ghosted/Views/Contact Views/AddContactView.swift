import SwiftUI
import UIKit

struct AddContactView: View {
    @EnvironmentObject var dataModel: DataModel
    @Environment(\.dismiss) var dismiss
    @Binding var isPresented: Bool

    @State private var firstName = ""
    @State private var lastName = ""
    @State private var jobTitle = ""
    @State private var email = ""
    @State private var phoneNumber = ""
    @State private var image: UIImage?
    @State private var showingImagePicker = false
    @State private var sourceType: UIImagePickerController.SourceType?

    var isFormValid: Bool {
        !firstName.isEmpty && !lastName.isEmpty && !email.isEmpty
    }

    var company: Company
    var contactToEdit: Contact?
    
    var isEditing: Bool {
        contactToEdit != nil
    }
    
    init(isPresented: Binding<Bool>, company: Company, contactToEdit: Contact? = nil) {
        self._isPresented = isPresented
        self.company = company
        self.contactToEdit = contactToEdit
        
        if let contact = contactToEdit {
            _firstName = State(initialValue: contact.firstName)
            _lastName = State(initialValue: contact.lastName)
            _jobTitle = State(initialValue: contact.jobTitle)
            _email = State(initialValue: contact.email)
            _phoneNumber = State(initialValue: contact.phoneNumber)
            // Load the image if it exists
            if let uiImage = dataModel.getImage(for: contact) {
                _image = State(initialValue: uiImage)
            }
        }
    }

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("First name:", text: $firstName)
                        .textInputAutocapitalization(.words)
                        .autocorrectionDisabled(true)
                    TextField("Last name:", text: $lastName)
                        .textInputAutocapitalization(.words)
                        .autocorrectionDisabled(true)
                    TextField("Job:", text: $jobTitle)
                        .textInputAutocapitalization(.words)
                        .autocorrectionDisabled(true)
                    TextField("Email:", text: $email)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                    TextField("Cell number:", text: $phoneNumber)
                        .keyboardType(.phonePad)
                } header: {
                    Text("Contact Information")
                }
                
                Section {
                    if let image = image {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 80)
                            .clipShape(Circle())
                    }
                    
                    Button {
                        sourceType = .photoLibrary
                        showingImagePicker = true
                    } label: {
                        Label("Choose photo", systemImage: "photo.on.rectangle.angled")
                    }
                    
                    Button {
                        sourceType = .camera
                        showingImagePicker = true
                    } label: {
                        Label("Take photo", systemImage: "camera")
                    }
                } header: {
                    Text("Photo (optional)")
                }
            }
            .navigationTitle(isEditing ? "Edit Contact" : "New Contact")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button {
                        isPresented = false
                        dismiss()
                    } label: {
                        Text("Cancel")
                            .foregroundStyle(Color.red)
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button {
                        saveContact()
                        isPresented = false
                        dismiss()
                    } label: {
                        Text("Save")
                    }
                    .disabled(!isFormValid)
                }
            }
            .sheet(isPresented: $showingImagePicker) {
                if let sourceType = sourceType {
                    ImagePicker(image: $image, sourceType: sourceType)
                }
            }
            .presentationDragIndicator(.visible)
        }
    }
    
    private func saveContact() {
        let contact = Contact(
            id: contactToEdit?.id ?? UUID(),
            firstName: firstName,
            lastName: lastName,
            jobTitle: jobTitle,
            email: email,
            phoneNumber: phoneNumber,
            photoName: contactToEdit?.photoName ?? "", // Keep existing photoName if editing
            companyID: company.id // Set the companyID for the new contact
        )
        
        if isEditing {
            dataModel.updateContact(contact, with: image)
        } else {
            dataModel.addContact(contact, with: image, to: company) // Ensure the company is passed
        }
    }
}

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var image: UIImage?
    var sourceType: UIImagePickerController.SourceType

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = sourceType
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: ImagePicker

        init(_ parent: ImagePicker) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let uiImage = info[.originalImage] as? UIImage {
                parent.image = uiImage
            }
            picker.dismiss(animated: true)
        }
    }
}
