import SwiftUI
import CoreData

struct AddListView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Binding var isShowing: Bool
    @Binding var listName: String

    var body: some View {
        VStack {
            Text("Add List")
                .font(.headline)
            TextField("List Name", text: $listName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            HStack {
                Button("Cancel") {
                    isShowing = false
                    listName = ""
                }
                Button("Add") {
                    let newList = WorkList(context: viewContext)
                    newList.label = listName
                    newList.createdAt = Date()

                    do {
                        try viewContext.save()
                    } catch {
                        let nsError = error as NSError
                        print("Unresolved error \(nsError), \(nsError.userInfo)")
                    }
                    isShowing = false
                    listName = ""
                }
            }
        }
        .frame(minWidth: 150, minHeight: 200)
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 10)
    }
}
