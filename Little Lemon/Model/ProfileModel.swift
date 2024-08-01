//
//  ProfileImage.swift
//  Little Lemon
//
//  Inspired by https://developer.apple.com/documentation/photokit/bringing_photos_picker_to_your_swiftui_app
//


import SwiftUI
import PhotosUI
import CoreTransferable
import os


fileprivate let kProfileFirstName = "ll.profile.name.given"
fileprivate let kProfileLastName = "ll.profile.name.surname"
fileprivate let kProfileEmail = "ll.profile.email"
fileprivate let kProfileOnboarded = "ll.profile.onboarded"

fileprivate let kProfileImageFile = "profile.png"

@MainActor
class ProfileModel: ObservableObject {
    
    
    // MARK: - Profile Details

    @AppStorage(kProfileFirstName) var firstName: String = ""
    @AppStorage(kProfileLastName) var lastName: String = ""
    @AppStorage(kProfileEmail) var email: String = ""
    @AppStorage(kProfileOnboarded) var onboarded: Bool = false;
    
    // MARK: - Profile Image
    
    enum ImageState {
        case empty
		case loading(Progress)
		case success(Image)
		case failure(Error)
    }
    
    private var documentsDirectory: URL = {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths.first!
    }()
    
    enum TransferError: Error {
        case importFailed
        case badImageData
    }
    
    struct ProfileImage: Transferable {
        let uiImage: UIImage
        
        var image: Image {
            Image(uiImage: uiImage)
        }
        
        static var transferRepresentation: some TransferRepresentation {
            DataRepresentation(importedContentType: .image) { data in
                guard let uiImage = UIImage(data: data) else {
                    throw TransferError.importFailed
                }
                return ProfileImage(uiImage: uiImage)
            }
        }
    }
    
    @Published private(set) var imageState: ImageState = .empty
    
    @Published var imageSelection: PhotosPickerItem? = nil {
        didSet {
            if let imageSelection {
                let progress = loadTransferable(from: imageSelection)
                imageState = .loading(progress)
            } else {
                imageState = .empty
            }
        }
    }
    
	// MARK: - Private Methods
	
    private func loadTransferable(from imageSelection: PhotosPickerItem) -> Progress {
        return imageSelection.loadTransferable(type: ProfileImage.self) { result in
            Task {
                guard imageSelection == self.imageSelection else {
                    os_log(.error, "Failed to get the selected item.")
                    return
                }
                switch result {
                case .success(let profileImage?):
                    self.saveProfileImage(profileImage.uiImage)
                    self.imageState = .success(profileImage.image)
                case .success(nil):
                    self.imageState = .empty
                case .failure(let error):
                    self.imageState = .failure(error)
                }
            }
        }
    }
    
    func saveProfileImage(_ image: UIImage) {
        guard let data = image.pngData() else { return }
        let filename = documentsDirectory.appendingPathComponent(kProfileImageFile)
        do {
            try data.write(to: filename)
        } catch {
            os_log(.error, "Failed to save profile image %@", error.localizedDescription)
        }
    }
    
    func loadProfileImage() {
        let imagePath = documentsDirectory.appendingPathComponent(kProfileImageFile)
        
        guard FileManager.default.fileExists(atPath: imagePath.path) else {
            imageState = .empty
            return
        }
        
        do {
            let data = try Data(contentsOf: imagePath)
            guard let uiImage = UIImage(data: data) else { throw TransferError.badImageData }
            imageState = .success(Image(uiImage: uiImage))
            
        } catch {
            imageState = .failure(error)
        }

    }
    
    func clearProfileImage() {
        
        let imagePath = documentsDirectory.appendingPathComponent(kProfileImageFile)
        if FileManager.default.fileExists(atPath: imagePath.path) {
            try? FileManager.default.removeItem(atPath: imagePath.path)
        }
        imageState = .empty
       
    }

    public func clear() {
        
        clearProfileImage()
        firstName = ""
        lastName = ""
        email = ""
        onboarded = false
        
    }
    
}
