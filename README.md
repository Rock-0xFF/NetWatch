# NetWatch
Project for watch devices in network ,, watch their Status


A simple project that pings network devices, saves their status (Online/Offline) in SQL Server, and keeps a full scan history.

It solves the problem of manually checking which devices are up or down by automating the process on a schedule.

Stack
Python (scanning + database connection)
SQL Server (storage + differential backups)
Note

Automation (scanning every 5 min, backup every 20 min) is set up manually via Windows Task Scheduler and SQL Server Agent — not inside the code itself.
