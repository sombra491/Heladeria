#!"E:\Desarrollador\perl\bin\perl.exe"
use strict;
use CGI ':standard';
use DBI;
my $articulo = param('articulo');
my $cantidad = param('cantidad');
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
my $info;
##select
my $sth = $dbh->prepare("SELECT * FROM articulos WHERE (articulo=?)");
$sth->execute($articulo);
while( my @row = $sth->fetchrow_array ) {
	$articulo_aux=$row[0]; 
	$cantidad_aux=$row[1];
	$costo=$row[2];
	}
$sth->finish;
my $error='<form method=GET action="./comprar.pl">
			<h4>'.$articulo.' </h4>
			<input type=hidden name=articulo value="'.$articulo.'">
			<h4> Costo es de'.$costo.'</h4> 
			<h4> Cantidad</h4> 
			<input type=number name=cantidad size=30 maxlength=30 value=$cantidad_aux style="height: 30px;" min=0 required>
			<input type=submit value="guardar" style="height: 30px;">
			</form>
			<form method=GET action="./list.pl">
				<input type=submit value="cancelar" style="height: 30px;">
			</form>';
##condicionales
my $resultante=$cantidad;
my $multi=$cantidad*$costo;
if($cantidad eq ""){$info=$error;}
elsif($resultante>=0){
	$info='	<h4> Articulo</h4> 
	<h4>'.$articulo.'</h4>
	<h4> Costo '.$costo.'</h4>
	<h4> Cantidad '.$cantidad.'</h4>
	<h4> Pago total es  '.$multi.'</h4>
	<form method=GET action="./list.pl">
				<input type=submit value="Retroceder" style="height: 30px;">
			</form>';
}
else {$info=$error.'<h4>No existe esa cantidad de productos</h4>';}



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