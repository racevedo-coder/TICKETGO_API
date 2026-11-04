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



