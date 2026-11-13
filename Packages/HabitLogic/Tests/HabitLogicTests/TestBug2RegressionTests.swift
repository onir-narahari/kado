import Testing
import Foundation
@testable import HabitLogic

@Suite struct TestBug2RegressionTests {
    let evaluator = DefaultFrequencyEvaluator(calendar: TestCalendar.utc)

    @Test("A Monday-only habit logged on Monday does not show in Today on Tuesday")
    func specificDaysLoggedEarlierInWeekStaysHidden() {
        // Day 0 is Monday 2026-04-13; day 1 is Tuesday, same week.
        let habit = Habit(
            name: "Gym",
            frequency: .specificDays([.monday]),
            type: .binary,
            createdAt: TestCalendar.day(-10)
        )
        let completions = [Completion(habitID: habit.id, date: TestCalendar.day(0))]
        let tuesday = TestCalendar.day(1)
        #expect(!evaluator.isDue(habit: habit, on: tuesday, completions: completions))
        #expect(
            evaluator.isDueOrLogged(
                habit: habit, on: tuesday, completions: completions, calendar: TestCalendar.utc
            ) == false
        )
    }

    @Test("A saturated weekly-quota habit shows in Today only on the day it was logged")
    func saturatedQuotaShowsOnlyOnLoggedDay() {
        // Logged Mon, Tue, Wed (days 0, 1, 2). On Thursday (day 3) the
        // trailing window holds 3 → not due, and nothing was logged that day.
        let habit = Habit(
            name: "Run",
            frequency: .daysPerWeek(3),
            type: .binary,
            createdAt: TestCalendar.day(-10)
        )
        let completions = [0, 1, 2].map { Completion(habitID: habit.id, date: TestCalendar.day($0)) }
        let thursday = TestCalendar.day(3)
        #expect(!evaluator.isDue(habit: habit, on: thursday, completions: completions))
        #expect(
            evaluator.isDueOrLogged(
                habit: habit, on: thursday, completions: completions, calendar: TestCalendar.utc
            ) == false
        )
    }
}
