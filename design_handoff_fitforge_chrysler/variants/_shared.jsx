// Shared data + utilities for all FitForge variants
// Loaded before any variant file

window.FF_DATA = {
  user: { name: 'Karim', dateStr: 'Saturday, May 2' },
  stats: { workouts: 4, volumeKg: 12450, streak: 12 },
  recentPRs: [
    { name: 'Bench Press',     weight: 87.5, reps: 5, date: 'Apr 28' },
    { name: 'Barbell Squat',   weight: 120,  reps: 3, date: 'Apr 26' },
    { name: 'Deadlift',        weight: 145,  reps: 1, date: 'Apr 22' },
  ],
  recentWorkouts: [
    { name: 'Push Day',     date: 'Fri',  exCount: 5, sets: 18, mins: 52, tags: ['Bench', 'OHP', 'Tricep'] },
    { name: 'Leg Day',      date: 'Wed',  exCount: 4, sets: 14, mins: 61, tags: ['Squat', 'RDL', 'Lunge'] },
    { name: 'Pull Day',     date: 'Mon',  exCount: 6, sets: 20, mins: 58, tags: ['Deadlift', 'Pullup', 'Row'] },
    { name: 'Shoulders',    date: 'Apr 27', exCount: 4, sets: 15, mins: 44, tags: ['OHP', 'Lat Raise', 'Face Pull'] },
  ],
  active: {
    name: 'Push Day',
    elapsed: '32:14',
    rest: '01:12',
    exercises: [
      { name: 'Bench Press', muscle: 'Chest', sets: [
        { kg: 60, reps: 8, done: true },
        { kg: 80, reps: 6, done: true },
        { kg: 85, reps: 5, done: true },
        { kg: 87.5, reps: 5, done: false },
      ]},
      { name: 'Incline DB Press', muscle: 'Chest', sets: [
        { kg: 22, reps: 10, done: true },
        { kg: 24, reps: 10, done: false },
        { kg: 24, reps: 8,  done: false },
      ]},
      { name: 'Tricep Pushdown', muscle: 'Triceps', sets: [
        { kg: 30, reps: 12, done: false },
        { kg: 30, reps: 12, done: false },
      ]},
    ],
  },
  exercises: [
    { name: 'Bench Press',      muscle: 'Chest',     type: 'Strength' },
    { name: 'Incline DB Press', muscle: 'Chest',     type: 'Strength' },
    { name: 'Cable Fly',        muscle: 'Chest',     type: 'Strength' },
    { name: 'Push-up',          muscle: 'Chest',     type: 'Strength' },
    { name: 'Deadlift',         muscle: 'Back',      type: 'Strength' },
    { name: 'Pull-up',          muscle: 'Back',      type: 'Strength' },
    { name: 'Barbell Row',      muscle: 'Back',      type: 'Strength' },
    { name: 'Overhead Press',   muscle: 'Shoulders', type: 'Strength' },
    { name: 'Lateral Raise',    muscle: 'Shoulders', type: 'Strength' },
    { name: 'Barbell Curl',     muscle: 'Biceps',    type: 'Strength' },
    { name: 'Barbell Squat',    muscle: 'Legs',      type: 'Strength' },
    { name: 'Treadmill Run',    muscle: 'Cardio',    type: 'Cardio'   },
  ],
  muscles: ['All', 'Chest', 'Back', 'Shoulders', 'Biceps', 'Triceps', 'Legs', 'Core', 'Cardio'],
  detail: {
    name: 'Bench Press',
    muscle: 'Chest',
    type: 'Strength',
    desc: 'Lie flat on the bench. Lower the bar to mid-chest with a controlled tempo, then press up explosively. Keep feet planted, back slightly arched, elbows tucked at roughly 60°.',
    cues: ['Retract scapula', 'Bar to nipple line', 'Drive through heels'],
    pr: { weight: 87.5, reps: 5, date: 'Apr 28' },
  },
  // Progress chart points (max weight per session for Bench Press)
  chart: [
    { x: 'Apr 1',  w: 70 },
    { x: 'Apr 5',  w: 72.5 },
    { x: 'Apr 9',  w: 75 },
    { x: 'Apr 13', w: 75 },
    { x: 'Apr 17', w: 80 },
    { x: 'Apr 21', w: 82.5 },
    { x: 'Apr 25', w: 85 },
    { x: 'Apr 28', w: 87.5 },
  ],
};

// Shared mini status bar (just time + battery, light variants)
window.StatusBar = function StatusBar({ color = '#1a1a1a' }) {
  return (
    <div style={{
      display: 'flex', justifyContent: 'space-between', alignItems: 'center',
      padding: '14px 28px 6px', fontSize: 15, fontWeight: 600,
      fontFamily: '-apple-system, "SF Pro", system-ui', color,
      letterSpacing: -0.2,
    }}>
      <span>9:41</span>
      <div style={{ display: 'flex', gap: 6, alignItems: 'center' }}>
        <svg width="17" height="11" viewBox="0 0 17 11"><path d="M0 7.5h2.5v3H0zM4.5 5h2.5v5.5H4.5zM9 2.5h2.5v8H9zM13.5 0H16v10.5h-2.5z" fill={color}/></svg>
        <svg width="15" height="11" viewBox="0 0 15 11"><path d="M7.5 2.8c2 0 3.85.78 5.2 2.06l1-1A8.27 8.27 0 0 0 7.5 1.3 8.27 8.27 0 0 0 1.3 3.86l1 1A7.4 7.4 0 0 1 7.5 2.8Zm0 3.18c1.23 0 2.34.45 3.18 1.2l1-1.04a6.06 6.06 0 0 0-8.36 0l1 1.04A4.6 4.6 0 0 1 7.5 5.98Z" fill={color}/><circle cx="7.5" cy="9.3" r="1.3" fill={color}/></svg>
        <svg width="25" height="12" viewBox="0 0 25 12"><rect x="0.5" y="0.5" width="21" height="11" rx="3" fill="none" stroke={color} strokeOpacity=".4"/><rect x="2" y="2" width="18" height="8" rx="1.5" fill={color}/><path d="M23 4v4c.7-.25 1.3-1 1.3-2s-.6-1.75-1.3-2Z" fill={color} fillOpacity=".5"/></svg>
      </div>
    </div>
  );
};

// Bottom indicator
window.HomeIndicator = function HomeIndicator({ color = 'rgba(0,0,0,0.35)' }) {
  return (
    <div style={{
      position: 'absolute', bottom: 8, left: 0, right: 0,
      display: 'flex', justifyContent: 'center', pointerEvents: 'none',
    }}>
      <div style={{ width: 134, height: 5, borderRadius: 100, background: color }} />
    </div>
  );
};
