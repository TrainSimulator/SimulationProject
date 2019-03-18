### Simulation project for course

Event list:
- time
- type (G, A, D)
- matrix (4*4 from-to)
- station
- trainID

Scenario:
- departure timetable (to be optimized)
- train composition (#1st and #2nd class - to be optimized)
- passenger rate (always the same)
- travel time (always the same)
- prices (always the same)

Indicators:
- waiting time
- income (in CHF)

Functions:
- main: generate scenario, call Simulation(), analyse, plot
- Simulation: implements the discrete time step sim
- newScenario: stores train schedule (to be optimized) and demand info
- newEvent: generates new event (G, A, D)
- Plot*: figures...
