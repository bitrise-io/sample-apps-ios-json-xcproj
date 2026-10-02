import Observation

/// Scoring is deliberately deterministic: every round is driven by a target the caller can pass in,
/// so tests never have to stub randomness.
@Observable
final class GuessingGame {
    static let range = 1...100

    private(set) var round: Int
    private(set) var targetValue: Int
    private(set) var roundScore: Int
    private(set) var totalScore: Int

    init(targetValue: Int = Int.random(in: GuessingGame.range)) {
        round = 1
        self.targetValue = targetValue
        roundScore = 0
        totalScore = 0
    }

    @discardableResult
    func check(guess: Int) -> Int {
        let distance = abs(targetValue - guess)
        roundScore = 100 - distance
        totalScore += roundScore

        return roundScore
    }

    func startNewRound(targetValue: Int = Int.random(in: GuessingGame.range)) {
        round += 1
        self.targetValue = targetValue
        roundScore = 0
    }
}
