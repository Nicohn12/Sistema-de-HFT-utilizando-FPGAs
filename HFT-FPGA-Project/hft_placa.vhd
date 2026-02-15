
module hft_placa(
    input clk,
    input [7:0] precio,
    output reg comprar,
    output reg vender
);

 reg [7:0] historial [0:3];
 reg [9:0] suma; 
 reg [7:0] promedio;  
 reg [7:0] precio_compra;
 reg comprado;

initial begin
        historial[0] = 0; historial[1] = 0; historial[2] = 0; historial[3] = 0;
        comprar = 0; vender = 0;
        suma = 0; promedio = 0;
end
  
always @(posedge clk) begin
       
historial[0] <= historial[1];
historial[1] <= historial[2];
historial[2] <= historial[3];
historial[3] <= precio;

 suma = historial[0] + historial[1] + historial[2] + historial[3];
 promedio = suma >> 2; 

if (comprado && (precio < (precio_compra - 8'd10))) begin
   comprar <= 1'b0;
   vender  <= 1'b1;
   comprado <= 1'b0;    
end
if(precio > (promedio + 8'd2)) begin
    comprar <= 1'b0;
    vender  <= 1'b1;
 comprado <= 1'b0;
end
else if (precio < (promedio - 8'd2)) begin
     comprar <= 1'b1;
     vender  <= 1'b0;
     precio_compra <= precio;
     comprado <= 1'b1;
end
      
else begin
      comprar <= 1'b0;
      vender  <= 1'b0;
end
end
endmodule

module hft_tb;
reg clk;
reg [7:0] precio_mercado;
    
wire buy;
wire sell;

reg prev_buy;
reg prev_sell;
    
reg [7:0] memoria_mercado [0:999]; 
integer i;
integer archivo_salida;


hft_placa uut(
 .clk(clk),
 .precio(precio_mercado),
 .vender(sell), 
 .comprar(buy)
);

initial begin
    clk = 0;
end
    always #5 clk = ~clk;

initial begin
        
prev_buy = 0;
prev_sell = 0;

$readmemh("mercado.hex", memoria_mercado);
archivo_salida = $fopen("ordenes.txt", "w");
        
precio_mercado = memoria_mercado[0]; 
#50; 

for (i = 0; i < 1000; i = i + 1) begin

@(posedge clk);
precio_mercado = memoria_mercado[i];
            
#1;        
 
if (buy && !prev_buy) begin 
   $fwrite(archivo_salida, "TIME %d: Precio %d (Promedio: %d) -> COMPRA\n", $time, precio_mercado, uut.promedio);
   $display("TIME %d: Precio %d (Avg: %d) -> COMPRA", $time, precio_mercado, uut.promedio); 
end 

if (sell && !prev_sell) begin 
   $fwrite(archivo_salida, "TIME %d: Precio %d (Promedio: %d) -> VENTA\n", $time, precio_mercado, uut.promedio);
   $display("TIME %d: Precio %d (Avg: %d) -> VENTA", $time, precio_mercado, uut.promedio); 
end 

prev_buy = buy;
prev_sell = sell;

end 
        
$fclose(archivo_salida);
$finish; 
end 

endmodule
