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
##inicializar variables
my $userName_aux;
my $password_aux;
my $permiso;
my $info;
my $error='
	<form method=POST action="./list.pl">
			<h4> Usuario</h4> 
			<input type=text name=user size=100 maxlength=50 value="" style="height: 30px;" required>
			<h4> Contraseña</h4> 
			<input type=password name=password size=100 maxlength=50 value="" style="height: 30px;" required>
			<br><br>
			<input type=submit value="iniciar" style="height: 30px;">
	</form>';
##select
my $sth = $dbh->prepare("SELECT * FROM usuario WHERE (user=?)");
$sth->execute($user);
while( my @row = $sth->fetchrow_array ) {
	$userName_aux=$row[0]; 
	$password_aux=$row[1];
	$permiso=$row[2];
	}
$sth->finish;
##Condisionales 
if($userName_aux eq ""){$info=$error.'<br><h4>No existe el usuario</h4>';}
elsif($password_aux eq $password){
	$info='<table style="width:100%">
		<tr>
		<th><h2>Nombre del producto</h2></th>
		<th><h2>Costo</h2></th>
		<th><h2>Cantidad</h2></th>
		<th><h2>Comprar</h2></th>';
	if($permiso eq "cliente"){	
		$info=$info.'</tr>';}
	elsif($permiso eq "encargado"){	
		$info=$info.'<th><h2>Editar</h2></th>
		<th><h2>Eliminar</h2></th>
		</tr>';}
	elsif($permiso eq "gerente"){	
		$info=$info.'<th><h2>Editar</h2></th>
		<th><h2>Eliminar</h2></th>
		</tr>';}
	else {$info="";}
	my $sth1 = $dbh->prepare("SELECT * FROM usuario WHERE (user=?)");
	$sth1->execute($user);
	while( my @row = $sth1->fetchrow_array ) {
		
	}
	$sth1->finish;
	
}
else {$info=$error.'<br><h4>Contraseña incorrecta</h4>';}

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
	<title>Registro</title>
	<link rel="stylesheet" type="text/css" href="index.css">
</head>
<body>
<table style="width:100%">
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