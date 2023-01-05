#!"C:\xampp\perl\bin\perl.exe"
use strict;
use warnings;
use CGI;

my $q= CGI->new;
print $q->header('text/html','utf-8');
my $tipo= $q->param("kind");
my $valor= $q->param("keyword");
$valor = uc($valor); 

my $exp = buildRegex(22);
my $archivo = "Programas de Universidades.csv";

my @universidades = getUnis($tipo,$valor); 

my @campos = ("Nombre de la Universidad"," Periodo Licenciamiento","Departamento Local","Denominacion Programa");


sub renderHTML{
  my $css = $_[0];
  my $body = $_[1];
  print <<BLOCK;
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Universidades Licenciadas</title>
  <link rel="stylesheet" type="text/css" href="uni.css">
  <link rel="icon" href="https://www.unsa.edu.pe/wp-content/uploads/2017/12/cropped-LogoUNSAFav-192x192.png" sizes="192x192">
</head> 
<body>  
  <form class="form" action="universi.pl" method="get">
    <div class="logo">
    <div><img src="imagen/uni.jpg"></div>
    <p></p>
      <p></p>
      <p></p>
    <hr>
    <h3 class="form_titulo" >Formulario de Universidades Licenciadas</h3> 
    <div class="form_container">
      <div class="form_group">
        <input type="text" id="name" class="form_input" placeholder=" ">
        <label for="name" class="form_label"> Nombre de la Universidad</label>
        <span class="form_line" autocomplete="off" name="prim"></span>
      </div>
      <div class="form_group">
        <input type="text" id="Periodo" class="form_input" placeholder=" ">
        <label for="Periodo" class="form_label">Periodo Licenciamiento</label>
        <span class="form_line" autocomplete="off" name="segun"></span>
      </div>
      <div class="form_group">
        <input type="text" id="Depart" class="form_input" placeholder=" ">
        <label for="Depart" class="form_label">Departamento Local</label>
        <span class="form_line" autocomplete="off" name="tercer"></span>
      </div>
      <div class="form_group">
        <input type="text" id="Denom" class="form_input" placeholder=" ">
        <label for="Denom" class="form_label">Denominacion Programa</label>
        <span class="form_line" autocomplete="off" name="cuart"></span>
      </div>
      <input type="submit" class="form_submit" value="Buscar Universidad">
    </div>
    <div class="logos">
    <div><img src="imagen/sistemas.jpg"></div>
    
  </form>
</body>
</html>
BLOCK

}

sub getUnis{
  my $kind = $_[0];
  my $keyword = $_[1];
  my @universidades=();
  
  open(IN, $archivo) or die("Error no se encuentra el archivo");
  my @registros = <IN>;
  close(IN);

  my $cont=0;
  my $universidad;
  for(my $i=0;$i<@registros;$i++){
    if($registros[$i] =~ /$exp/){
      if(defined($2) && defined($5)&& defined($11)&& defined($17)){
        $universidad ={
          " Nombre de la Universidad" => $2,
          " Periodo Licenciamiento" => $5,
          " Departamento Local" => $11,
          " Denominacion Programa" => $17,
        };
        if(%{$universidad}{$kind}=~/.*$keyword.*/){
          push @universidades,$universidad;
        }
      }
    } 
  }
  return @universidades;
}
sub buildRegex{
  my $n = $_[0];
  my $general='([^\|]+)\|';
  my $ultimo = '([^\|]+)';
 
  my $str = '^';
  for(my $i=0;$i<$n;$i++){
    $str.=$general;
  }
  return $str.$ultimo;
}

