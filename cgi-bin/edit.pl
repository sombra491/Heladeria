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
##inicializar variables
my $articulo_aux;
my $cantidad_aux;
my $costo;
##select
my $sth = $dbh->prepare("SELECT * FROM articulos WHERE (articulo=?)");
$sth->execute($articulo);
while( my @row = $sth->fetchrow_array ) {
	$articulo_aux=$row[0]; 
	$cantidad_aux=$row[1];
	$costo=$row[2];
	}
$sth->finish;
my $registro='<input type=hidden name=user value="'.$user.'">
				<input type=hidden name=password value="'.$password.'">';
my $regreso='<form method=POST action="./list.pl">
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
	<title>Editando</title>
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
<form method=POST action="./new.pl">
				<input type=hidden name=edit value="true">
			$registro
			<h4> Articulo</h4> 
			<h4>$articulo_aux</h4>
			<input type=hidden name=articulo value="$articulo_aux">
			<h4> Costo</h4> 
			<input type=number name=costo size=30 maxlength=30 value=$costo style="height: 30px;" step=0.01 min=0 required>
			<h4> Cantidad</h4> 
			<input type=number name=cantidad size=30 maxlength=30 value=$cantidad_aux style="height: 30px;" min=0 required>
			<input type=submit value="guardar" style="height: 30px;" class="send" >
			</form>
			$regreso
</center>
</body>
</html>
ENDHTML