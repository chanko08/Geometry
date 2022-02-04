# Geometry
The makings of a geometry related game.

## Development - Windows

### Install LÖVE
- Install LÖVE from https://love2d.org/.
- For Windows, this will likely mean the 64-bit installer.
- The 64-bit installer will put `love.exe` executable in `C:\Program Files\LOVE`.
- Drag this repository folder onto `love.exe` to start the game.

### Add LÖVE to your executable path (optional)
To make editor integration easier, add `C:\Program Files\LOVE` to your `%PATH%` variable.
This allows tooling to run `love.exe` without needing the full path to the executable.
To do this perform the following steps:

- Enter `Win + R` to start the `run` program.
- Type in `sysdm.cpl` and hit enter. This opens **System Properties**.
- Click the **Environment Variables** button on the **Advanced** tab.
- Under `User variables for USERNAME` click the row with `Path` as the variable name and then click **Edit**.
- Click `New` and add the folder that contains `love.exe`. If you used the installer, this is `C:\Program Files\LOVE`.
- Click **Ok** to save changes.

After this you can test run love2d from the command line by typing `love.exe`.