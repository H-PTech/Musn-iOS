//
//  VideoDropView.swift
//  Musn
//
//  Created by 권민재 on 12/28/24.
//
import SwiftUI
import PhotosUI
import AVKit
import AVFoundation

struct VideoDropView: View {
    @State private var isPickerPresented = false
    @State private var selectedVideoURL: URL?
    @State private var thumbnailImage: UIImage?
    @State private var contentDescription: String = ""

    var body: some View {
        VStack {
            Button(action: {
                isPickerPresented = true
            }) {
                if let thumbnail = thumbnailImage {
                    Image(uiImage: thumbnail)
                        .resizable()
                        .scaledToFill()
                        .frame(height: 200)
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.gray, lineWidth: 1)
                        )
                        .padding(.horizontal)
                } else if let videoURL = selectedVideoURL {
                    VideoPlayer(player: AVPlayer(url: videoURL))
                        .frame(height: 200)
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.gray, lineWidth: 1)
                        )
                        .padding(.horizontal)
                } else {
                    Image(systemName: "video.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 200)
                        .foregroundColor(.gray)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.black.opacity(0.1))
                        )
                        .padding(.horizontal)
                }
            }

            TextField("등록할 글을 입력하주세요.", text: $contentDescription)
                .padding()
                .background(Color.black.opacity(0.05))
                .cornerRadius(10)
                .padding(.horizontal)

            Button(action: {
                handleRegistration()
            }) {
                Text("Register Video")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(10)
                    .padding(.horizontal)
            }
            .disabled(selectedVideoURL == nil || contentDescription.isEmpty)
            .opacity((selectedVideoURL == nil || contentDescription.isEmpty) ? 0.5 : 1.0)
        }
        .sheet(isPresented: $isPickerPresented) {
            VideoPicker(selectedVideoURL: $selectedVideoURL, thumbnailImage: $thumbnailImage)
        }
        .padding()
        Spacer()
    }

    private func handleRegistration() {
        print("Video URL: \(selectedVideoURL?.absoluteString ?? "No Video Selected")")
        print("Content Description: \(contentDescription)")
        // 등록 로직 추가
    }
}

struct VideoPicker: UIViewControllerRepresentable {
    @Binding var selectedVideoURL: URL?
    @Binding var thumbnailImage: UIImage?

    func makeUIViewController(context: Context) -> PHPickerViewController {
        var configuration = PHPickerConfiguration()
        configuration.filter = .videos
        configuration.selectionLimit = 1

        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = context.coordinator
        return picker
    }
 
    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }

    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        let parent: VideoPicker

        init(_ parent: VideoPicker) {
            self.parent = parent
        }

        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            picker.dismiss(animated: true)

            guard let provider = results.first?.itemProvider, provider.hasItemConformingToTypeIdentifier("public.movie") else {
                return
            }

            provider.loadFileRepresentation(forTypeIdentifier: "public.movie") { url, error in
                if let url = url {
                    DispatchQueue.main.async {
                        self.parent.selectedVideoURL = url
                    
                        self.parent.thumbnailImage = self.generateThumbnail(for: url)
                    }
                }
            }
        }


        private func generateThumbnail(for videoURL: URL) -> UIImage? {
            let asset = AVAsset(url: videoURL)
            let assetImageGenerator = AVAssetImageGenerator(asset: asset)
            assetImageGenerator.appliesPreferredTrackTransform = true

            let time = CMTime(seconds: 0, preferredTimescale: 60)
            print("Video URL: \(videoURL)")
            do {
                let cgImage = try assetImageGenerator.copyCGImage(at: time, actualTime: nil)
                return UIImage(cgImage: cgImage)
            } catch {
                print("Fail to generate thumbnail: \(error.localizedDescription)")
                return nil
            }
        }
    }
}

#Preview {
    VideoDropView()
}
