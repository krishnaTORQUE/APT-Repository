### 30-06-2018
##### quicks.sh
	Version: 1.4

	Added:
		superclean			"Remove Root / System Cache, Unnecessary Files."

	Update:
		Clean				"Marge with `purge`. 1 day old tmp/files will be deleted."

	Removed:
		'purge' 			"Marge with `clean`."
		`-u`				"User Flag"

##### First-Run-Gnome.sh
	Version: 1.3
	Finetune

##### NMP
	Version: 1.6

	Update:
		php.ini
		phpMyAdmin (4.8.2)

### 26-05-2018
##### quicks.sh
	Version: 1.3
	Stability Improved
	-s Flat `logout` works fine on all system.

##### first-run-gnome.sh
	Version: 1.2
	Stability Improved

##### NMP
	Version: 1.5

	Added:
		Restart
		Stop
		Uninstall
		Mysql 8.0 (By User)
		phpMyAdmin (4.8.1)

	Improved:
		Setup
		Configure Files

	NOTE: Default Uploaded Files 50 & Upload File Size is 100MB (php.ini)

### 13-05-2018
##### quicks.sh
	Version: 1.1

	Added:
		Flags / Options   -c for Commands | -u AS sudo only | -s for shutdown, restart, logout
                          e.g. -u sudo -s restart -c update (Flags can be place in any order)
                          NOTE: -s Flat `logout` only works on Gnome Shell. Only Logout, Shutdown & Restart works fine.

		purge             New Command (Clean All + Remove Cache, Unnecessary Files & Packages & Old unused Kernel.)

#### 04-05-2018
    Initial
		quicks.sh
		first-run-gnome.sh
		Install NMP
