#include <iostream>
#include <fstream>
#include <string>
#include <vector>


int main(){
std::ifstream archivo("ordenes.txt");

if (!archivo.is_open()){
std::cout << "No cargaste bien el archivo\n";
return 1;
}

std::string columna_tiempo , valor_tiempo, columna_precio, media_movil, flecha, señal, media_columna ;
double precio;
double plata_inicial = 1000;
double cash = plata_inicial, 
perdidas = 0,
acciones = 0, 
ultimo_precio = 0, 
operaciones = 0 ,
comision = 0.005;

while( archivo >> columna_tiempo >> valor_tiempo >> columna_precio >> precio >> media_columna >> media_movil >> flecha >> señal){

ultimo_precio = precio;
operaciones  ++ ;
if ( señal == "COMPRA"){
    if (cash >  (precio + precio * comision) ){
      cash -= ( precio + comision * precio) ;
      perdidas += comision * precio;
      acciones ++;

    }
}
else if (señal == "VENTA"){
    if (acciones > 0){
     cash += ( precio - precio * comision);
     perdidas += comision * precio;
     acciones --;
     }
   } 
}
archivo.close();

double plata_final = cash + (acciones * ultimo_precio);
double ganancia = plata_final - plata_inicial;

std::cout << "----------------RESUMEN--------------" << std::endl;
std::cout << "Las operaciones totales fueron: " << operaciones << std::endl;
std::cout << "La ganancia total fue: " << ganancia << std::endl;
std::cout << "Las acciones en mano son : " << acciones << std::endl;
std::cout << "La perdida por comisiones  fue: " << perdidas << std::endl;
std::cout << "-----------------------------------------" << std::endl;
 if (ganancia > 0) {
        std::cout << "RESULTADO: GANANCIA DE $" << ganancia << " (Exito!)" << std::endl;
    } else {
        std::cout << "RESULTADO: PERDIDA DE  $" << ganancia << " (A seguir ajustando)" << std::endl;
    }


return 0;

}

