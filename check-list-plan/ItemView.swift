import SwiftUI
import CoreData

struct ItemView: View {
    var list: WorkList
    @Environment(\.managedObjectContext) private var viewContext
    @State private var showingAlert = false
    @FetchRequest private var items: FetchedResults<Item>

    init(list: WorkList) {
        self.list = list
        
        _items = FetchRequest(
            entity: Item.entity(),
            sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
            predicate: NSPredicate(format: "list == %@", list.objectID),
            animation: .default)
    }
    
    var body: some View {

        List {
            ForEach(items) { item in
                HStack {
                    Button(action: { markItemAsFinished(item: item) }) {
                        Image(systemName: item.finished ? "checkmark.square" : "square")
                            .foregroundColor(item.finished ? .green : .gray)
                    }
                    .buttonStyle(PlainButtonStyle())

                    Text(item.name ?? "Item sem nome")
                    .foregroundColor(item.finished ? .gray : .primary)
                    .overlay(
                        item.finished ? Rectangle().frame(height: 1).foregroundColor(.gray) : nil
                    )
                }
            }
            .onDelete(perform: deleteItems)
        }
        .toolbar {
            ToolbarItem(placement: .principal) {
                   HStack {
                       Spacer()
                       Spacer()
                       Spacer()
                       Text(list.label ?? "Check list plan")
                       Spacer()
                       Spacer()
                   }
               }

               ToolbarItem(placement: .navigationBarTrailing) {
                   HStack {
                       EditButton()
                       Button(action: addItem) {
                           Label("Add Item", systemImage: "plus")
                       }
                   }
               }
        }
        .overlay(
            Group {
                if showingAlert {
                    AddItemView(isShowing: $showingAlert,  workList: .constant(list))
                }
            }, alignment: .center
        )
    }

    private func addItem() {
        showingAlert = true
    }
    
    private func markItemAsFinished(item: Item) {
        withAnimation {
            item.finished.toggle()
            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                print("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                print("Unresolved error \(nsError), \(nsError.userInfo)")
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
