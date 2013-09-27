#!/usr/bin/perl
use IO::Socket::INET;

# flush after every write
$| = 1;

my ($socket,$client_socket);
my ($peeraddress,$peerport,$output);

use FindBin '$Bin';
open(MYIN,"<${Bin}/system.conf");
foreach $line(<MYIN>)
	{
		my($first,$rest)= split (/\s+/,$line,2);
		chomp $rest;
		${$first}=$rest;
	}
close(MYIN);

# creating object interface of IO::Socket::INET modules which internally does
# socket creation, binding and listening at the specified port address.
$socket = new IO::Socket::INET (
LocalHost => $LOCALHOST,
LocalPort => $PORT,
Proto => 'tcp',
Listen => 50,
ReuseAddr => 1
    ) or die "ERROR in Socket Creation : $!\n";

print "SERVER Waiting client connection on port 5000" ;
while(1)
{

# waiting for new client connection.
$client_socket = $socket->accept();

# get the host and port number of newly connected client.
$peer_address = $client_socket->peerhost();
$peer_port = $client_socket->peerport();

print "Accepted New Client Connection From : $peeraddress, $peerport\n";
# write operation on the newly accepted client.
my $data = "DATA from Server";
# we can also send the data through IO::Socket::INET module,
#$client_socket->send($data);

$data = <$client_socket>;
# we can also read from socket through recv()  in IO::Socket::INET
# $client_socket->recv($data,1024);
print "Received from Client : $data\n";
my($first,$rest)= split (/\s+/,$data,2);
if($data eq 'echo_on') { 
	print $client_socket $data;
}
elsif($first eq 'Delete') {

	$output=system("rm ${home}ini/${rest}");
	system("rm ${home}wave/${rest}");
	system("rm ${home}conf/${rest}");
	print $output>>8;
	print $client_socket $output>>8;
}
else{
### error code 2 if perl script does not exist 
	$filename = "${home}script.pl";
	if(-e $filename )
 		{
 			print $client_socket 0;
			`perl ${home}script.pl ${home}conf/${data}`;
 		}
	else 
		{
			print $client_socket 2;
 		}
}
#$client_socket->close();
}
$socket->close();
