import Testing
import Foundation
@testable import HabitLogic

/// Regression for an App Store review (Germany, v1.4):
/// "Allerdings wird schon 1🔥 angezeigt, obwohl man noch gar nichts
/// abgeschlossen hat" — the streak already shows 1🔥 before anything
/// has been completed.
///
/// For a negative ("don't do") habit, a day with no logged slip counts
/// as a success, and that included today, which isn't over yet. So a
/// habit created this morning, or one the user slipped on yesterday,
/// showed 1🔥 for a day nobody has finished.
@Suite struct StreakBeforeDoneRegressionTests {
    private let calendar = TestCalendar.utc
    private var today: Date { TestCalendar.day(0) }

    private func negativeHabit(createdAt offset: Int) -> Habit {
        Habit(
            name: "No social media",
            frequency: .daily,
            type: .negative,
            createdAt: TestCalendar.day(offset)
        )
    }

    @Test("negative habit created today has no current streak yet")
    func newNegativeHabitHasNoCurrentStreak() {
        let habit = negativeHabit(createdAt: 0)
        let calc = DefaultStreakCalculator(calendar: calendar)
        #expect(calc.current(for: habit, completions: [], asOf: today) == 0)
    }

    @Test("negative habit created today has no best streak yet")
    func newNegativeHabitHasNoBestStreak() {
        let habit = negativeHabit(createdAt: 0)
        let calc = DefaultStreakCalculator(calendar: calendar)
        #expect(calc.best(for: habit, completions: [], asOf: today) == 0)
    }

    @Test("negative habit slipped yesterday has no streak today")
    func slipYesterdayMeansNoStreakToday() {
        let habit = negativeHabit(createdAt: -10)
        let calc = DefaultStreakCalculator(calendar: calendar)
        let slip = [Completion(habitID: habit.id, date: TestCalendar.day(-1))]
        #expect(calc.current(for: habit, completions: slip, asOf: today) == 0)
    }

    @Test("negative habit clean since 3 days ago keeps counting today")
    func cleanRunStillIncludesToday() {
        let habit = negativeHabit(createdAt: -3)
        let calc = DefaultStreakCalculator(calendar: calendar)
        #expect(calc.current(for: habit, completions: [], asOf: today) == 4)
    }

    @Test("a binary habit done today still counts today")
    func binaryHabitDoneTodayCounts() {
        let habit = Habit(name: "Run", frequency: .daily, type: .binary, createdAt: TestCalendar.day(0))
        let calc = DefaultStreakCalculator(calendar: calendar)
        let completions = [Completion(habitID: habit.id, date: today)]
        #expect(calc.current(for: habit, completions: completions, asOf: today) == 1)
    }
}
