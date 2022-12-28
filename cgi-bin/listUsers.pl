#!"E:\Desarrollador\perl\bin\perl.exe"
use strict;
use CGI ':standard';
use DBI;
my $user = param('user');
my $password = param('password');
##abrimos el BD
my $host="servidor"; 
my $base_datos="heladeria";  
my $usuario="alumno";  
my $clave="pweb1";  
my $driver="mysql";  
##Conectamos con la BD.
my $dbh = DBI-> connect ("dbi:$driver:database=$base_datos;
host=$host", $usuario, $clave)
|| die "nError al abrir la base datos: $DBI::errstrn";
##select
my $permiso;
	my $sth1 = $dbh->prepare("SELECT * FROM usuario");
	$sth1->execute();
	my $info='<table style="width:100%">
		<tr>
		<th><h2>Usuario</h2></th>
		<th><h2>Permiso</h2></th>
		<th><h2>Editar o eliminar</h2></th></tr>';
	while( my @row = $sth1->fetchrow_array ) {
		$info=$info.'<tr>
		<th><h2>'.$row[0].'</h2></th>
		<th><h2>'.$row[2].'</h2></th>
		<th><form method=POST action="./editUsers.pl">
				<input type=hidden name=user value="'.$user .'">
				<input type=hidden name=password value="'.$password .'">
				<input type=hidden name=userEdit value="'.$row[0].'">
				<input type=submit name=modo value="editar" style="height: 30px;" class="send"> 
				<input type=submit name=modo value="eliminar" style="height: 30px;" class="send">
			</form></th></tr>';
	}
	$sth1->finish;
$info=$info.'</table>';
$info=$info.'<form method=POST action="./list.pl">
				<input type=hidden name=user value="'.$user .'">
				<input type=hidden name=password value="'.$password .'">
				<input type=submit value="regresar" style="height: 30px;" class="send">
			</form>';
	my $sth = $dbh->prepare("SELECT * FROM usuario where(user=?)");
	$sth->execute($user);
	while( my @row = $sth->fetchrow_array ) {
	$permiso=$row[2]; 
	}
$sth->finish;
if ($permiso eq "gerente"){}		
else {$info='No tiene permiso de ver esto';}
##Nos desconectamos de la BD.
$dbh-> disconnect ||
warn "nFallo al desconectar.nError: $DBI::errstrn";
##imprimir html
print "Content-type: text/html\n\n";
print <<ENDHTML;
<html>
<head>
 	<!-- La cabecera del index-->
	<meta charset="utf-8"> 	
	<title>Comprando</title>
	<link rel="stylesheet" href="./../stl.css">
</head>
<body>
<table style="width:100%" class="opciones">
  <tr>
    <th>
	<h2><a href="../index.html">Iniciar seccion</a> </h2></th>
    <th>
	<h2><a href="../registrarse.html">Registrarse</a> </h2></th>
  </tr>
</table>
<center>
$info
</center>
</body>
</html>
ENDHTML