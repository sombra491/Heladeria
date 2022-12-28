#!"E:\Desarrollador\perl\bin\perl.exe"
use strict;
use CGI ':standard';
use DBI;
my $userName = param('userName');
my $password = param('password');
my $password2 = param('password2');
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
my $info;
my $error='
	<div class="contenedor">
	<form method=POST action="./register.pl">
			<h4> Usuario</h4> 
			<input type=text name=userName size=100 maxlength=50 value="" style="height: 30px;" required>
			<h4> Contraseña</h4> 
			<input type=password name=password size=100 maxlength=50 value="" style="height: 30px;" required>
			<h4> Contraseña confirmar</h4> 
			<input type=password name=password2 size=100 maxlength=50 value="" style="height: 30px;" required>
			<br><br>
			<input type=submit value="registrarse" style="height: 30px;"  class="send">
	</form></div>';
my $largoContra=length($password);
##select
my $sth = $dbh->prepare("SELECT * FROM usuario WHERE (user=?)");
$sth->execute($userName);
while( my @row = $sth->fetchrow_array ) {
	$userName_aux=$row[0]; 
	}
$sth->finish;
##Condisionales 
if($userName_aux eq $userName){$info=$error.'<br><h4>Ya existe el usuario</h4>';}
elsif($largoContra<8){$info=$error.'<br><h4>Contraseña muy corta minimo 8</h4>';}
elsif($userName eq "GERENTE"){
	my $sth1 = $dbh->prepare("INSERT INTO usuario(user, password, permiso) VALUES (?,?,?)");
	$sth1->execute($userName , $password , "gerente");
	$sth1->finish;
	$info='<h4>Se creo el gerente '.$userName .'</h4>';
}
elsif($password eq $password2){
	my $sth1 = $dbh->prepare("INSERT INTO usuario(user, password, permiso) VALUES (?,?,?)");
	$sth1->execute($userName , $password , "cliente");
	$sth1->finish;
	$info='<h4>Se creo el usuario '.$userName .'</h4>';
}
else {$info=$error.'<br><h4>No conciden las contraseñas</h4>';}
##Nos desconectamos de la BD.
$dbh-> disconnect ||
warn "nFallo al desconectar.nError: $DBI::errstrn";
##imprimir html
print "Content-type: text/html\n\n";
print <<ENDHTML;
<!DOCTYPE html>
<html lang="es">

<head>
	<meta charset="UTF-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1, user-scalable=no,
	 maximun-scale=1, minimun-scale =1">
	<title>Registro</title>
	<link rel="stylesheet" href="../stl2.css">
</head>

<body>
	<div class="container-slider">
		<div class="slider" id="slider">
			<div class="slider__section">
				<img src="../img/img1.jpg" alt="" class="slider__img">
			</div>
			<div class="slider__section">
				<img src="../img/img2.jpg" alt="" class="slider__img">
			</div>
			<div class="slider__section">
				<img src="../img/img3.jpg" alt="" class="slider__img">
			</div>
			<div class="slider__section">
				<img src="../img/img4.jpg " alt="" class="slider__img">
			</div>
		</div>
		<div class="slider__btn slider__btn--right" id="btn-right">&#62</div>
		<div class="slider__btn slider__btn--left" id="btn-left">&#60</div>
	</div>
	<script src="slider.js"></script>
	<table style="width:100%">
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