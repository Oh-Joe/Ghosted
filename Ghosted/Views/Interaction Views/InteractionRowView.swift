import SwiftUI

struct InteractionRowView: View {
    
    var interaction: Interaction
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(interaction.title)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                Text(interaction.date, format: .dateTime.month(.abbreviated).day().year())
                    .font(.caption)
            }
            Spacer()
            Text(interaction.content)
                .lineLimit(1)
                .truncationMode(.tail)
        }
        .foregroundStyle(Color.primary)
    }
}
