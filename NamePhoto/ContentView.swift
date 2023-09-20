
import SwiftUI

struct ContentView: View {
    @State private var image: Image?
    @State private var inputImage: UIImage?
    @State private var showingImagePicker = false
    @State private var showingNameImage = false
    
    @State private var imageName: String = ""
    @State private var namedPhotos: [NamedPhoto] = [
        NamedPhoto(id: UUID(), name: "A name"),
        NamedPhoto(id: UUID(), name: "B name"),
        NamedPhoto(id: UUID(), name: "C name"),
    ]
    
    var body: some View {
        NavigationView {
            VStack {
                if showingNameImage {
                    image?
                        .resizable()
                        .scaledToFit()
                    
                    TextField("Image name", text: $imageName)
                    
                    Button("Save Image") {
                        guard let inputImage else { return }
                        
                        let imageSaver = ImageSaver()
                        imageSaver.writeToPhotoAlbum(image: inputImage)
                        namedPhotos.append(NamedPhoto(id: UUID(), name: imageName))
                        imageName = ""
                        showingNameImage = false
                    }
                    .disabled(imageName.isEmpty)
                } else {
                    Button("Select New Image") {
                        showingImagePicker = true
                    }
                    
                    NavigationView {
                        List {
                            ForEach(namedPhotos.sorted()) { photo in
                                NavigationLink {
                                    HStack {
                                        // TODO small image goes here
                                        Text(photo.name)
                                    }
                                } label: {
                                    Text(photo.name)
                                }
                            }
                        }
                    }
                }
            }
            .padding()
            .sheet(isPresented: $showingImagePicker) {
                ImagePicker(image: $inputImage, showingNameImage: $showingNameImage)
            }
            .onChange(of: inputImage, loadImage)
        }
    }
    
    func loadImage() {
        guard let inputImage else { return }
        image = Image(uiImage: inputImage)
    }
}

#Preview {
    ContentView()
}
