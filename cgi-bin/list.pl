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
	<div class="container">
	<form method=POST action="./list.pl">
			<h4> Usuario</h4> 
			<input type=text name=user size=100 maxlength=50 value="" style="height: 30px;" required>
			<h4> Contraseña</h4> 
			<input type=password name=password size=100 maxlength=50 value="" style="height: 30px;" required>
			<br><br>
			<input type=submit value="iniciar" style="height: 30px;"  class="send">
	</form></div>';
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
	my $sth1 = $dbh->prepare("SELECT * FROM articulos");
	$sth1->execute();
	while( my @row = $sth1->fetchrow_array ) {
		$info=$info.'<tr>
		<th><h2>'.$row[0].'</h2></th>
		<th><h2>S/.'.$row[2].'</h2></th>
		<th><h2>'.$row[1].'</h2></th>
		<th><h2><form method=POST action="./comprar.pl">
				<input type=hidden name=user value="'.$user.'">
				<input type=hidden name=password value="'.$password.'">
				<input type=hidden name=articulo value="'.$row[0].'">
				<input type=submit value="comprar" style="height: 30px;" class="send">
			</form></h2></th>';
		if($permiso eq "cliente"){	
		$info=$info.'</tr>';}
		elsif($permiso eq "encargado"){	
		$info=$info.'<th><h2><form method=POST action="./edit.pl">
				<input type=hidden name=user value="'.$user.'">
				<input type=hidden name=password value="'.$password.'">
				<input type=hidden name=articulo value="'.$row[0].'">
				<input type=submit value="editar" style="height: 30px;" class="send">
				</form></h2></th>
				<th><h2><form method=POST action="./delete.pl">
				<input type=hidden name=user value="'.$user.'">
				<input type=hidden name=password value="'.$password.'">
				<input type=hidden name=articulo value="'.$row[0].'">
				<input type=submit value="borrar" style="height: 30px;" class="send">
			</form></h2></th>
		</tr>';}
		elsif($permiso eq "gerente"){	
		$info=$info.'<th><h2><form method=POST action="./edit.pl">
				<input type=hidden name=user value="'.$user.'">
				<input type=hidden name=password value="'.$password.'">
				<input type=hidden name=articulo value="'.$row[0].'">
				<input type=submit value="editar" style="height: 30px;" class="send">
				</form></h2></th>
				<th><h2><form method=POST action="./delete.pl">
				<input type=hidden name=user value="'.$user.'">
				<input type=hidden name=password value="'.$password.'">
				<input type=hidden name=articulo value="'.$row[0].'">
				<input type=submit value="borrar" style="height: 30px;" class="send">
			</form></h2></th>
		</tr>';}
		else {$info="";}
	}
	$sth1->finish;
	$info=$info.'</table>';
	if(($permiso eq "encargado")||($permiso eq "gerente")){
		$info=$info.'<button type="button" onclick="document.getElementById('."'new'".').style.display='."'block'".'" class="send">Nuevo articulo</button>';
			$info=$info.'<div id="new"  style="display:none">
			<form method=POST action="./new.pl">
			<input type=hidden name=user value="'.$user.'">
			<input type=hidden name=password value="'.$password.'">
			<h4> Articulo</h4> 
			<input type=text name=articulo size=30 maxlength=30 value="" style="height: 30px;" required>
			<h4> Costo</h4> 
			<input type=number name=costo size=30 maxlength=30 value="" style="height: 30px;" step=0.01 min=0 required>
			<h4> Cantidad</h4> 
			<input type=number name=cantidad size=30 maxlength=30 value="" style="height: 30px;" min=0 required>
			<input type=submit value="guardar" style="height: 30px;" class="send">
			</form>'.'</div>';
		$info=$info.'<button type="button" onclick="document.getElementById('."'new'".').style.display='."'none'".'" class="send">Ocultar</button>';	
	}
	if($permiso eq "gerente"){
		$info=$info.'<br><br><br><form method=POST action="./listUsers.pl">
			<input type=hidden name=user value="'.$user.'">
			<input type=hidden name=password value="'.$password.'">
			<input type=submit value="Modificar permisos" style="height: 30px;" class="send">
		</form>';
	}
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
	<title>Articulo</title>
	<link rel="stylesheet" href="./../stl.css">
</head>

<body>
	<table style="width:100%" class="opciones">
		<tr>
			<th>
				<h2><a href="../index.html">Iniciar sesión</a> </h2>
			</th>
			<th>
				<h2><a href="../registrarse.html">Registrarse</a> </h2>
			</th>
		</tr>
	</table>
<center>
$info
</center>
</body>
</html>
ENDHTML