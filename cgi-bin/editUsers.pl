#!"E:\Desarrollador\perl\bin\perl.exe"
use strict;
use CGI ':standard';
use DBI;
my $user = param('user');
my $userEdit = param('userEdit');
my $password = param('password');
my $modo = param('modo');
my $nuevoPermiso = param('nuevoPermiso');
##abrimos el BD
my $host="servidor"; 
my $base_datos="heladeria";  
my $usuario="alumno";  
my $clave="pweb1";  
my $driver="mysql";  
##Conectamos con la BD.
my $info;
my $dbh = DBI-> connect ("dbi:$driver:database=$base_datos;
host=$host", $usuario, $clave)
|| die "nError al abrir la base datos: $DBI::errstrn";
##condicionales
	my $permiso;
	my $sth = $dbh->prepare("SELECT * FROM usuario where(user=?)");
	$sth->execute($user);
	while( my @row = $sth->fetchrow_array ) {
	$permiso=$row[2]; 
	}
$sth->finish;
if ($permiso eq "gerente"){
if($modo eq "eliminar"){
my $sth1 = $dbh->prepare("DELETE FROM usuario WHERE (user=?)");
$sth1->execute($userEdit);
$sth1->finish;
$info='<h4>Se borro la cuenta '.$userEdit.'</h4>
<form method=POST action="./list.pl">
				<input type=hidden name=user value="'.$user .'">
				<input type=hidden name=password value="'.$password .'">
				<input type=submit value="regresar" style="height: 30px;" class="send">
			</form>';
}
elsif($nuevoPermiso eq ""){
$info='<form method=POST action="./editUsers.pl">
				<h4>'.$userEdit.'</h4>
				<input type=hidden name=user value="'.$user .'">
				<input type=hidden name=password value="'.$password .'">
				<input type=hidden name=userEdit value="'.$userEdit.'">
				<input type=hidden name=modo value="editar">
				<select name="nuevoPermiso">
				<option>cliente</option>
				<option>encargado</option>
				<option>gerente</option>
				</select>
				<input type=submit value="Cambiar" style="height: 30px;" class="send">
				</form>
				<form method=POST action="./list.pl">
				<input type=hidden name=user value="'.$user .'">
				<input type=hidden name=password value="'.$password .'">
				<input type=submit value="regresar" style="height: 30px;" class="send">
				</form>'
}
elsif(($nuevoPermiso eq "cliente")||($nuevoPermiso eq "encargado")||($nuevoPermiso eq "gerente")){
	my $sth2 = $dbh->prepare("UPDATE usuario SET permiso=? where user=?");
	$sth2->execute($nuevoPermiso, $userEdit );
	$sth2->finish;
	$info='<h4>Se cambio el permiso de '.$userEdit.' a '. $nuevoPermiso.'</h4>
			<form method=POST action="./list.pl">
				<input type=hidden name=user value="'.$user .'">
				<input type=hidden name=password value="'.$password .'">
				<input type=submit value="regresar" style="height: 30px;" class="send">
			</form>';}


}		
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