import SwiftUI
import CoreData

struct AddItemView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Binding var isShowing: Bool
    @Binding var workList: WorkList
    @State var itemName = ""

    var body: some View {
        VStack {
            Text("Crie um novo item")
                .font(.headline)
            TextField("Nome do item", text: $itemName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            HStack {
                Button("Cancelar") {
                    onExit()
                }
                Button("Adicionar") {
                    let newItem = Item(context: viewContext)
                    newItem.name = itemName
                    newItem.timestamp = Date()
                    newItem.finished = false
                    newItem.list = workList

                    do {
                        try viewContext.save()
                    } catch {
                        let nsError = error as NSError
                        print("Unresolved error \(nsError), \(nsError.userInfo)")
                    }

                    onExit()
                }
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 10)
    }
    
    private func onExit() {
        isShowing = false
        itemName = ""
    }
}
