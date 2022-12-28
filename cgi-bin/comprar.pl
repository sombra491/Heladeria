#!"E:\Desarrollador\perl\bin\perl.exe"
use strict;
use CGI ':standard';
use DBI;
my $articulo = param('articulo');
my $cantidad = param('cantidad');
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
my $error='
			<form method=POST action="./comprar.pl">
			<input type=hidden name=user value="'.$user.'">
			<input type=hidden name=password value="'.$password.'">
			<h4>'.$articulo.' </h4>
			<input type=hidden name=articulo value="'.$articulo.'">
			<h4> Costo es de S/.'.$costo.'</h4> 
			<h4> Cantidad</h4> 
			<input type=number name=cantidad size=30 maxlength=30 value=$cantidad_aux style="height: 30px;" min=0 required>
			<input type=submit value="comprar" style="height: 30px;" class="send">
			</form>
			<form method=POST action="./list.pl">
				<input type=hidden name=user value="'.$user .'">
				<input type=hidden name=password value="'.$password .'">
				<input type=submit value="regresar" style="height: 30px;" class="send">
			</form>';
##condicionales
my $resultante=$cantidad_aux-$cantidad;
my $multi=$cantidad*$costo;
if($cantidad eq ""){$info=$error;}
elsif($costo eq ""){$info=$error.'<br><h4>ya no existe el producto</h4>';}
elsif($resultante>=0){
	my $sth1 = $dbh->prepare("UPDATE articulos SET cantidad=? where articulo=?");
	$sth1->execute($resultante, $articulo);
	$sth1->finish;
	$info='	<h4> Articulo</h4> 
	<h4>'.$articulo.'</h4>
	<h4> Costo S/.'.$costo.'</h4>
	<h4> Cantidad '.$cantidad.'</h4>
	<h4> Pago total es S/.'.$multi.'</h4>
	<button onclick="window.print()">imprime recibo</button><br><br><br>
	<form method=POST action="./list.pl">
				<input type=hidden name=user value="'.$user .'">
				<input type=hidden name=password value="'.$password .'">
				<input type=submit value="regresar" style="height: 30px;" class="send">
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