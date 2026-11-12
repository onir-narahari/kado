import Testing
import Foundation
@testable import HabitLogic

/// Regression for the every-N-days streak bug fixed upstream in
/// https://github.com/scastiel/kado/pull/68.
///
/// An "every 2 days" habit done Mon, Tue, Thu: doing it a day early
/// (Tuesday) should restart the cycle, so the next due day is Thursday
/// and Wednesday is never asked for. Before the fix the cycle was pinned
/// to a fixed grid from `createdAt`, Wednesday counted as a missed due
/// day, and the streak broke.
@Suite struct EveryNDaysRegressionTests {
    private let calendar = TestCalendar.utc

    /// `TestCalendar.day(0)` is Monday 2026-04-13.
    private static let monday = 0, tuesday = 1, thursday = 3

    private func mondayTuesdayThursday() -> (Habit, [Completion]) {
        let habit = Habit(
            name: "Water the plants",
            frequency: .everyNDays(2),
            type: .binary,
            createdAt: TestCalendar.day(Self.monday)
        )
        let completions = [Self.monday, Self.tuesday, Self.thursday].map {
            Completion(habitID: habit.id, date: TestCalendar.day($0))
        }
        return (habit, completions)
    }

    @Test("every-2-days habit done Mon, Tue, Thu keeps a current streak of 3")
    func currentStreakSurvivesEarlyCompletion() {
        let (habit, completions) = mondayTuesdayThursday()
        let calc = DefaultStreakCalculator(calendar: calendar)
        let current = calc.current(for: habit, completions: completions, asOf: TestCalendar.day(Self.thursday))
        #expect(current == 3)
    }

    @Test("every-2-days habit done Mon, Tue, Thu has a best streak of 3")
    func bestStreakSurvivesEarlyCompletion() {
        let (habit, completions) = mondayTuesdayThursday()
        let calc = DefaultStreakCalculator(calendar: calendar)
        let best = calc.best(for: habit, completions: completions, asOf: TestCalendar.day(Self.thursday))
        #expect(best == 3)
    }

    @Test("every-2-days habit done Mon, Tue is not due on Wednesday")
    func wednesdayIsNotDueAfterEarlyCompletion() {
        let (habit, completions) = mondayTuesdayThursday()
        let evaluator = DefaultFrequencyEvaluator(calendar: calendar)
        let wednesdayIsDue = evaluator.isDue(habit: habit, on: TestCalendar.day(2), completions: completions)
        #expect(wednesdayIsDue == false)
    }
}
