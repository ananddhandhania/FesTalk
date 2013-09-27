FesTalk
=======

IT's a server program for interacting with Festival - A Text-to-speech system for indic languages

There is a server program that should be run continuosly with the Festival intalled on the server. The script also written 
in perl is called by the server program whenever it recieves a message from a remote client to generate a Text-to-speech file.
It recieves an INI file from remote system using a ftp server.

FTP server needs to be installed. After receiving a ini, the token number that is also the name of ini file is sent to server
which then runs the script to generate a wave file which is then stored on the ftp server of our server. The remote system can access
our ftp server and hence can retrieve the wave file using the same token number.
