## Matriz de homologación de entidades

TicketGo es una plataforma de venta de boletas para eventos sobre conciertos, deporte, teatro, cine, festivales y comedia. Elf funcionamiento en general se basa en que el administrador publica eventos y define sus zonas con precio y cupo y, por otro lado, los clientes compran boletas, aplican descuentos y pagan.

## Tabla de homologación

| Rol arquetípico | Tabla en TicketGo | Descripción |
|---|---|---|
| A. Entidad Catálogo / Clasificadora | evento | Agrupa y clasifica lo que se vende, con su `categoria` y su `lugar`. |
| B. Entidad Ítem / Recurso | zona | Cada zona de un evento, con su precio y su cupo, es lo que el cliente compra. |
| C. Entidad Transaccional | venta, pago, boleta | Registran las compras, con valores y fechas. |
| D. Entidad Actor / Sujeto | usuario (clientes, `id_rol = 2`) | Quienes compran las boletas. |
| E. Entidad de Contexto / Segmentación | `lugar` (columna de la tabla evento) | Divide la operación por sede o escenario. |

En mi proyecto de venta de boletas, la entidad catálogo es `evento`, la entidad item es `zona`, la Entidad Transaccional es `venta`, junto con `pago` y `boleta`. Por otro lado, la entidad actor es `usuario` con rol cliente y la entidad de contexto es el `lugar` del evento.


## ENDPOINTS

### Endpoint 1: `GET /api/reportes/clasificacion-top`

Este endpoint muestra qué tipos de evento como concierto, deporte, teatro, entre otros, venden las boletas más caras que el promedio general de la plataforma. Para cada categoría que lo cumple, devuelve cuántas boletas se vendieron, el dinero total y el precio promedio por boleta, para esto las boletas anuladas no se cuentan.

### Endpoint 2: `GET /api/analitica/actores-estrella`

Por medio de este endpoint  se muestra qué clientes son los que más compran en TicketGo, para esto suma lo que ha gastado cada uno de ellos en sus compras pagadas y deja solo a los que gastaron más que el promedio de todos los clientes. Para cada uno devuelve su identificador, su nombre y el total que ha gastado y, además, para esto las ventas canceladas no se cuentan.

### Endpoint 3: `GET /api/items/desviacion-grupo`

Aquí se muestran qué zonas han vendido menos boletas que el promedio de las demás zonas de su mismo evento. Esto sirve para detectar zonas que no se están vendiendo bien, incluidas las que todavía no han vendido ninguna. Cada zona se compara solo con las de su propio evento, y las boletas anuladas no se cuentan. 

### Endpoint 4:  `GET /api/segmentos/analisis-limpio`

Este endpoint muestra cuántas boletas se han vendido y cuánto dinero se ha recaudado en cada ciudad, sin contar a los clientes que alguna vez han tenido una compra cancelada. Así se obtiene un resultado más limpio, sin los clientes con casos problemáticos. Aquí las boletas anuladas tampoco se cuentan. 

