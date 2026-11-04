from fastapi import APIRouter, HTTPException
from app.database import obtener_conexion

router = APIRouter()

@router.get("/api/items/desviacion-grupo")
def desviacion_grupo():
    conexion = None
    try:
        conexion = obtener_conexion()
        cursor = conexion.cursor(dictionary=True)
        cursor.execute("""select z.id_zona, z.nombre, z.id_evento, e.nombre as evento, COUNT(b.id_boleta ) as boletas_vendidas
                          from zona z
                          join evento e on z.id_evento = e.id_evento
                          left join boleta b on b.id_zona  = z.id_zona and b.estado ='activa'
                          group by z.id_zona, z.nombre, z.id_evento, e.nombre
                          having count(b.id_boleta) < (select count(b2.id_boleta) * 1.0 / count(distinct z2.id_zona)
                                                       from zona z2
                                                       left join boleta b2 on b2.id_zona = z2.id_zona and b2.estado ='activa'
                                                       where z2.id_evento = z.id_evento )
                       """)     
        filas = cursor.fetchall()

        if not filas:
            raise HTTPException(status_code=404, detail="No se encotraron zonas")
        return filas

    except HTTPException:
               raise

    except Exception :
        raise HTTPException(status_code=500, detail="Error interno del servidor")
    
    finally:
           if conexion:
               conexion.close() 