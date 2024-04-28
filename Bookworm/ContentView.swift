//
//  ContentView.swift
//  Bookworm
//
//  Created by MaćKo on 25/04/2024.
//

import SwiftData
import SwiftUI

struct ContentView: View {
    @Environment(\.modelContext) var modelContext
    @Query(sort: [
        SortDescriptor(\Book.author),
        SortDescriptor(\Book.rating, order: .reverse)
    ]) var books: [Book]

    @State private var showingAddScreen = false

    var body: some View {
        NavigationStack {
            VStack {
                List {
                    ForEach(books) { book in
                        NavigationLink(value: book) {
                            HStack {
                                EmojiRatingView(rating: book.rating)

                                VStack(alignment: .leading) {
                                    Text(book.title)
                                        .font(.headline)

                                    Text(book.author)
                                        .foregroundStyle(.secondary)
                                }
                            }
                        }
                    }
                    .onDelete(perform: deleteBooks)
                }
                .navigationDestination(for: Book.self) { book in
                    DetailBookView(book: book)
                }
            }
            .navigationTitle("Bookworm")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    EditButton()
                }

                ToolbarItem(placement: .topBarTrailing) {
                    Button("Add Book", systemImage: "plus") {
                        showingAddScreen = true
                    }
                }
            }
            .sheet(isPresented: $showingAddScreen) {
                AddBookView()
            }
        }
    }

    func deleteBooks(at offsets: IndexSet) {
        for offset in offsets {
            let book = books[offset]
            modelContext.delete(book)
        }
    }
}

#Preview {
    ContentView()
}
