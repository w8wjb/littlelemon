//
//  ProfileImage.swift
//  Little Lemon
//
//  Inspired by https://developer.apple.com/documentation/photokit/bringing_photos_picker_to_your_swiftui_app
//

import SwiftUI
import PhotosUI

struct ProfileImage: View {
	let imageState: ProfileModel.ImageState
	
    let padding: CGFloat
    
    init(imageState: ProfileModel.ImageState, padding: CGFloat) {
        self.imageState = imageState
        self.padding = padding
    }
    
	var body: some View {
		switch imageState {
		case .success(let image):
			image.resizable()
		case .loading:
			ProgressView()
		case .empty:
			Image(systemName: "person.fill")
                .resizable()
                .padding(padding)
                .scaledToFit()
				.foregroundColor(.white)
		case .failure:
			Image(systemName: "exclamationmark.triangle.fill")
                .resizable()
                .padding(padding)
                .scaledToFit()
				.foregroundColor(.white)
		}
	}
}

struct CircularProfileImage: View {
	let imageState: ProfileModel.ImageState
	
    let padding: CGFloat
    
    init(imageState: ProfileModel.ImageState, padding: CGFloat = 40) {
        self.imageState = imageState
        self.padding = padding
    }
    
	var body: some View {
		ProfileImage(imageState: imageState, padding: padding)
            .scaledToFill()
			.clipShape(Circle())
			.background {
				Circle().fill(.primary1.gradient)
			}
	}
}

struct EditableCircularProfileImage: View {
    @ObservedObject var viewModel: ProfileModel
    
    var body: some View {
        CircularProfileImage(imageState: viewModel.imageState)
            .frame(width: 200, height: 200)
            .overlay(alignment: .bottomTrailing) {
                PhotosPicker(selection: $viewModel.imageSelection,
                             matching: .images,
                             photoLibrary: .shared()) {
                    Image(systemName: "pencil.circle.fill")
                        .symbolRenderingMode(.multicolor)
                        .font(.system(size: 50))
                        .foregroundColor(.primary2)
                }.buttonStyle(.borderless)
            }
    }
}
