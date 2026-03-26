import csv
import random
from datetime import datetime, timedelta

# Configuración
NUM_REGISTROS = 50

# Datos de ejemplo para generar datos realistas
nombres_clientes = [
    "María López", "Juan Martínez", "Ana García", "Pedro Pérez", "Laura Fernández",
    "Carlos Rodríguez", "Sofía Gómez", "Luis Sánchez", "Valentina Díaz", "Andrés Herrera",
    "Camila Méndez", "Diego Ramírez", "Isabel Torres", "Javier Castro", "Paula Ortiz",
    "Ricardo Flores", "Daniela Rojas", "Fernando Morales", "Elena Navarro", "Oscar Romero",
    "Patricia Silva", "Raúl Vargas", "Carolina Mendoza", "Héctor Guzmán", "Gabriela Paredes"
]

apellidos_email = ["gmail.com", "hotmail.com", "outlook.com", "yahoo.com", "servicio.com"]
ciudades = ["Madrid", "Barcelona", "Sevilla", "Bilbao", "Valencia", "Quito", "Guayaquil", "Cuenca", "Bogotá", "México DF"]

productos_ejemplo = [
    ("Ultrabook X1", "Electrónica", 1250000),
    ("Ratón Óptico", "Periféricos", 45000),
    ("Pantalla Curva 27\"", "Electrónica", 680000),
    ("Base Refrigerante", "Accesorios", 75000),
    ("Audífonos Inalámbricos", "Periféricos", 210000),
    ("Smartwatch Sport", "Electrónica", 720000),
    ("Teclado Mecánico", "Periféricos", 150000),
    ("Monitor 24\"", "Electrónica", 450000),
    ("Disco SSD 1TB", "Almacenamiento", 120000),
    ("Memoria USB 64GB", "Accesorios", 35000)
]

# Función para generar fecha aleatoria
def fecha_aleatoria(inicio, fin):
    return inicio + timedelta(days=random.randint(0, (fin - inicio).days))

# 1. Generar clientes.csv
with open('clientes.csv', 'w', newline='', encoding='utf-8') as f:
    writer = csv.writer(f)
    writer.writerow(['nombreCliente', 'emailCliente', 'ciudad', 'creado_en'])
    
    for i in range(NUM_REGISTROS):
        nombre = random.choice(nombres_clientes) + " " + str(random.randint(1, 999))
        email = nombre.lower().replace(" ", ".") + "@" + random.choice(apellidos_email)
        ciudad = random.choice(ciudades)
        fecha_creacion = fecha_aleatoria(datetime(2025, 1, 1), datetime(2026, 3, 25)).strftime('%Y-%m-%d %H:%M:%S')
        writer.writerow([nombre, email, ciudad, fecha_creacion])

print("✅ Archivo clientes.csv generado con 50 registros")

# 2. Generar productos.csv
with open('productos.csv', 'w', newline='', encoding='utf-8') as f:
    writer = csv.writer(f)
    writer.writerow(['nombreProducto', 'precioProducto', 'stockProducto', 'categoriaProducto'])
    
    for i in range(NUM_REGISTROS):
        # Reutilizar productos de ejemplo con variaciones
        producto_base = random.choice(productos_ejemplo)
        nombre = producto_base[0] + " " + chr(random.randint(65, 90)) + str(random.randint(1, 99))
        precio = producto_base[2] + random.randint(-10000, 20000)
        if precio < 10000:
            precio = 10000
        stock = random.randint(0, 150)
        categoria = producto_base[1]
        writer.writerow([nombre, precio, stock, categoria])

print("✅ Archivo productos.csv generado con 50 registros")

# 3. Generar pedidos.csv (vincula clientes y productos)
# Primero, necesitamos saber los IDs que tendrán en la BD
# Para simular, usaremos IDs del 1 al 50 (asumiendo que se insertarán en ese orden)

with open('pedidos.csv', 'w', newline='', encoding='utf-8') as f:
    writer = csv.writer(f)
    writer.writerow(['cantidadProducto', 'fechaPedido', 'idClienteFK', 'idProductoFK'])
    
    for i in range(NUM_REGISTROS):
        cantidad = random.randint(1, 10)
        fecha_pedido = fecha_aleatoria(datetime(2025, 1, 1), datetime(2026, 3, 25)).strftime('%Y-%m-%d')
        id_cliente = random.randint(1, 50)
        id_producto = random.randint(1, 50)
        writer.writerow([cantidad, fecha_pedido, id_cliente, id_producto])

print("✅ Archivo pedidos.csv generado con 50 registros")

print("\n🎉 ¡Archivos CSV generados exitosamente!")
print("📁 Archivos creados: clientes.csv, productos.csv, pedidos.csv")