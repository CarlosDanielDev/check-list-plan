import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @State private var showingAlert = false
    @State private var listName = ""
    @State private var updateFlag = false

    @FetchRequest(
        entity: WorkList.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \WorkList.label, ascending: true)],
        animation: .default)
    private var lists: FetchedResults<WorkList>

    var body: some View {
        NavigationView {
            List {
                ForEach(lists) { list in
                    NavigationLink(destination: ItemView(list: list)) {
                        HStack {
                            Text(list.label ?? "Lista sem nome")
                            Spacer()
                
                            let progressValue = calculateProgress(for: list)
                            
                            if progressValue == -1 {
                                Image(systemName: "minus.circle.fill")
                                    .foregroundColor(.gray)
                            } else if progressValue < 1 {
                                CircularProgressBar(progress: progressValue)
                            } else {
                                Image(systemName: "checkmark.seal.fill")
                                    .foregroundColor(.green)
                            }
                        }
                    }
                  }
                .onDelete(perform: deleteLists)
                .onChange(of: lists.count) { _ in
                    updateFlag.toggle()
                }
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                       HStack {
                           Spacer()
                           Spacer()
                           Text("Check List Plan")
                           Spacer()
                       }
                   }

                   ToolbarItem(placement: .navigationBarTrailing) {
                       HStack {
                           EditButton()
                           Button(action: addList) {
                               Label("Add Item", systemImage: "plus")
                           }
                       }
                   }
               
            }
            
        }.overlay(
            Group {
                if showingAlert {
                    AddListView(isShowing: $showingAlert, listName: $listName)
                }
            }, alignment: .center
        )
    }

    func calculateProgress(for list: WorkList) -> Double {

        let completedItems = list.items?.filter { ($0 as! Item).finished }.count ?? 0

        let totalItems = list.items?.count ?? 0
        return totalItems > 0 ? Double(completedItems) / Double(totalItems) : -1
    }
    
    private func addList() {
        showingAlert = true
    }

    private func deleteLists(offsets: IndexSet) {
        withAnimation {
            offsets.map { lists[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
