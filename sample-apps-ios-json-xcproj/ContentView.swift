import SwiftUI

struct ContentView: View {
    @State private var game = GuessingGame()
    @State private var guess = 50.0

    var body: some View {
        VStack(spacing: 24) {
            Text("Get as close as you can to: \(game.targetValue)")
                .font(.headline)
                .accessibilityIdentifier("targetLabel")

            Slider(value: $guess, in: 1...100, step: 1)
                .accessibilityIdentifier("guessSlider")

            Button("Hit me") {
                game.check(guess: Int(guess))
                game.startNewRound()
            }
            .buttonStyle(.borderedProminent)
            .accessibilityIdentifier("hitMeButton")

            Text("Round \(game.round), score \(game.totalScore)")
                .monospacedDigit()
                .accessibilityIdentifier("scoreLabel")
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
