import SwiftUI


struct ContentView: View {
    @State private var shoppingCart: [String] = []
    var body: some View {
        NavigationView {
            List {
                NavigationLink(destination: ImageContentView()) {
                    Label("Main", systemImage: "photo")
                }
                NavigationLink(destination: Lookbook(shoppingCart: $shoppingCart)) {
                    Label("Lookbook", systemImage: "camera.fill")
                }
                NavigationLink(destination: StoreDetailView()) {
                    Label("Store", systemImage: "cart")
                }
                NavigationLink(destination: ShoppingCartView(shoppingCart: $shoppingCart)) {
                                    Label("Shopping Cart", systemImage: "cart.fill")
                                }
                
            }
            .listStyle(SidebarListStyle())
            .navigationTitle("Sidebar Menu")
            
            Text("Select an item")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}
struct ShoppingCartView: View {
    
    @Binding var shoppingCart: [String]

    var body: some View {
        List {
            ForEach(shoppingCart, id: \.self) { item in
                Image(item)
            }
        }
        .navigationTitle("Shopping Cart")
    }
}

struct ImageContentView: View {
    @State private var rotationAngle: Double = 0

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            Image("alive")
                .resizable()
                .scaledToFit()
                .rotation3DEffect(.degrees(rotationAngle), axis: (x: 0, y: 1, z: 0))
                .aspectRatio(contentMode: .fit)
                .frame(maxWidth: 400, maxHeight: 400)
                .onAppear {
                    let timer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { _ in
                        withAnimation {
                            rotationAngle += 1
                        }
                    }
                    RunLoop.current.add(timer, forMode: .common)
                }
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
    }
}
struct ImageItem: Identifiable {
    let id = UUID()
    let imageName: String
}

struct Lookbook: View {
    @Binding var shoppingCart: [String]
    @State private var selectedImage: ImageItem?

    private let columns: [GridItem] = [
        GridItem(.flexible(), spacing: 10),
        GridItem(.flexible(), spacing: 10)
    ]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 10) {
                ForEach(1..<6) { index in
                    Image("image\(index)")
                        .resizable()
                        .scaledToFit()
                        .cornerRadius(10)
                        .aspectRatio(contentMode: .fit)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .shadow(radius: 5)
                        .padding(8)
                        
                        .onTapGesture {
                            selectedImage = ImageItem(imageName: "image\(index)")
                            
                        }
                }
            }
            .padding()
            .sheet(item: $selectedImage) { imageItem in
                DetailView(shoppingCart: $shoppingCart,imageName: imageItem.imageName)
            }
        }
        .navigationTitle("Lookbook")
    }
}

struct DetailView: View {
    @Binding var shoppingCart: [String]
    @State private var selectedImage: ImageItem?
    var imageName: String
    @State private var indexpass: Int = 0
    var descriptions: [[String]] = [
        [
            "ФУТБОЛКА REPUBLIC ЛАЙМ\nДЖИНСЫ KEÑ КӨК",
            "ФУТБОЛКА REPUBLIC АҚ\nКЕПКА VELVET QR КРЕМДІ\nДЖИНСЫ KEÑ КӨК",
            "ФУТБОЛКА REPUBLIC ҚЫЗЫЛ\nКЕПКА QR STONE GRAY\nШАЛБАР WIDE ҚОЮ КӨК"
            
        ],
        [
            "Description 1 for index 3",
            "Description 2 for index 3",
            "Description 3 for index 3",
            "Description 4 for index 3"
        ],
        [
            "Description 1 for index 4",
            "Description 2 for index 4"
        ],
        [
            "Description 1 for index 5",
            "Description 2 for index 5",
            "Description 3 for index 5"
        ],
        [
            "Description 1 for index 6",
            "Description 2 for index 6",
            "Description 3 for index 6"
        ]
    ]
    var prices: [[String]] = [
        [
            "32 000 ₸",
            "42 000 ₸",
            "43 000 ₸"
            
        ],
        [
            "72 000 ₸",
            "84 000 ₸",
            "54 000 ₸",
            "61 000 ₸"
        ],
        [
            "48 000 ₸",
            "45 000 ₸"
        ],
        [
            "50 000 ₸",
            "51 000 ₸",
            "59 000 ₸"
        ],
        [
            "56 000 ₸",
            "37 000 ₸",
            "36 000 ₸"
        ]
    ]
     var lastElement: Int {
        guard let lastCharacter = imageName.last else {
            return 0 // Default value if the imageName is empty
        }
        return Int(String(lastCharacter)) ?? 0 // Convert the last character to Int, default to 0 if conversion fails
    }
    
    var body: some View {
        HStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 10) {
                    let upperBound = descriptions[lastElement - 1].count + 2
                    ForEach(2..<upperBound,id:\.self) { index in
                        Image("\(imageName)\(index)")
                            .resizable()
                            .scaledToFit()
                            .aspectRatio(contentMode: .fit)
                            .cornerRadius(10)
                            .shadow(radius: 5)
                            .onTapGesture {
                                selectedImage = ImageItem(imageName: imageName)
                                    indexpass=index
                                
                            }
                            
                        
                        Text("\(descriptions[lastElement - 1][index - 2])")
                            .padding(.bottom)
                        
                        Text("Барлығы: \(prices[lastElement-1][index-2])")
                            .foregroundColor(.green)
                            .font(.headline)
                    }
                }
            }
            .padding()
            .sheet(item: $selectedImage) { imageItem in
                Detail2View(shoppingCart: $shoppingCart,nindex: $indexpass,imageName: imageItem.imageName)
            }
            
            Spacer()
        }
    }
}

struct Detail2View: View {
    @Binding var shoppingCart: [String]
    @Binding var nindex: Int
    var imageName: String
    @State private var isAddedToCart = false
    @GestureState private var dragState = DragState.inactive
    @State private var selectedIndex: Int? = nil
    enum DragState {
        case inactive
        case dragging(translation: CGSize)

        var translation: CGSize {
            switch self {
            case .inactive:
                return .zero
            case .dragging(let translation):
                return translation
            }
        }

        var isDragging: Bool {
            if case .dragging = self {
                return true
            }
            return false
        }
    }
    var lastElement: Int {
       guard let lastCharacter = imageName.last else {
           return 0 // Default value if the imageName is empty
       }
       let value = Int(String(lastCharacter)) ?? 0
       print("Last Element: \(imageName)")
       return value
    }


    var body: some View {
        VStack {
            ScrollView{
                VStack(alignment: .leading,spacing : 5){
                    ForEach(1..<4){index in
                        let imagefinal = "image\(lastElement)\(nindex-1)\(index)"
                        
                        Image(imagefinal)
                        
                        .offset(dragState.isDragging ? dragState.translation : .zero)
                        .gesture(
                            DragGesture()
                                .updating($dragState, body: { value, state, _ in
                                    state = .dragging(translation: value.translation)
                                })
                                .onEnded { value in
                                    if value.translation.height > 100 {
                                        withAnimation {
                                            
                                            
                                                
                                                // Add to cart logic here
                                                shoppingCart.append(imagefinal)
                                                isAddedToCart = true
                                            
                                        }
                                    }
                                }
                        )
                        
                        
                    }
               
                }
                
            }


            Button(action: {
                withAnimation {

                }
            }) {
             Image(systemName: "cart") // Shopping cart icon
                                    .padding()
                                    
                                    .cornerRadius(10)
            }
            .padding()

            Spacer()
        }
    }
}






struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
