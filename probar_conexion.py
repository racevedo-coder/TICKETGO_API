from app.database import obtener_conexion

conexion = obtener_conexion()
cursor = conexion.cursor()
cursor.execute("select count(*) from evento")
print(cursor.fetchone())
conexion.close()


