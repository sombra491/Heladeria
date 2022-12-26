#!"E:\Desarrollador\perl\bin\perl.exe"
use strict;
use CGI ':standard';
use DBI;
my $articulo = param('articulo');
my $cantidad = param('cantidad');
my $costo = param('costo');
my $edit = param('edit');
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
my $info;
##select
my $sth = $dbh->prepare("SELECT * FROM articulos WHERE (articulo=?)");
$sth->execute($articulo);
while( my @row = $sth->fetchrow_array ) {
	$articulo_aux=$row[0]; 
	}
$sth->finish;
if($articulo_aux eq ""){
	my $sth1 = $dbh->prepare("INSERT INTO articulos(articulo,cantidad,costo) VALUES (?,?,?)");
	$sth1->execute($articulo , $cantidad, $costo );
	$sth1->finish;
	$info='<h4>Se creo el articulo '.$articulo.'</h4>'.
	'<h4>Con la cantidad '.$cantidad.'</h4>'.
	'<h4>Con el costo '.$costo.'</h4>'.
	'<form method=GET action="./list.pl">
				<input type=submit value="regresar" style="height: 30px;">
			</form>';
}
elsif($edit eq "true"){
	my $sth2 = $dbh->prepare("UPDATE articulos SET cantidad=? where articulo=?");
	$sth2->execute($cantidad, $articulo);
	$sth2->finish;
	$sth2 = $dbh->prepare("UPDATE articulos SET costo=? where articulo=?");
	$sth2->execute($costo, $articulo);
	$sth2->finish;
	$info='<h4>Se modifico el articulo '.$articulo.'</h4>'.
	'<h4>Con la cantidad '.$cantidad.'</h4>'.
	'<h4>Con el costo '.$costo.'</h4>'.
	'<form method=GET action="./list.pl">
				<input type=submit value="regresar" style="height: 30px;">
			</form>';
}
else {$info='<form method=GET action="./new.pl">
			<h4> Articulo</h4> 
			<input type=text name=articulo size=30 maxlength=30 value="" style="height: 30px;" required>
			<h4> Costo</h4> 
			<input type=number name=costo size=30 maxlength=30 value="" style="height: 30px;" step=0.01 min=0 required>
			<h4> Cantidad</h4> 
			<input type=number name=cantidad size=30 maxlength=30 value="" style="height: 30px;" min=0 required>
			<input type=submit value="guardar" style="height: 30px;">
			</form><br><h4>Ya existe el articulo</h4>
			<form method=GET action="./list.pl">
				<input type=submit value="cancelar" style="height: 30px;">
			</form>';}




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
	<title>Creando</title>
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