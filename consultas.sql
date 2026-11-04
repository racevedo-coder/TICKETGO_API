
select e.categoria, count(b.id_boleta) as boletas_vendidas,
       sum(z.precio) as total_recaudado,
       round(avg(z.precio), 2)  as promedio_boleta
from boleta b
join zona z on b.id_zona = z.id_zona
join evento e on z.id_evento = e.id_evento
where b.estado = 'activa'
group by e.categoria 
having avg(z.precio) > (
    select avg(z2.precio)
    from boleta b2
    join zona z2 on b2.id_zona = z2.id_zona
    where b2.estado = 'activa')
order by promedio_boleta desc;


select u.id_usuario, u.nombre, SUM(v.total) as gasto_total
from usuario u
join venta v on u.id_usuario = v.id_cliente
where v.estado = 'pagada'
group by u.id_usuario, u.nombre 
having SUM(v.total )> ( select avg(t.gasto)
                     from (select v2.id_cliente , sum(v2.total) as gasto
                          from venta v2
                          where v2.estado = 'pagada'
                          group by v2.id_cliente) as t )
order by gasto_total desc;


select z.id_zona, z.nombre, z.nombre, z.id_evento, e.nombre as evento, COUNT(b.id_boleta ) as boletas_vendidas
from zona z
join evento e on z.id_evento = e.id_evento
left join boleta b on b.id_zona  = z.id_zona and b.estado ='activa'
group by z.id_zona, z.nombre, z.id_evento, e.nombre
having count(b.id_boleta) < (select count(b2.id_boleta) * 1.0 / count(distinct z2.id_zona)
                             from zona z2
                             left join boleta b2 on b2.id_zona = z2.id_zona and b2.estado ='activa'
                             where z2.id_evento = z.id_evento 
                             );


 
               
SELECT SUBSTRING_INDEX(e.lugar, ' - ', -1) AS ciudad,
       COUNT(b.id_boleta) AS boletas_vendidas,
       SUM(z.precio )   AS recaudo_total
from boleta b
join zona z on b.id_zona = z.id_zona
join evento e on z.id_evento = e.id_evento
join venta v on  v.id_venta = b.id_venta
where b.estado = 'activa' and not exists (select 1
from venta v2
where v2.id_cliente = v.id_cliente and  v2.estado= 'cancelada')
group by ciudad;


select p.metodo_pago,
     count(*)   as operaciones,
     sum(p.monto) as monto_total,
     avg(p.monto ) as promedio_por_operacion
from pago p 
join venta v on p.id_venta = v.id_venta
where v.estado = 'pagada'
group by p.metodo_pago 
having count(*)>=%s
   and avg(p.monto) > (
       select max(precio) from zona
   );
