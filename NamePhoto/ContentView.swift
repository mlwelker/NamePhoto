
import SwiftUI

struct ContentView: View {
    @State private var image: Image?
    @State private var showingImagePicker = false
    
    var body: some View {
        VStack {
            Button("Select Image") {
                showingImagePicker = true
            }
        }
        .padding()
        .sheet(isPresented: $showingImagePicker, content: {
            ImagePicker()
        })
    }
}

#Preview {
    ContentView()
}
