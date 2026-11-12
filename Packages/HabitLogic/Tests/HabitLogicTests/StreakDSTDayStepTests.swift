import Testing
import Foundation
@testable import HabitLogic

/// Added with the fix for the injected demo regression on `develop`
/// ("refactor(streak): simplify day stepping"). America/New_York springs
/// forward on 2026-03-08, a 23-hour day.
@Suite struct StreakDSTDayStepTests {
    @Test("America/New_York daily habit done 2026-03-01 through 03-09 has a streak of 9")
    func newYorkSpringForward() {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(identifier: "America/New_York")!
        let start = TestCalendar.instant(calendar, 2026, 3, 1, 20)
        let days = (0..<9).map { calendar.date(byAdding: .day, value: $0, to: start)! }
        let habit = Habit(name: "Read", frequency: .daily, type: .binary, createdAt: start)
        let completions = days.map { Completion(habitID: habit.id, date: $0) }
        let calc = DefaultStreakCalculator(calendar: calendar)

        let current = calc.current(for: habit, completions: completions, asOf: days.last!)
        let best = calc.best(for: habit, completions: completions, asOf: days.last!)
        #expect(current == 9)
        #expect(best == 9)
    }
}
