# HabitLogic

HabitLogic is copied from Kadō by Sébastien Castiel (MIT) at commit 36195ea for fast host-side tests. Demo regressions on `develop` are ours.

- Upstream: https://github.com/scastiel/kado (MIT, see `LICENSE` in this folder).
- Sources come from `Packages/KadoCore/Sources/KadoCore` at 36195ea: `Habit`, `Completion`, `Frequency`, `HabitType`, `Weekday`, `HabitIcon`, `StreakCalculating`, `DefaultStreakCalculator`, `FrequencyEvaluating`, `DefaultFrequencyEvaluator`.
- Tests come from `KadoTests/` at 36195ea: `StreakCalculatorTests`, `FrequencyEvaluatorTests`, `Helpers/TestCalendar.swift`. `import KadoCore` became `@testable import HabitLogic` and `@MainActor` was dropped.
- `HabitColor` is a Foundation-only stand-in: same cases and raw values, without the SwiftUI `Color` mapping, so the package builds and tests on macOS with no UI frameworks.
- The Kadō app does not depend on this package; it still builds against KadoCore.

Run the tests:

```sh
swift test --package-path Packages/HabitLogic
```
