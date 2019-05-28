@echo off
set h=192.168.1.100
set u=ftpuser
set p=12345678
echo open %h%>ftp.txt
echo %u%>>ftp.txt
echo %p%>>ftp.txt
echo dir>>ftp.txt
echo bye>>ftp.txt
ftp -s:ftp.txt>ftpdir.txt
echo open %h%>ftp.txt
echo %u%>>ftp.txt
echo %p%>>ftp.txt
for /f "tokens=4" %%i in ('findstr "<DIR>" ftpdir.txt') do (
echo cd %%~i>>ftp.txt
echo dir>>ftp.txt
echo cd ..>>ftp.txt)
echo bye>>ftp.txt
ftp -s:ftp.txt>ftpfile.txt
notepad ftpfile.txt