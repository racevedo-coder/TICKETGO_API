from fastapi import APIRouter, HTTPException
from app.database import obtener_conexion

router = APIRouter()

@router.get("/api/analitica/actores-estrella")
def actores_estrella():
    conexion = None
    try:
        conexion = obtener_conexion()
        cursor = conexion.cursor(dictionary=True)
        cursor.execute("""select u.id_usuario, u.nombre, sum(v.total) as gasto_total
                          from usuario u
                          join venta v on u.id_usuario = v.id_cliente
                          where v.estado = 'pagada'
                          group by u.id_usuario, u.nombre
                          having sum(v.total) > (select avg(t.gasto)
                                                from (select v2.id_cliente, sum(v2.total) as gasto
                                                      from venta v2
                                                      where v2.estado = 'pagada'
                                                      group by v2.id_cliente
                                                ) as t)
                          order by gasto_total desc """)
        filas = cursor.fetchall()

        if not filas:
            raise HTTPException(status_code=404, detail="No se encontraron clientes con gasto superior al promedio")
        return filas

    except HTTPException:
        raise

    except Exception :
        raise HTTPException(status_code=500, detail="Error interno del servidor")
    
    finally:
        if conexion:
               conexion.close() 