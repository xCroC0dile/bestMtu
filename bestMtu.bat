@echo off
setlocal enabledelayedexpansion

REM Variables to hold the best MTU value and the lowest ping time
set best_mtu=1300
set lowest_ping=9999

REM Loop through MTU values from 1300 to 1500
for /L %%i in (1300,1,1500) do (
    REM Ping the server and extract the time from the result
    for /f "tokens=1,2,3,4,5" %%A in ('ping thetechieguy.com -f -l %%i -n 1 ^| find "time="') do (
        set "ping_time=%%E"

        REM Remove the "ms" and extra spaces from the ping time
        set "ping_time=!ping_time:ms=!"
        set "ping_time=!ping_time: =!"


        REM Check if the current ping time is a valid number
        for /f "delims=" %%F in ("!ping_time!") do (
            set /a ping_value=%%F
        )


        REM Display the current MTU value and its ping time
        echo MTU %%i: !ping_value! ms

        REM Check if the current ping time is lower than the lowest ping time recorded
        if !ping_value! LSS !lowest_ping! (
            set "lowest_ping=!ping_value!"
            set "best_mtu=%%i"
        )
    )
)

REM Display the best MTU value and its corresponding ping time
echo.
echo Best MTU value is !best_mtu! with a ping time of !lowest_ping! ms
REM Calculate MTU and MSS
set /A "mtu_with_overhead=best_mtu + 28"
set /A "mss=mtu_with_overhead - 40"

REM Display the MTU and MSS values
echo MTU (with overhead): !mtu_with_overhead!
echo MSS: !mss!

endlocal
pause
