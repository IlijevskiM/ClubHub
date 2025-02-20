//
//  ImageVideoPickerView.swift
//  ClubHub
//
//  Created by Melanija Ilijevski on 6/28/23.
//

import SwiftUI

struct ImageVideoPickerView: UIViewControllerRepresentable {
    // 1
    @Binding var image: UIImage?
    @Binding var videoURL: URL?
    // 2
    @Environment(\.dismiss) var dismiss
    
    // 3
    func makeCoordinator() -> ImageVideoPickerCoordinator {
        ImageVideoPickerCoordinator(self)
    }
    
    // 4
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = context.coordinator
        //imagePickerController.mediaTypes = ["public.image", "public.movie"]
        return imagePickerController
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
}

// 1
class ImageVideoPickerCoordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    let imageVideoPickerView: ImageVideoPickerView
    
    init(_ imageVideoPickerView: ImageVideoPickerView) {
        self.imageVideoPickerView = imageVideoPickerView
    }
    
    // 2
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        imageVideoPickerView.dismiss.callAsFunction()
    }
    
    // 3
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imageVideoPickerView.dismiss.callAsFunction()
        
        guard let image = info[.originalImage] as? UIImage
                //,let video = info[UIImagePickerController.InfoKey.mediaURL] as? URL
        else { return }
        imageVideoPickerView.image = image
        //imageVideoPickerView.videoURL = video
    }
}
