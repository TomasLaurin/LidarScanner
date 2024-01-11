import SwiftUI


struct RecordButton: View {
    @Binding var isRecording: Bool

    var body: some View {
        Button(action: {
            isRecording.toggle()
        }) {
            Image(systemName: isRecording ? "stop.circle.fill" : "record.circle.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 80, height: 80)
                .foregroundColor(isRecording ? .red : .blue)
        }
        .buttonStyle(PlainButtonStyle())
    }
}


