# TicketGo API
### Taller 2 de Bases de Datos II
### Roxana Acevedo Martínez
### Universidad de Córdoba.

API REST de analítica para TicketGo, una plataforma de venta de boletas para eventos, la cual está hecha en Python con FastAPI y se conecta directamente a MySQL con SQL puro, sin ORM 

En cuanto a la homologación de entidades y la explicación de cada endpoint están en [HOMOLOGACION.md](HOMOLOGACION.md).

## Cómo ejecutarla

1. Crea la base de datos ejecutando `dump_proyecto.sql` en MySQL.
2. Crea y activa un entorno virtual:
   ```
   python -m venv venv
   venv\Scripts\activate
   ```
3. Instala las dependencias:
   ```
   pip install -r requirements.txt
   ```
4. Copia `.env.example` como `.env` y escribe tus datos de conexión a MySQL.
5. Enciende la API:
   ```
   uvicorn app.main:app --reload
   ```
6. Prueba los endpoints con `test_endpoints.http` o entra a `http://localhost:8000/docs`.

## Endpoints

| Método | Ruta | Qué devuelve |
|---|---|---|
| GET | `/api/reportes/clasificacion-top` | Categorías de evento con promedio por boleta superior al general |
| GET | `/api/analitica/actores-estrella` | Clientes que gastan más que el promedio |
| GET | `/api/items/desviacion-grupo` | Zonas con menos ventas que el promedio de su evento |
| GET | `/api/segmentos/analisis-limpio` | Recaudo por ciudad, sin clientes con compras canceladas |
| GET | `/api/operaciones/resumen-dinamico?min_operaciones=N` | Métodos de pago con al menos N pagos y promedio superior al precio de la zona más cara |

## Estructura

```
app/
|-- main.py         arranque de la API
|-- database.py    conexión a MySQL
|-- routes/         un archivo por grupo de endpoints
HOMOLOGACION.md   homologación de entidades y explicación de los endpoints
consultas.sql      las 5 consultas SQL
dump_proyecto.sql    estructura y datos de la base de datos
requirements.txt      dependencias de Python
.env.example         plantilla de las variables de conexión
.gitignore               archivos que Git no sube (venv, .env, __pycache__)
test_endpoints.http    peticiones de prueba
```