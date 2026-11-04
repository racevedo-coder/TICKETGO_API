from fastapi import APIRouter, HTTPException
from app.database import obtener_conexion

router = APIRouter()

@router.get("/api/reportes/clasificacion-top")
def clasificacion_top():
    conexion = None
    try:
        conexion = obtener_conexion()
        cursor = conexion.cursor(dictionary=True)
        cursor.execute("""select e.categoria, count(b.id_boleta) as boletas_vendidas,
                                 sum(z.precio) as total_recaudado,
                                 round(avg(z.precio), 2)  as promedio_boleta
                          from boleta b
                          join zona z on b.id_zona = z.id_zona
                          join evento e on z.id_evento = e.id_evento
                          where b.estado = 'activa'
                          group by e.categoria 
                          having avg(z.precio) > (select avg(z2.precio)
                                                  from boleta b2
                                                  join zona z2 on b2.id_zona = z2.id_zona
                                                  where b2.estado = 'activa')
                          order by promedio_boleta desc; """)    
        filas = cursor.fetchall()

        if not filas:
            raise HTTPException(status_code=404, detail="No se encontraron categorías")
        return filas

    except HTTPException:
               raise

    except Exception as e:
        raise HTTPException(status_code=500, detail="Error interno del servidor")
    
    finally:
           if conexion:
               conexion.close() 