import Testing
@testable import sample_apps_ios_json_xcproj

@MainActor
struct GuessingGameTests {
    @Test
    func scoreIsComputedFromTheDistanceToTheTarget() {
        let game = GuessingGame(targetValue: 50)

        #expect(game.check(guess: 55) == 95)
        #expect(game.roundScore == 95)
    }

    @Test("A guess below the target scores the same as one the same distance above")
    func scoreIgnoresTheDirectionOfTheMiss() {
        let game = GuessingGame(targetValue: 50)

        #expect(game.check(guess: 45) == game.check(guess: 55))
    }

    @Suite
    @MainActor
    struct TotalScore {
        @Test
        func totalAddsUpTheRoundScores() {
            let game = GuessingGame(targetValue: 50)

            game.check(guess: 55)
            game.startNewRound(targetValue: 20)
            game.check(guess: 10)

            #expect(game.round == 2)
            #expect(game.totalScore == 185)
        }
    }
}
