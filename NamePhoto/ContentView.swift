
import SwiftUI

struct ContentView: View {
    @State private var image: Image?
    @State private var inputImage: UIImage?
    @State private var showingImagePicker = false
    @State private var showingNameImage = false
    
    @State private var imageName: String = ""
    @State private var namedPhotos = [NamedPhoto]()
    
    let savePath = FileManager.documentsDirectory.appendingPathComponent("SavedInfo")
    let photosSavePath = FileManager.documentsDirectory.appendingPathComponent("SavedPhotos")
    
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
                        
//                        let imageSaver = ImageSaver()
//                        imageSaver.writeToPhotoAlbum(image: inputImage)
                        let newID = UUID()
                        namedPhotos.append(NamedPhoto(id: newID, name: imageName))
                        save()
                        savePhoto(uiImage: inputImage, imgID: "\(newID)")
                        imageName = ""
                        showingNameImage = false
                    }
                    .disabled(imageName.isEmpty)
                    
                    Button(role: .destructive) {
                        inputImage = nil
                        imageName = ""
                        showingNameImage = false
                    } label: {
                        Text("Cancel")
                    }

                } else {
                    Button("Load") {
                        load()
                    }
                    
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
    
    func load() {
        do {
            let data = try Data(contentsOf: savePath)
            namedPhotos = try JSONDecoder().decode([NamedPhoto].self, from: data)
        } catch {
            namedPhotos = [
                NamedPhoto(id: UUID(), name: "A name"),
                NamedPhoto(id: UUID(), name: "B name"),
                NamedPhoto(id: UUID(), name: "C name"),
            ]
        }
    }
    
    func save() {
        do {
            let data = try JSONEncoder().encode(namedPhotos)
            try data.write(to: savePath)
        } catch {
            print("Unable to save data.")
        }
    }
    
    func savePhoto(uiImage: UIImage, imgID: String) {
        if let jpegData = uiImage.jpegData(compressionQuality: 0.8) {
            try? jpegData.write(to: photosSavePath.appendingPathComponent(imgID), options: [.atomic, .completeFileProtection])
        }
    }
    
    func loadPhoto(imgID: String) -> Image {
        do {
            let data = try Data(contentsOf: photosSavePath.appendingPathComponent(imgID))
            let img = try JSONDecoder().decode(UIImage.self, from: data)
        } catch {
            //
        }
    }
}

#Preview {
    ContentView()
}
