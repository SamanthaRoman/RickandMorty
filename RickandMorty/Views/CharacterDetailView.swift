import SwiftUI


struct CharacterDetailView: View {
    let character: RMCharacter
    @State private var note: String = ""

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                AsyncImage(url: URL(string: character.image)) { img in
                    img.resizable().scaledToFill()
                } placeholder: { Color.gray.opacity(0.15) }
                .frame(height: 260)
                .clipShape(RoundedRectangle(cornerRadius: 16))

                VStack(alignment: .leading, spacing: 6) {
                    Text(character.name).font(.title2).bold()
                    Text("\(character.species) • \(character.status)")
                        .foregroundStyle(.secondary)
                }

                VStack(alignment: .leading, spacing: 8) {
                    Text("My Notes").font(.headline)
                    TextEditor(text: $note)
                        .frame(minHeight: 140)
                        .overlay(RoundedRectangle(cornerRadius: 8).stroke(.quaternary))
                }

                Button("Save Note") {
                    CharacterNotes.save(note, for: character.id)
                }
                .buttonStyle(.borderedProminent)
            }
            .padding()
        }
        .navigationTitle("Detail")
        .onAppear { note = CharacterNotes.load(for: character.id) }
    }
}
