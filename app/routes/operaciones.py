from fastapi import APIRouter, HTTPException
from app.database import obtener_conexion

router = APIRouter()

@router.get("/api/operaciones/resumen-dinamico")
def resumen_dinamico(min_operaciones: int = 2):
    conexion = None
    try:
        conexion = obtener_conexion()
        cursor = conexion.cursor(dictionary=True)
        cursor.execute("""select p.metodo_pago, count(*) as operaciones,
                          sum(p.monto) as monto_total,
                          avg(p.monto ) as promedio_por_operacion
                          from pago p 
                          join venta v on p.id_venta = v.id_venta
                          where v.estado = 'pagada'
                          group by p.metodo_pago 
                          having count(*)>=%s
                                 and avg(p.monto) > (select max(precio) from zona)
                       """, (min_operaciones,))
        filas = cursor.fetchall()

        if not filas:
            raise HTTPException(status_code=404, detail="No se encontraron métodos de pago con ese mínimo de operaciones")
        return filas

    except HTTPException:
               raise

    except Exception :
        raise HTTPException(status_code=500, detail="Error interno del servidor")
    
    finally:
           if conexion:
               conexion.close() 