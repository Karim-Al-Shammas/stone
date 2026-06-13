import SwiftUI

/// The Chrysler crown: 11 radial spire lines fanning from a center-bottom
/// point, capped by 3 concentric arcs. Scales uniformly to fit (like SVG meet).
struct Spire: View {
    var color: Color = Deco.brass
    var body: some View {
        Canvas { ctx, size in
            let s = min(size.width / 220, size.height / 70)
            ctx.translateBy(x: (size.width - 220 * s) / 2, y: (size.height - 70 * s) / 2)
            ctx.scaleBy(x: s, y: s)
            let cx = 110.0, cy = 70.0

            for i in 0..<11 {
                let a = -Double.pi / 2 + Double(i - 5) * (.pi / 18)
                let r = 64 - abs(Double(i - 5)) * 4
                var p = Path()
                p.move(to: CGPoint(x: cx, y: cy))
                p.addLine(to: CGPoint(x: cx + cos(a) * r, y: cy + sin(a) * r))
                ctx.stroke(p, with: .color(color), lineWidth: 1.2)
            }
            for r in [20.0, 40.0, 56.0] {
                var p = Path()
                for k in 0...28 {
                    let ang = Double.pi + (Double(k) / 28) * .pi   // 180° → 360°, bows upward
                    let pt = CGPoint(x: cx + cos(ang) * r, y: cy + sin(ang) * r)
                    k == 0 ? p.move(to: pt) : p.addLine(to: pt)
                }
                ctx.stroke(p, with: .color(color), lineWidth: 0.8)
            }
        }
    }
}

/// Stepped-pyramid bar used as the picker-sheet crown.
struct StepCrown: Shape {
    func path(in rect: CGRect) -> Path {
        let pts: [(CGFloat, CGFloat)] = [
            (0, 22), (0, 14), (60, 14), (60, 8), (130, 8), (130, 2),
            (260, 2), (260, 8), (330, 8), (330, 14), (390, 14), (390, 22),
        ]
        var p = Path()
        for (i, pt) in pts.enumerated() {
            let x = pt.0 / 390 * rect.width
            let y = pt.1 / 22 * rect.height
            i == 0 ? p.move(to: CGPoint(x: x, y: y)) : p.addLine(to: CGPoint(x: x, y: y))
        }
        p.closeSubpath()
        return p
    }
}

/// A small brass square rotated 45° — bullet / divider accent.
struct DiamondDot: View {
    var size: CGFloat = 6
    var color: Color = Deco.brass
    var body: some View {
        Rectangle()
            .fill(color)
            .frame(width: size, height: size)
            .rotationEffect(.degrees(45))
            .frame(width: size * 1.42, height: size * 1.42)
    }
}

/// 45° hatched stripe fill used for the exercise-detail demo placeholder.
struct HatchFill: View {
    var light: Color = Deco.cream
    var dark: Color = Deco.creamDeep
    var band: CGFloat = 8
    var body: some View {
        Canvas { ctx, size in
            ctx.fill(Path(CGRect(origin: .zero, size: size)), with: .color(light))
            let step = band * 2
            let extent = size.width + size.height
            var offset = -size.height
            while offset < extent {
                var p = Path()
                p.move(to: CGPoint(x: offset, y: 0))
                p.addLine(to: CGPoint(x: offset + size.height, y: size.height))
                ctx.stroke(p, with: .color(dark), lineWidth: band)
                offset += step
            }
        }
    }
}
