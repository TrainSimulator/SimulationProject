### Simulation project for course

Event list:
- time
- type (G, A, D)
- station (G, L, B, Z)
- train: -ID?, #passengers(1st, 2nd)

Indicators:
- waiting time
- income (in CHF)

Functions:
- main: regenerate train schedule, call even_list(), analyse, plot
- event_list
- update_event_list
- new_passenger(t, rate, station, class)
- plot_queue
- plot_waiting_hist
