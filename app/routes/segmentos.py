from fastapi import APIRouter, HTTPException
from app.database import obtener_conexion

router = APIRouter()

@router.get("/api/segmentos/analisis-limpio")
def analisis_limpio():
    conexion = None
    try:
        conexion = obtener_conexion()
        cursor = conexion.cursor(dictionary=True)
        cursor.execute("""select substring_index(e.lugar, ' - ', -1) as ciudad,
                          count(b.id_boleta) as boletas_vendidas,
                          sum(z.precio )   as recaudo_total
                          from boleta b
                          join zona z on b.id_zona = z.id_zona
                          join evento e on z.id_evento = e.id_evento
                          join venta v on  v.id_venta = b.id_venta
                          where b.estado = 'activa' and not exists (select 1
                                                                    from venta v2
                                                                    where v2.id_cliente = v.id_cliente and  v2.estado= 'cancelada')
                          group by ciudad
                       """)     
        filas = cursor.fetchall()

        if not filas:
            raise HTTPException(status_code=404, detail="No se encontraron datos por ciudad")
        return filas

    except HTTPException:
               raise

    except Exception :
        raise HTTPException(status_code=500, detail="Error interno del servidor")
    
    finally:
           if conexion:
               conexion.close() 