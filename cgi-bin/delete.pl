#!"E:\Desarrollador\perl\bin\perl.exe"
use strict;
use CGI ':standard';
use DBI;
my $articulo = param('articulo');
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
##operaciones
my $sth = $dbh->prepare("DELETE FROM articulos WHERE (articulo=?)");
$sth->execute($articulo);
$sth->finish;
my $info='<form method=POST action="./list.pl">
				<input type=hidden name=user value="'.$user .'">
				<input type=hidden name=password value="'.$password .'">
				<input type=submit value="regresar" style="height: 30px;" class="send">
			</form>';
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
	<title>Eliminando</title>
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
<h4> se borro correctamente</h4>
</center>
</body>
</html>
ENDHTML