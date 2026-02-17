import SwiftUI

struct CharactersView: View {
    @StateObject private var vm = CharactersVM()

    var body: some View {
        NavigationStack {
            Group {
                switch vm.state {
                case .idle, .loading:
                    ProgressView("Loading characters…")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                case .failed(let msg):
                    VStack(spacing: 12) {
                        Text(msg).multilineTextAlignment(.center)
                        Button("Retry") { Task { await vm.firstLoad() } }
                    }
                    .padding()
                case .loaded:
                    List(vm.characters) { c in
                        NavigationLink(value: c) {
                            HStack(spacing: 12) {
                                AsyncImage(url: URL(string: c.image)) { img in
                                    img.resizable().scaledToFill()
                                } placeholder: {
                                    Color.gray.opacity(0.2)
                                }
                                .frame(width: 56, height: 56)
                                .clipShape(RoundedRectangle(cornerRadius: 10))

                                VStack(alignment: .leading, spacing: 4) {
                                    Text(c.name).font(.headline)
                                    Text("\(c.species) • \(c.status)")
                                        .font(.subheadline).foregroundStyle(.secondary)
                                }
                            }
                            .padding(.vertical, 4)
                        }
                    }
                    .listStyle(.insetGrouped)
                }
            }
            .navigationTitle("Rick & Morty")
            .navigationDestination(for: RMCharacter.self) { c in
                CharacterDetailView(character: c)
            }
            .searchable(text: $vm.searchText, prompt: "Search name (e.g. Rick)")
            .onSubmit(of: .search) { Task { await vm.applySearch() } }
            .toolbar {
                ToolbarItemGroup(placement: .topBarTrailing) {
                    Button("Prev") { Task { await vm.prevPage() } }.disabled(!(vm.info?.prev != nil))
                    Button("Next") { Task { await vm.nextPage() } }.disabled(!(vm.info?.next != nil))
                }
            }
            .task { await vm.firstLoad() }
            .refreshable { await vm.applySearch() }
        }
    }
}
