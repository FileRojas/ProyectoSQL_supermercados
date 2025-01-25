# Consultas avanzadas a la base de datos:

/* 1- Quiero saber el precio original y el precio con descuento de todos 
los productos que tienen por lo minimo una oferta activa en alguna sucursal
de cualquier provincia*/
SELECT p.nombre_producto, c.nombre_cadena, s.provincia, 
    pr.precio precio_original, 
     (pr.precio - (pr.precio * o.descuento)) precio_descuento
      FROM cadenas c
       JOIN sucursales s ON c.id_cadena = s.id_cadena
	  JOIN precios pr ON s.id_sucursal = pr.id_sucursal
	 JOIN ofertas o ON s.id_sucursal = o.id_sucursal AND pr.id_producto = o.id_producto
	JOIN productos p ON o.id_producto = p.id_producto
ORDER BY precio_descuento;

/* 2- Quiero saber el precio promedio de los 10 productos mas caros en todas las
cadenas de supermercados y tambien el decuento promedio donde hay
ofertas activas: 
*/
SELECT p.nombre_producto, c.nombre_cadena, 
        ROUND(AVG(pr.precio),2) precio_promedio, ROUND(AVG(o.descuento),2) descuento_promedio
         FROM sucursales s
          JOIN cadenas c ON s.id_cadena = c.id_cadena
		JOIN precios pr ON s.id_sucursal = pr.id_sucursal
	   JOIN ofertas o ON pr.id_producto = o.id_producto AND pr.id_sucursal = o.id_sucursal
	  JOIN productos p ON o.id_producto = p.id_producto
	GROUP BY p.nombre_producto, c.nombre_cadena
  ORDER BY precio_promedio DESC
LIMIT 10;

/* 3- Ahora, quiero conseguir la categoria con el precio promedio mas alto
de cada cadena de supermercados */

WITH promedio AS (
     SELECT ca.nombre_categoria, c.nombre_cadena, 
        ROUND(AVG(pr.precio),2) precio_promedio
         FROM sucursales s
          JOIN cadenas c ON s.id_cadena = c.id_cadena
		JOIN precios pr ON s.id_sucursal = pr.id_sucursal
	   JOIN productos p ON pr.id_producto = p.id_producto
	  JOIN categoria_productos ca ON p.id_categoria = ca.id_categoria
	GROUP BY ca.id_categoria, c.nombre_cadena
  ORDER BY precio_promedio DESC
  ),
  
promedio_alto AS (
      SELECT nombre_categoria, nombre_cadena, precio_promedio,
   ROW_NUMBER() OVER(PARTITION BY nombre_cadena ORDER BY precio_promedio DESC) orden
FROM promedio
)

SELECT nombre_categoria, nombre_cadena, precio_promedio
  FROM promedio_alto
 WHERE orden = 1
ORDER BY precio_promedio DESC;

/* 4- Necesito buscar a los empleados mas antiguos 
de las cadenas 'Super barrio' y 'Limpiatodo' y en cual sucursal laburan: 
*/
WITH rank_antiguedad AS (
SELECT id_empleado, e.nombre, e.apellido, c.nombre_cadena, s.id_sucursal, e.fecha_ingreso,
   RANK() OVER(PARTITION BY c.nombre_cadena ORDER BY fecha_ingreso) empleado_antiguo
	FROM empleados e
   JOIN sucursales s ON e.id_sucursal = s.id_sucursal
JOIN cadenas c ON s.id_cadena = c.id_cadena
)

SELECT a.nombre, a.apellido, a.nombre_cadena, s.provincia, a.fecha_ingreso
   FROM rank_antiguedad a
    JOIN sucursales s ON a.id_sucursal = s.id_sucursal
   WHERE empleado_antiguo = 1 
  AND a.nombre_cadena IN ('Super barrio', 'Limpiatodo')
ORDER BY a.fecha_ingreso;

/* 5- ¿Cuales son los productos de la cadena 'Unicasa' 
que no tienen oferta activa en ninguna sucursal? */
SELECT p.nombre_producto
  FROM productos p 
   LEFT JOIN ofertas o ON p.id_producto = o.id_producto
    LEFT JOIN sucursales s ON o.id_sucursal = s.id_sucursal
   LEFT JOIN cadenas c ON s.id_cadena = c.id_cadena
WHERE o.descuento IS NULL AND c.nombre_cadena = 'Unicasa';