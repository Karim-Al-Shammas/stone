// FitForge — Chrysler direction (locked in)
// Single Art Deco direction × 7 screens, presented in a design canvas

const SCREENS = [
  { id: 'home', label: 'Home' },
  { id: 'workouts', label: 'Workouts' },
  { id: 'active', label: 'Active Workout' },
  { id: 'progress', label: 'Progress' },
  { id: 'library', label: 'Exercise Library' },
  { id: 'detail', label: 'Exercise Detail' },
  { id: 'picker', label: 'Add Exercise' },
];

function ScreenFrame({ children }) {
  return (
    <div style={{
      width: 390, height: 844, borderRadius: 44, overflow: 'hidden', position: 'relative',
      boxShadow: '0 30px 60px -20px rgba(40,30,15,0.35), 0 0 0 1px rgba(0,0,0,0.08)',
      background: '#fff',
    }}>
      {children}
    </div>
  );
}

function App() {
  return (
    <DesignCanvas>
      <DCSection
        id="chrysler"
        title="FitForge · Chrysler"
        subtitle="Cinzel + Inter · ink nav + button · both chamfers · both arrows"
      >
        {SCREENS.map(scr => (
          <DCArtboard key={scr.id} id={`chrysler-${scr.id}`} label={scr.label} width={390} height={844}>
            <ScreenFrame>
              {window.ChryslerScreen({ screen: scr.id })}
            </ScreenFrame>
          </DCArtboard>
        ))}
      </DCSection>
    </DesignCanvas>
  );
}

ReactDOM.createRoot(document.getElementById('root')).render(<App />);
