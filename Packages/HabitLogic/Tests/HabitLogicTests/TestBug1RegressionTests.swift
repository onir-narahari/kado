import Testing
import Foundation
@testable import HabitLogic

@Suite struct TestBug1RegressionTests {
    private let calendar = TestCalendar.utc
    private var asOf: Date { TestCalendar.day(0) }

    @Test("Archived negative habit's best streak stops growing after the archive date")
    func archivedNegativeBestStopsAtArchiveDate() {
        // Created day -30, archived day -20, one slip on day -25.
        // Clean run before archiving: days -24 ... -20 = 5 days.
        // The 20 days after archiving must not count as clean days.
        let habit = Habit(
            name: "No soda",
            frequency: .daily,
            type: .negative,
            createdAt: TestCalendar.day(-30),
            archivedAt: TestCalendar.day(-20)
        )
        let completions = [Completion(habitID: habit.id, date: TestCalendar.day(-25))]
        let calc = DefaultStreakCalculator(calendar: calendar)
        #expect(calc.current(for: habit, completions: completions, asOf: asOf) == 5)
        #expect(calc.best(for: habit, completions: completions, asOf: asOf) == 5)
    }

    @Test("Archived negative habit with no slips has a best streak equal to its current streak")
    func archivedNegativeBestEqualsCurrent() {
        let habit = Habit(
            name: "No snacks",
            frequency: .daily,
            type: .negative,
            createdAt: TestCalendar.day(-10),
            archivedAt: TestCalendar.day(-5)
        )
        let calc = DefaultStreakCalculator(calendar: calendar)
        let current = calc.current(for: habit, completions: [], asOf: asOf)
        let best = calc.best(for: habit, completions: [], asOf: asOf)
        #expect(current == 6)
        #expect(best == 6)
    }
}
