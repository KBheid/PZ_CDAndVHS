set /p pzDir=Enter path to PZ Directory: 

lua ParseAndSAveMedia.lua %pzDir% %cd%
python ReadRecordedMedia.py %pzDir%
del "intermediate.out"

pause