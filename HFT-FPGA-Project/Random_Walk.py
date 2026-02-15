import random
import numpy as np



datos = []
precio = 100
with open("mercado.hex", "w") as archivo_salida:
 for i in range(1000):
    
    datos_random = random.randint(-5,5)
    precio = precio + datos_random
    if precio > 255:
        precio = 255
    elif precio < 0:
        precio =0
    
    datos.append(precio)
    archivo_salida.write(f"{precio:02x}\n")

print(datos)