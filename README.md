### Simulation project for course

Event list:
- time
- type (G, A, D)
- station (G, L, B, Z)
- train: -ID?, #passengers(1st, 2nd)

Scenario:
- departure timetable (to be optimized)
- train composition (#1st and #2nd class - to be optimized)
- passenger rate (always the same)
- travel time (always the same)
- ticket price (always the same)

Indicators:
- waiting time
- income (in CHF)

Functions:
- main: regenerate train schedule, call queue(), analyse, plot
- event_list
- update_event_list
- new_passenger(t, rate, station, class)
- plot_queue
- plot_waiting_hist
