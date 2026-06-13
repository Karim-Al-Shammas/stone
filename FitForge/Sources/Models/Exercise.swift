import Foundation

/// A catalog exercise. The catalog is static, mirroring the original web app.
struct Exercise: Identifiable, Hashable {
    let id: String
    let name: String
    let muscle: String
    let type: ExerciseType
    let desc: String

    enum ExerciseType: String {
        case strength
        case cardio
    }

    /// Form cues derived from the description's sentences (max 3).
    var cues: [String] {
        desc.split(separator: ".")
            .map { $0.trimmingCharacters(in: .whitespaces) }
            .filter { !$0.isEmpty }
            .prefix(3)
            .map { String($0) }
    }

    static func byId(_ id: String) -> Exercise? {
        all.first { $0.id == id }
    }

    static let muscleGroups = [
        "Chest", "Back", "Shoulders", "Biceps", "Triceps", "Legs", "Core", "Cardio",
    ]

    static let all: [Exercise] = [
        .init(id: "bench", name: "Bench Press", muscle: "Chest", type: .strength,
              desc: "Lie flat on bench. Lower bar to mid-chest, press up. Keep feet flat, back slightly arched."),
        .init(id: "incline-db", name: "Incline DB Press", muscle: "Chest", type: .strength,
              desc: "Set bench to 30-45°. Press dumbbells up from shoulder level. Control the descent."),
        .init(id: "chest-fly", name: "Cable Fly", muscle: "Chest", type: .strength,
              desc: "Set cables at shoulder height. Bring handles together in a hugging motion. Squeeze at center."),
        .init(id: "pushup", name: "Push-up", muscle: "Chest", type: .strength,
              desc: "Hands shoulder-width. Lower chest to floor keeping body rigid. Push back up."),
        .init(id: "deadlift", name: "Deadlift", muscle: "Back", type: .strength,
              desc: "Hinge at hips, grip bar outside knees. Drive through heels, extend hips and knees together."),
        .init(id: "pullup", name: "Pull-up", muscle: "Back", type: .strength,
              desc: "Hang from bar, palms forward. Pull chin above bar by driving elbows down. Control descent."),
        .init(id: "row", name: "Barbell Row", muscle: "Back", type: .strength,
              desc: "Hinge forward 45°. Pull bar to lower chest, squeeze shoulder blades. Lower with control."),
        .init(id: "lat-pull", name: "Lat Pulldown", muscle: "Back", type: .strength,
              desc: "Grip bar wide, lean back slightly. Pull to upper chest, squeezing lats. Return slowly."),
        .init(id: "ohp", name: "Overhead Press", muscle: "Shoulders", type: .strength,
              desc: "Press barbell from front shoulders to overhead lockout. Keep core braced throughout."),
        .init(id: "lat-raise", name: "Lateral Raise", muscle: "Shoulders", type: .strength,
              desc: "Raise dumbbells to sides until arms parallel to floor. Slight bend in elbows."),
        .init(id: "face-pull", name: "Face Pull", muscle: "Shoulders", type: .strength,
              desc: "Pull rope to face height, separating hands. Squeeze rear delts. Great for posture."),
        .init(id: "curl", name: "Barbell Curl", muscle: "Biceps", type: .strength,
              desc: "Curl bar from thighs to shoulders. Keep elbows pinned to sides. Lower with control."),
        .init(id: "hammer-curl", name: "Hammer Curl", muscle: "Biceps", type: .strength,
              desc: "Curl dumbbells with neutral grip (palms facing). Targets brachialis and forearms."),
        .init(id: "tricep-push", name: "Tricep Pushdown", muscle: "Triceps", type: .strength,
              desc: "Push cable attachment down from chest level. Lock out arms, squeeze triceps."),
        .init(id: "skull-crush", name: "Skull Crusher", muscle: "Triceps", type: .strength,
              desc: "Lie flat, lower EZ bar to forehead by bending elbows. Extend back up."),
        .init(id: "squat", name: "Barbell Squat", muscle: "Legs", type: .strength,
              desc: "Bar on upper back. Squat to parallel or below, driving knees out. Stand back up."),
        .init(id: "leg-press", name: "Leg Press", muscle: "Legs", type: .strength,
              desc: "Feet shoulder-width on platform. Lower until 90° knee bend. Press back up."),
        .init(id: "rdl", name: "Romanian Deadlift", muscle: "Legs", type: .strength,
              desc: "Hinge at hips, lowering bar along legs. Feel hamstring stretch. Drive hips forward to stand."),
        .init(id: "lunge", name: "Walking Lunge", muscle: "Legs", type: .strength,
              desc: "Step forward into lunge position. Both knees at 90°. Push off front foot to next step."),
        .init(id: "leg-curl", name: "Leg Curl", muscle: "Legs", type: .strength,
              desc: "Lie prone on machine. Curl pad toward glutes. Squeeze hamstrings at top."),
        .init(id: "plank", name: "Plank", muscle: "Core", type: .strength,
              desc: "Forearms and toes on floor. Keep body straight from head to heels. Hold position."),
        .init(id: "cable-crunch", name: "Cable Crunch", muscle: "Core", type: .strength,
              desc: "Kneel at cable machine. Crunch down bringing elbows to knees. Control the return."),
        .init(id: "hanging-leg", name: "Hanging Leg Raise", muscle: "Core", type: .strength,
              desc: "Hang from bar. Raise legs to parallel or higher. Lower with control, no swinging."),
        .init(id: "run", name: "Treadmill Run", muscle: "Cardio", type: .cardio,
              desc: "Maintain steady pace for target duration. Keep upright posture, land midfoot."),
        .init(id: "bike", name: "Stationary Bike", muscle: "Cardio", type: .cardio,
              desc: "Pedal at consistent RPM. Adjust resistance for intervals. Great low-impact option."),
        .init(id: "jump-rope", name: "Jump Rope", muscle: "Cardio", type: .cardio,
              desc: "Light bounces on balls of feet. Wrists drive the rope. Excellent conditioning tool."),
    ]
}
