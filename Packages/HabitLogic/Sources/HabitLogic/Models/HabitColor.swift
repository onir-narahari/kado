import Foundation

/// Foundation-only stand-in for KadoCore's `HabitColor`.
///
/// The original (Packages/KadoCore/Sources/KadoCore/Models/HabitColor.swift)
/// imports SwiftUI and maps each case to a `Color`. HabitLogic only needs
/// the identity of the color so `Habit` compiles on a plain macOS host,
/// so the SwiftUI `color` property is dropped. Cases and raw values match
/// the original.
nonisolated public enum HabitColor: String, Codable, Sendable, Hashable, CaseIterable {
    case red
    case orange
    case yellow
    case green
    case mint
    case teal
    case blue
    case purple
}
