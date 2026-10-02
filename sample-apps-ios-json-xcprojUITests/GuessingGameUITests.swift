import XCTest

// XCUIApplication can only be driven from XCTest, so the UI tests stay on XCTest while the unit
// tests use Swift Testing. One run then reports results from both frameworks.
@MainActor
final class GuessingGameUITests: XCTestCase {
    private var app: XCUIApplication!

    override func setUp() async throws {
        try await super.setUp()
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }

    func testGameScreenShowsItsControls() {
        XCTAssertTrue(app.staticTexts["targetLabel"].waitForExistence(timeout: 5))
        XCTAssertTrue(app.sliders["guessSlider"].exists)
        XCTAssertTrue(app.buttons["hitMeButton"].exists)
        XCTAssertTrue(app.staticTexts["scoreLabel"].exists)
    }

    func testGuessingStartsTheNextRound() async {
        let score = app.staticTexts["scoreLabel"]
        XCTAssertTrue(score.waitForExistence(timeout: 5))
        XCTAssertEqual(score.label, "Round 1, score 0")

        app.buttons["hitMeButton"].tap()

        let nextRound = expectation(
            for: NSPredicate(format: "label BEGINSWITH %@", "Round 2,"),
            evaluatedWith: score
        )
        await fulfillment(of: [nextRound], timeout: 5)
    }
}
