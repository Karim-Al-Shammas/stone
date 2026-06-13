// Variant I — Chrysler
// Brass + cream + ink. Vertical sunburst spires, fan motifs, geometric linework.
// Type: Poiret One (display) + Inter (body) + DM Mono (numerals)

(function(){
  const C = {
    cream: '#f3ead7',
    creamDeep: '#e8dcc1',
    paper: '#fbf6e9',
    ink: '#1a1612',
    inkSoft: '#3a312a',
    brass: '#b8893a',
    brassDeep: '#8a6321',
    brassLight: '#d4a857',
    gold: '#c89a3e',
    line: 'rgba(26,22,18,0.18)',
    lineSoft: 'rgba(26,22,18,0.08)',
  };
  // Locked-in fonts: Cinzel (display) + Inter (body) + DM Mono (numerals)
  const F = {
    display: '"Cinzel", serif',
    body: '"Inter", system-ui, sans-serif',
    mono: '"DM Mono", "SF Mono", ui-monospace, monospace',
  };
  // Locked-in config: crowns off, ink nav, ink button, both chamfers, both arrows
  const cfg = () => ({ topCrown: false, bottomCrown: false, navColor: 'ink', btnColor: 'ink', btnChamfer: 'both', btnArrow: 'both' });

  // Build a clip-path polygon for the start button.
  // mode: 'both' | 'left' | 'right' | 'none'  (left = BL corner only, right = BR corner only)
  // c = inner chamfer, used as both when both ends rounded
  function btnClip(mode, c) {
    const cl = mode === 'both' || mode === 'left'  ? c : 0;
    const cr = mode === 'both' || mode === 'right' ? c : 0;
    return `polygon(0 0, 100% 0, 100% calc(100% - ${cr}px), calc(100% - ${cr}px) 100%, ${cl}px 100%, 0 calc(100% - ${cl}px))`;
  }
  const S = window.StatusBar;
  const HI = window.HomeIndicator;
  const D = window.FF_DATA;

  // Reusable sunburst/spire decoration (Chrysler crown)
  function Spire({ color = C.brass, w = 220, h = 70, op = 1 }) {
    return (
      <svg width={w} height={h} viewBox="0 0 220 70" style={{ display: 'block', opacity: op }}>
        {[...Array(11)].map((_, i) => {
          const cx = 110, cy = 70;
          const a = -Math.PI/2 + (i - 5) * (Math.PI / 18);
          const r = 64 - Math.abs(i - 5) * 4;
          return <line key={i} x1={cx} y1={cy} x2={cx + Math.cos(a)*r} y2={cy + Math.sin(a)*r} stroke={color} strokeWidth="1.2" />;
        })}
        {[20, 40, 56].map((r, i) => (
          <path key={i} d={`M ${110 - r} 70 A ${r} ${r} 0 0 1 ${110 + r} 70`} fill="none" stroke={color} strokeWidth="0.8" />
        ))}
      </svg>
    );
  }

  // Stepped pyramid (top frame element)
  function StepCrown({ color = C.brass }) {
    return (
      <svg width="100%" height="22" viewBox="0 0 390 22" preserveAspectRatio="none" style={{ display: 'block' }}>
        <path d="M0 22 L0 14 L60 14 L60 8 L130 8 L130 2 L260 2 L260 8 L330 8 L330 14 L390 14 L390 22 Z" fill={color} />
      </svg>
    );
  }

  function DiamondDot({ s = 6, color = C.brass }) {
    return <span style={{ display: 'inline-block', width: s, height: s, background: color, transform: 'rotate(45deg)', verticalAlign: 'middle' }} />;
  }

  function SectionTitle({ children, kicker }) {
    return (
      <div style={{ padding: '0 24px', marginTop: 22 }}>
        {kicker && <div style={{ fontFamily: F.mono, fontSize: 10, letterSpacing: 3, color: C.brassDeep, textTransform: 'uppercase', marginBottom: 6 }}>{kicker}</div>}
        <div style={{ display: 'flex', alignItems: 'center', gap: 10 }}>
          <DiamondDot />
          <div style={{ fontFamily: F.display, fontSize: 22, color: C.ink, letterSpacing: 1.5 }}>{children}</div>
          <div style={{ flex: 1, height: 1, background: C.line }} />
        </div>
      </div>
    );
  }

  // App header (used on most screens)
  function Header({ title, sub }) {
    const { topCrown } = cfg();
    return (
      <div style={{ position: 'relative', padding: topCrown ? '8px 0 18px' : '18px 0 18px', textAlign: 'center', borderBottom: `1px solid ${C.line}` }}>
        {topCrown && <StepCrown />}
        <div style={{ display: 'flex', justifyContent: 'center', marginTop: topCrown ? 14 : 0 }}>
          <Spire w={180} h={44} />
        </div>
        <div style={{ fontFamily: F.display, fontSize: 32, color: C.ink, letterSpacing: 6, marginTop: 4 }}>{title}</div>
        {sub && <div style={{ fontFamily: F.mono, fontSize: 10, color: C.brassDeep, letterSpacing: 4, textTransform: 'uppercase', marginTop: 2 }}>{sub}</div>}
      </div>
    );
  }

  function TabBar({ active }) {
    const { bottomCrown, navColor } = cfg();
    // Color palette for nav bg → derive contrast tokens
    // navColor key: 'paper' | 'ink' | 'brass' | 'brassDeep' | 'cream'
    const palette = {
      paper:     { bg: C.paper,     fg: C.inkSoft,    activeFg: C.brassDeep, glyph: C.brass,     activeGlyph: C.brassDeep, border: C.brass,    crown: C.brass },
      cream:     { bg: C.cream,     fg: C.inkSoft,    activeFg: C.brassDeep, glyph: C.brass,     activeGlyph: C.brassDeep, border: C.brass,    crown: C.brass },
      ink:       { bg: C.ink,       fg: 'rgba(243,234,215,0.55)', activeFg: C.brassLight, glyph: C.brassLight, activeGlyph: C.gold,   border: C.brass,    crown: C.brass },
      brass:     { bg: C.brass,     fg: 'rgba(26,22,18,0.55)',    activeFg: C.ink,       glyph: C.ink,        activeGlyph: C.ink,    border: C.brassDeep, crown: C.brassDeep },
      brassDeep: { bg: C.brassDeep, fg: 'rgba(243,234,215,0.55)', activeFg: C.cream,     glyph: C.brassLight, activeGlyph: C.cream,  border: C.gold,     crown: C.gold },
    };
    const p = palette[navColor] || palette.paper;
    const tabs = [
      { id: 'home', label: 'Home', glyph: '◆' },
      { id: 'workouts', label: 'Forge', glyph: '▲' },
      { id: 'progress', label: 'Charts', glyph: '◈' },
      { id: 'library', label: 'Library', glyph: '❖' },
    ];
    return (
      <div style={{
        position: 'absolute', bottom: 0, left: 0, right: 0,
        background: p.bg, borderTop: `2px solid ${p.border}`,
        paddingBottom: 24,
      }}>
        {bottomCrown && <StepCrown color={p.crown} />}
        <div style={{ display: 'flex', justifyContent: 'space-around', padding: bottomCrown ? '10px 0 4px' : '14px 0 6px' }}>
          {tabs.map(t => (
            <div key={t.id} style={{ textAlign: 'center', color: t.id === active ? p.activeFg : p.fg, opacity: t.id === active ? 1 : 0.7 }}>
              <div style={{ fontSize: 14, color: t.id === active ? p.activeGlyph : p.glyph }}>{t.glyph}</div>
              <div style={{ fontFamily: F.mono, fontSize: 9, letterSpacing: 2, marginTop: 2, textTransform: 'uppercase' }}>{t.label}</div>
            </div>
          ))}
        </div>
      </div>
    );
  }

  // ──────── HOME ────────
  function Home() {
    return (
      <div style={{ background: C.cream, height: '100%', position: 'relative', overflow: 'hidden' }}>
        <S color={C.ink} />
        <Header title="FITFORGE" sub="May · MMXXVI" />
        <div style={{ padding: '20px 24px 130px', overflowY: 'auto', height: 'calc(100% - 178px)' }}>
          {/* Greeting */}
          <div style={{ fontFamily: F.body, fontSize: 13, color: C.inkSoft, letterSpacing: 0.5 }}>Good morning,</div>
          <div style={{ fontFamily: F.display, fontSize: 28, color: C.ink, letterSpacing: 2, marginTop: 2 }}>{D.user.name.toUpperCase()}</div>

          {/* Stats trio — pillared like a building */}
          <div style={{ marginTop: 22, display: 'grid', gridTemplateColumns: '1fr 1fr 1fr', gap: 0, background: C.paper, border: `1px solid ${C.brass}`, borderRadius: 4 }}>
            {[
              { label: 'WEEK', val: D.stats.workouts, unit: 'sessions' },
              { label: 'VOLUME', val: '12.4', unit: 'kt' },
              { label: 'STREAK', val: D.stats.streak, unit: 'days' },
            ].map((s, i) => (
              <div key={i} style={{ padding: '18px 8px 14px', textAlign: 'center', borderRight: i < 2 ? `1px solid ${C.lineSoft}` : 'none', position: 'relative' }}>
                <div style={{ position: 'absolute', top: 0, left: '50%', transform: 'translateX(-50%)', width: 1, height: 6, background: C.brass }} />
                <div style={{ fontFamily: F.mono, fontSize: 9, letterSpacing: 3, color: C.brassDeep }}>{s.label}</div>
                <div style={{ fontFamily: F.display, fontSize: 38, color: C.ink, letterSpacing: 1, lineHeight: 1, marginTop: 6 }}>{s.val}</div>
                <div style={{ fontFamily: F.mono, fontSize: 9, color: C.inkSoft, marginTop: 6, letterSpacing: 1.5 }}>{s.unit}</div>
              </div>
            ))}
          </div>

          {/* Start button */}
          {(() => {
            const { btnColor, btnChamfer, btnArrow } = cfg();
            const btnPal = {
              ink:       { bg: C.ink,       fg: C.cream,    accent: C.brass     },
              brass:     { bg: C.brass,     fg: C.ink,      accent: C.brassDeep },
              brassDeep: { bg: C.brassDeep, fg: C.cream,    accent: C.gold      },
              gold:      { bg: C.gold,      fg: C.ink,      accent: C.brassDeep },
              cream:     { bg: C.paper,     fg: C.ink,      accent: C.brass     },
            };
            const bp = btnPal[btnColor] || btnPal.ink;
            const showL = btnArrow === 'both' || btnArrow === 'left';
            const showR = btnArrow === 'both' || btnArrow === 'right';
            const showB = btnArrow === 'bottom';
            return (
              <div style={{ marginTop: 22, position: 'relative' }}>
                <div style={{
                  padding: '20px 16px', textAlign: 'center', background: bp.bg, color: bp.fg,
                  fontFamily: F.display, fontSize: 18, letterSpacing: 6, position: 'relative',
                  clipPath: btnClip(btnChamfer, 8),
                }}>
                  {showL && <span>▲&nbsp;&nbsp;</span>}BEGIN SESSION{showR && <span>&nbsp;&nbsp;▲</span>}
                  {showB && (
                    <div style={{
                      position: 'absolute', left: '50%', bottom: -1, transform: 'translateX(-50%)',
                      width: 0, height: 0,
                      borderLeft: '8px solid transparent',
                      borderRight: '8px solid transparent',
                      borderTop: `8px solid ${bp.fg}`,
                    }} />
                  )}
                </div>
                <div style={{ position: 'absolute', inset: -3, border: `1px solid ${bp.accent}`, pointerEvents: 'none', clipPath: btnClip(btnChamfer, 11) }} />
              </div>
            );
          })()}

          <SectionTitle kicker="LAUREATES">RECENT RECORDS</SectionTitle>
          <div style={{ marginTop: 10, padding: '0 24px' }} />
          <div style={{ background: C.paper, border: `1px solid ${C.line}`, marginTop: 4 }}>
            {D.recentPRs.map((pr, i) => (
              <div key={i} style={{ display: 'flex', alignItems: 'center', padding: '14px 16px', borderBottom: i < 2 ? `1px solid ${C.lineSoft}` : 'none' }}>
                <div style={{ width: 34, height: 34, border: `1px solid ${C.brass}`, display: 'flex', alignItems: 'center', justifyContent: 'center', color: C.brass, fontFamily: F.display, fontSize: 14, marginRight: 12 }}>{i + 1}</div>
                <div style={{ flex: 1 }}>
                  <div style={{ fontFamily: F.body, fontWeight: 500, fontSize: 14, color: C.ink, letterSpacing: 0.3 }}>{pr.name}</div>
                  <div style={{ fontFamily: F.mono, fontSize: 9, color: C.inkSoft, letterSpacing: 1.5, marginTop: 2 }}>{pr.date.toUpperCase()}</div>
                </div>
                <div style={{ textAlign: 'right' }}>
                  <span style={{ fontFamily: F.display, fontSize: 22, color: C.brassDeep, letterSpacing: 1 }}>{pr.weight}</span>
                  <span style={{ fontFamily: F.mono, fontSize: 9, color: C.inkSoft, letterSpacing: 1.5, marginLeft: 4 }}>KG×{pr.reps}</span>
                </div>
              </div>
            ))}
          </div>

          <SectionTitle kicker="LEDGER">RECENT SESSIONS</SectionTitle>
          <div style={{ marginTop: 10 }}>
            {D.recentWorkouts.slice(0,3).map((w, i) => (
              <div key={i} style={{ background: C.paper, border: `1px solid ${C.line}`, padding: '12px 14px', marginBottom: 6, display: 'flex', alignItems: 'center' }}>
                <div style={{ flex: 1 }}>
                  <div style={{ fontFamily: F.display, fontSize: 16, letterSpacing: 1.5, color: C.ink }}>{w.name.toUpperCase()}</div>
                  <div style={{ fontFamily: F.mono, fontSize: 9, color: C.inkSoft, letterSpacing: 1.5, marginTop: 3 }}>{w.date.toUpperCase()} · {w.exCount} EX · {w.mins}M</div>
                </div>
                <div style={{ color: C.brass, fontSize: 14 }}>›</div>
              </div>
            ))}
          </div>
        </div>
        <TabBar active="home" />
        <HI />
      </div>
    );
  }

  // ──────── WORKOUTS LIST ────────
  function Workouts() {
    return (
      <div style={{ background: C.cream, height: '100%', position: 'relative', overflow: 'hidden' }}>
        <S color={C.ink} />
        <Header title="THE FORGE" sub="Session Ledger" />
        <div style={{ padding: '18px 24px 130px', overflowY: 'auto', height: 'calc(100% - 178px)' }}>
          <div style={{ background: C.ink, color: C.cream, padding: '16px', textAlign: 'center', fontFamily: F.display, fontSize: 16, letterSpacing: 4, marginBottom: 18 }}>
            + &nbsp; NEW SESSION
          </div>
          {D.recentWorkouts.map((w, i) => (
            <div key={i} style={{ background: C.paper, border: `1px solid ${C.line}`, marginBottom: 10, padding: '14px 16px' }}>
              <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'baseline' }}>
                <div style={{ fontFamily: F.display, fontSize: 18, letterSpacing: 1.8, color: C.ink }}>{w.name.toUpperCase()}</div>
                <div style={{ fontFamily: F.mono, fontSize: 9, color: C.brassDeep, letterSpacing: 2 }}>{w.date.toUpperCase()}</div>
              </div>
              <div style={{ display: 'flex', gap: 16, marginTop: 8, fontFamily: F.mono, fontSize: 10, color: C.inkSoft, letterSpacing: 1 }}>
                <span>{w.exCount} EXERCISES</span>
                <span>·</span>
                <span>{w.sets} SETS</span>
                <span>·</span>
                <span>{w.mins} MIN</span>
              </div>
              <div style={{ display: 'flex', gap: 6, marginTop: 10, flexWrap: 'wrap' }}>
                {w.tags.map(t => (
                  <span key={t} style={{ fontFamily: F.body, fontSize: 10, padding: '3px 8px', border: `1px solid ${C.brass}`, color: C.brassDeep, letterSpacing: 0.5 }}>{t}</span>
                ))}
              </div>
            </div>
          ))}
        </div>
        <TabBar active="workouts" />
        <HI />
      </div>
    );
  }

  // ──────── ACTIVE WORKOUT ────────
  function Active() {
    return (
      <div style={{ background: C.cream, height: '100%', position: 'relative', overflow: 'hidden' }}>
        <S color={C.ink} />
        {/* Header bar */}
        <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', padding: '8px 20px 12px', borderBottom: `1px solid ${C.line}` }}>
          <span style={{ fontFamily: F.mono, fontSize: 11, color: C.brassDeep, letterSpacing: 2 }}>‹ CANCEL</span>
          <div style={{ textAlign: 'center' }}>
            <div style={{ fontFamily: F.mono, fontSize: 9, letterSpacing: 3, color: C.inkSoft }}>ELAPSED</div>
            <div style={{ fontFamily: F.display, fontSize: 22, color: C.ink, letterSpacing: 2 }}>{D.active.elapsed}</div>
          </div>
          <span style={{ fontFamily: F.mono, fontSize: 11, color: C.inkSoft, letterSpacing: 2 }}>···</span>
        </div>

        <div style={{ padding: '14px 18px 130px', overflowY: 'auto', height: 'calc(100% - 90px)' }}>
          <div style={{ fontFamily: F.display, fontSize: 26, color: C.ink, letterSpacing: 3, textAlign: 'center' }}>{D.active.name.toUpperCase()}</div>
          <div style={{ display: 'flex', justifyContent: 'center', marginTop: 4 }}>
            <div style={{ width: 60, height: 1, background: C.brass }} />
          </div>

          {/* Rest banner */}
          <div style={{ marginTop: 16, background: C.ink, color: C.cream, padding: '14px 16px', display: 'flex', alignItems: 'center', justifyContent: 'space-between', position: 'relative' }}>
            <div>
              <div style={{ fontFamily: F.mono, fontSize: 9, letterSpacing: 3, color: C.brassLight }}>REST</div>
              <div style={{ fontFamily: F.display, fontSize: 28, letterSpacing: 2, marginTop: 2 }}>{D.active.rest}</div>
            </div>
            <div style={{ display: 'flex', gap: 8 }}>
              <div style={{ width: 36, height: 36, border: `1px solid ${C.brass}`, color: C.brassLight, display: 'flex', alignItems: 'center', justifyContent: 'center' }}>▌▌</div>
              <div style={{ width: 36, height: 36, border: `1px solid ${C.brass}`, color: C.brassLight, display: 'flex', alignItems: 'center', justifyContent: 'center' }}>↺</div>
            </div>
          </div>

          {/* Exercise blocks */}
          {D.active.exercises.map((ex, ei) => (
            <div key={ei} style={{ marginTop: 16, background: C.paper, border: `1px solid ${C.line}` }}>
              <div style={{ padding: '12px 16px', borderBottom: `1px solid ${C.lineSoft}`, display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
                <div>
                  <div style={{ fontFamily: F.display, fontSize: 16, letterSpacing: 1.5, color: C.ink }}>{ex.name.toUpperCase()}</div>
                  <div style={{ fontFamily: F.mono, fontSize: 9, color: C.brassDeep, letterSpacing: 2, marginTop: 2 }}>{ex.muscle.toUpperCase()}</div>
                </div>
                <span style={{ color: C.inkSoft }}>⌫</span>
              </div>
              <div style={{ padding: '10px 16px 12px' }}>
                <div style={{ display: 'grid', gridTemplateColumns: '32px 1fr 1fr 40px', gap: 8, fontFamily: F.mono, fontSize: 9, color: C.inkSoft, letterSpacing: 2, paddingBottom: 6, borderBottom: `1px solid ${C.lineSoft}` }}>
                  <span>SET</span><span style={{ textAlign: 'center' }}>KG</span><span style={{ textAlign: 'center' }}>REPS</span><span></span>
                </div>
                {ex.sets.map((s, si) => (
                  <div key={si} style={{
                    display: 'grid', gridTemplateColumns: '32px 1fr 1fr 40px', gap: 8, alignItems: 'center', padding: '8px 0',
                    borderBottom: si < ex.sets.length - 1 ? `1px solid ${C.lineSoft}` : 'none',
                    background: s.done ? 'rgba(184,137,58,0.08)' : 'transparent',
                  }}>
                    <span style={{ fontFamily: F.display, fontSize: 14, color: C.brassDeep }}>{si + 1}</span>
                    <span style={{ fontFamily: F.display, fontSize: 18, color: C.ink, textAlign: 'center' }}>{s.kg}</span>
                    <span style={{ fontFamily: F.display, fontSize: 18, color: C.ink, textAlign: 'center' }}>{s.reps}</span>
                    <div style={{ width: 28, height: 28, border: `1px solid ${s.done ? C.brass : C.line}`, background: s.done ? C.brass : 'transparent', color: s.done ? C.cream : 'transparent', display: 'flex', alignItems: 'center', justifyContent: 'center', fontSize: 14, marginLeft: 'auto' }}>✓</div>
                  </div>
                ))}
                <div style={{ marginTop: 10, padding: '8px', textAlign: 'center', fontFamily: F.mono, fontSize: 10, color: C.brassDeep, letterSpacing: 2, border: `1px dashed ${C.brass}` }}>+ ADD SET</div>
              </div>
            </div>
          ))}

          <div style={{ marginTop: 16, padding: '14px', textAlign: 'center', fontFamily: F.mono, fontSize: 11, color: C.brassDeep, letterSpacing: 3, border: `1px dashed ${C.brass}`, background: 'rgba(184,137,58,0.05)' }}>+ ADD EXERCISE</div>

          <div style={{ marginTop: 16, padding: '18px', textAlign: 'center', fontFamily: F.display, fontSize: 16, color: C.cream, letterSpacing: 4, background: C.brassDeep }}>
            ✓ &nbsp; CONCLUDE SESSION
          </div>
        </div>
        <HI />
      </div>
    );
  }

  // ──────── PROGRESS ────────
  function Progress() {
    const w = D.chart;
    const max = Math.max(...w.map(p => p.w));
    const min = Math.min(...w.map(p => p.w));
    const range = max - min || 1;
    const W = 320, H = 160, P = 20;
    const xs = w.map((_, i) => P + (i * (W - 2*P)) / (w.length - 1));
    const ys = w.map(p => P + (1 - (p.w - min) / range) * (H - 2*P));
    const path = xs.map((x, i) => `${i === 0 ? 'M' : 'L'} ${x} ${ys[i]}`).join(' ');

    return (
      <div style={{ background: C.cream, height: '100%', position: 'relative', overflow: 'hidden' }}>
        <S color={C.ink} />
        <Header title="CHARTS" sub="Strength Atlas" />
        <div style={{ padding: '18px 20px 130px', overflowY: 'auto', height: 'calc(100% - 178px)' }}>
          <div style={{ fontFamily: F.mono, fontSize: 9, color: C.brassDeep, letterSpacing: 3, textAlign: 'center' }}>EXERCISE</div>
          <div style={{ fontFamily: F.display, fontSize: 26, color: C.ink, letterSpacing: 3, textAlign: 'center', marginTop: 2 }}>BENCH PRESS ▾</div>

          {/* Chart */}
          <div style={{ marginTop: 18, background: C.paper, border: `1px solid ${C.brass}`, padding: '14px 10px 10px', position: 'relative' }}>
            <div style={{ position: 'absolute', top: -1, left: -1, right: -1, height: 6, background: `repeating-linear-gradient(90deg, ${C.brass} 0 8px, transparent 8px 12px)` }} />
            <svg width={W} height={H} viewBox={`0 0 ${W} ${H}`} style={{ display: 'block', margin: '0 auto' }}>
              {[0, 0.25, 0.5, 0.75, 1].map((f, i) => (
                <line key={i} x1={P} y1={P + f * (H - 2*P)} x2={W - P} y2={P + f * (H - 2*P)} stroke={C.line} strokeWidth="0.5" strokeDasharray={i % 2 ? "2 3" : "0"} />
              ))}
              <path d={path} fill="none" stroke={C.brassDeep} strokeWidth="1.5" />
              {xs.map((x, i) => (
                <g key={i}>
                  <rect x={x - 4} y={ys[i] - 4} width={8} height={8} fill={C.cream} stroke={C.brassDeep} strokeWidth="1" transform={`rotate(45 ${x} ${ys[i]})`} />
                </g>
              ))}
            </svg>
            <div style={{ display: 'flex', justifyContent: 'space-between', padding: '0 10px', fontFamily: F.mono, fontSize: 9, color: C.inkSoft, letterSpacing: 1.5, marginTop: 4 }}>
              <span>{w[0].x.toUpperCase()}</span>
              <span>{w[w.length - 1].x.toUpperCase()}</span>
            </div>
          </div>

          <div style={{ marginTop: 12, display: 'grid', gridTemplateColumns: '1fr 1fr 1fr', gap: 8, textAlign: 'center' }}>
            {[
              { l: 'CURRENT', v: '87.5' },
              { l: 'GAINED', v: '+17.5' },
              { l: 'PEAK', v: '87.5' },
            ].map((s,i) => (
              <div key={i} style={{ background: C.paper, border: `1px solid ${C.line}`, padding: '10px 6px' }}>
                <div style={{ fontFamily: F.mono, fontSize: 8, letterSpacing: 2, color: C.brassDeep }}>{s.l}</div>
                <div style={{ fontFamily: F.display, fontSize: 22, color: C.ink, marginTop: 4 }}>{s.v}</div>
              </div>
            ))}
          </div>

          <SectionTitle kicker="HALL OF">RECORDS</SectionTitle>
          <div style={{ background: C.paper, border: `1px solid ${C.line}`, marginTop: 10 }}>
            {D.recentPRs.concat([
              { name: 'Overhead Press', weight: 52.5, reps: 5, date: 'Apr 20' },
              { name: 'Barbell Row', weight: 75, reps: 8, date: 'Apr 18' },
            ]).map((pr, i, arr) => (
              <div key={i} style={{ display: 'flex', alignItems: 'center', padding: '12px 16px', borderBottom: i < arr.length - 1 ? `1px solid ${C.lineSoft}` : 'none' }}>
                <div style={{ width: 28, height: 28, transform: 'rotate(45deg)', border: `1px solid ${C.brass}`, marginRight: 16 }} />
                <div style={{ flex: 1 }}>
                  <div style={{ fontFamily: F.body, fontSize: 14, color: C.ink, fontWeight: 500 }}>{pr.name}</div>
                  <div style={{ fontFamily: F.mono, fontSize: 9, color: C.inkSoft, letterSpacing: 1.5, marginTop: 2 }}>{pr.date.toUpperCase()}</div>
                </div>
                <div style={{ fontFamily: F.display, fontSize: 20, color: C.brassDeep, letterSpacing: 1 }}>{pr.weight}<span style={{ fontFamily: F.mono, fontSize: 9, marginLeft: 4 }}>KG</span></div>
              </div>
            ))}
          </div>
        </div>
        <TabBar active="progress" />
        <HI />
      </div>
    );
  }

  // ──────── LIBRARY ────────
  function Library() {
    return (
      <div style={{ background: C.cream, height: '100%', position: 'relative', overflow: 'hidden' }}>
        <S color={C.ink} />
        <Header title="LIBRARY" sub="Catalogue of Exercises" />
        <div style={{ padding: '14px 20px 130px', overflowY: 'auto', height: 'calc(100% - 178px)' }}>
          <div style={{ background: C.paper, border: `1px solid ${C.line}`, padding: '10px 14px', display: 'flex', alignItems: 'center', gap: 10, marginBottom: 14 }}>
            <span style={{ color: C.brass }}>⌕</span>
            <span style={{ fontFamily: F.body, fontSize: 13, color: C.inkSoft }}>Search the catalogue…</span>
          </div>
          <div style={{ display: 'flex', gap: 6, overflowX: 'auto', marginBottom: 14, paddingBottom: 4 }}>
            {D.muscles.map((m, i) => (
              <span key={m} style={{
                fontFamily: F.mono, fontSize: 10, letterSpacing: 2, padding: '6px 12px', whiteSpace: 'nowrap',
                border: `1px solid ${i === 0 ? C.brass : C.line}`,
                background: i === 0 ? C.ink : C.paper,
                color: i === 0 ? C.cream : C.inkSoft,
              }}>{m.toUpperCase()}</span>
            ))}
          </div>
          {D.exercises.map((e, i) => (
            <div key={i} style={{ display: 'flex', alignItems: 'center', background: C.paper, border: `1px solid ${C.line}`, padding: '12px 14px', marginBottom: 6, gap: 12 }}>
              <div style={{ width: 36, height: 36, border: `1px solid ${C.brass}`, display: 'flex', alignItems: 'center', justifyContent: 'center', fontFamily: F.display, fontSize: 14, color: C.brassDeep }}>
                {e.muscle.charAt(0)}
              </div>
              <div style={{ flex: 1 }}>
                <div style={{ fontFamily: F.body, fontSize: 14, fontWeight: 500, color: C.ink, letterSpacing: 0.2 }}>{e.name}</div>
                <div style={{ fontFamily: F.mono, fontSize: 9, color: C.brassDeep, letterSpacing: 1.5, marginTop: 2 }}>{e.muscle.toUpperCase()} · {e.type.toUpperCase()}</div>
              </div>
              <span style={{ color: C.inkSoft }}>›</span>
            </div>
          ))}
        </div>
        <TabBar active="library" />
        <HI />
      </div>
    );
  }

  // ──────── DETAIL ────────
  function Detail() {
    const e = D.detail;
    return (
      <div style={{ background: C.cream, height: '100%', position: 'relative', overflow: 'hidden' }}>
        <S color={C.ink} />
        <div style={{ padding: '8px 20px 12px', display: 'flex', alignItems: 'center', borderBottom: `1px solid ${C.line}` }}>
          <span style={{ fontFamily: F.mono, fontSize: 11, color: C.brassDeep, letterSpacing: 2 }}>‹ LIBRARY</span>
        </div>
        <div style={{ padding: '24px 24px 130px', overflowY: 'auto', height: 'calc(100% - 56px)' }}>
          <div style={{ display: 'flex', justifyContent: 'center' }}>
            <Spire w={140} h={50} />
          </div>
          <div style={{ fontFamily: F.mono, fontSize: 9, color: C.brassDeep, letterSpacing: 3, textAlign: 'center', marginTop: 6 }}>{e.muscle.toUpperCase()} · {e.type.toUpperCase()}</div>
          <div style={{ fontFamily: F.display, fontSize: 36, color: C.ink, letterSpacing: 3, textAlign: 'center', marginTop: 4 }}>{e.name.toUpperCase()}</div>
          <div style={{ display: 'flex', justifyContent: 'center', marginTop: 6, gap: 4 }}>
            <DiamondDot s={5} /><DiamondDot s={7} /><DiamondDot s={5} />
          </div>

          {/* Placeholder demo image */}
          <div style={{ marginTop: 22, height: 180, background: `repeating-linear-gradient(45deg, ${C.creamDeep} 0 8px, ${C.cream} 8px 16px)`, border: `1px solid ${C.brass}`, display: 'flex', alignItems: 'center', justifyContent: 'center', fontFamily: F.mono, fontSize: 10, color: C.brassDeep, letterSpacing: 3 }}>
            [ EXERCISE DEMONSTRATION ]
          </div>

          <div style={{ marginTop: 22 }}>
            <div style={{ fontFamily: F.mono, fontSize: 9, color: C.brassDeep, letterSpacing: 3 }}>FORM</div>
            <div style={{ height: 1, background: C.brass, marginTop: 4, marginBottom: 10 }} />
            <p style={{ fontFamily: F.body, fontSize: 14, lineHeight: 1.65, color: C.inkSoft, margin: 0 }}>{e.desc}</p>
          </div>

          <div style={{ marginTop: 22 }}>
            <div style={{ fontFamily: F.mono, fontSize: 9, color: C.brassDeep, letterSpacing: 3 }}>CUES</div>
            <div style={{ height: 1, background: C.brass, marginTop: 4, marginBottom: 10 }} />
            {e.cues.map((c, i) => (
              <div key={i} style={{ display: 'flex', gap: 12, padding: '8px 0', borderBottom: i < e.cues.length - 1 ? `1px solid ${C.lineSoft}` : 'none' }}>
                <span style={{ fontFamily: F.display, fontSize: 14, color: C.brass, letterSpacing: 1 }}>{`0${i + 1}`}</span>
                <span style={{ fontFamily: F.body, fontSize: 14, color: C.ink }}>{c}</span>
              </div>
            ))}
          </div>

          <div style={{ marginTop: 24, padding: '16px', background: C.ink, color: C.cream, textAlign: 'center' }}>
            <div style={{ fontFamily: F.mono, fontSize: 9, color: C.brassLight, letterSpacing: 3 }}>YOUR RECORD</div>
            <div style={{ fontFamily: F.display, fontSize: 32, letterSpacing: 2, marginTop: 4 }}>{e.pr.weight} <span style={{ fontFamily: F.mono, fontSize: 12 }}>KG × {e.pr.reps}</span></div>
            <div style={{ fontFamily: F.mono, fontSize: 9, color: C.brassLight, letterSpacing: 2, marginTop: 4 }}>{e.pr.date.toUpperCase()}</div>
          </div>
        </div>
        <HI />
      </div>
    );
  }

  // ──────── PICKER MODAL ────────
  function Picker() {
    return (
      <div style={{ background: 'rgba(26,22,18,0.45)', height: '100%', position: 'relative', overflow: 'hidden' }}>
        <S color={C.cream} />
        {/* Background app peek */}
        <div style={{ position: 'absolute', inset: 0, top: 38, opacity: 0.18, filter: 'blur(2px)' }}>
          <div style={{ background: C.cream, height: '100%' }}>
            <Header title="FITFORGE" />
          </div>
        </div>
        {/* Modal */}
        <div style={{
          position: 'absolute', bottom: 0, left: 0, right: 0, background: C.paper,
          borderTop: `2px solid ${C.brass}`, paddingBottom: 30, maxHeight: '78%',
          display: 'flex', flexDirection: 'column',
        }}>
          <StepCrown />
          <div style={{ padding: '14px 20px 6px', textAlign: 'center' }}>
            <div style={{ fontFamily: F.mono, fontSize: 9, color: C.brassDeep, letterSpacing: 3 }}>SELECT</div>
            <div style={{ fontFamily: F.display, fontSize: 24, color: C.ink, letterSpacing: 3, marginTop: 2 }}>ADD EXERCISE</div>
          </div>
          <div style={{ padding: '6px 20px' }}>
            <div style={{ background: C.cream, border: `1px solid ${C.line}`, padding: '10px 14px', display: 'flex', alignItems: 'center', gap: 10, marginBottom: 10 }}>
              <span style={{ color: C.brass }}>⌕</span>
              <span style={{ fontFamily: F.body, fontSize: 13, color: C.inkSoft }}>Search…</span>
            </div>
            <div style={{ display: 'flex', gap: 6, overflowX: 'auto', marginBottom: 8, paddingBottom: 4 }}>
              {D.muscles.slice(0, 6).map((m, i) => (
                <span key={m} style={{
                  fontFamily: F.mono, fontSize: 10, letterSpacing: 2, padding: '5px 10px',
                  border: `1px solid ${i === 0 ? C.brass : C.line}`,
                  background: i === 0 ? C.ink : 'transparent', color: i === 0 ? C.cream : C.inkSoft,
                }}>{m.toUpperCase()}</span>
              ))}
            </div>
          </div>
          <div style={{ overflowY: 'auto', padding: '0 20px 12px' }}>
            {D.exercises.slice(0, 7).map((e, i) => (
              <div key={i} style={{ display: 'flex', alignItems: 'center', padding: '12px 0', borderBottom: `1px solid ${C.lineSoft}` }}>
                <div style={{ flex: 1 }}>
                  <div style={{ fontFamily: F.body, fontSize: 14, color: C.ink, fontWeight: 500 }}>{e.name}</div>
                  <div style={{ fontFamily: F.mono, fontSize: 9, color: C.brassDeep, letterSpacing: 1.5, marginTop: 2 }}>{e.muscle.toUpperCase()}</div>
                </div>
                <div style={{ width: 28, height: 28, border: `1px solid ${C.brass}`, color: C.brass, display: 'flex', alignItems: 'center', justifyContent: 'center', fontSize: 14 }}>+</div>
              </div>
            ))}
          </div>
        </div>
        <HI color={C.cream} />
      </div>
    );
  }

  window.ChryslerScreen = function ChryslerScreen({ screen }) {
    let inner = null;
    if (screen === 'home') inner = <Home />;
    else if (screen === 'workouts') inner = <Workouts />;
    else if (screen === 'active') inner = <Active />;
    else if (screen === 'progress') inner = <Progress />;
    else if (screen === 'library') inner = <Library />;
    else if (screen === 'detail') inner = <Detail />;
    else if (screen === 'picker') inner = <Picker />;
    return <div className="chrysler-root" style={{ height: '100%' }}>{inner}</div>;
  };
})();
