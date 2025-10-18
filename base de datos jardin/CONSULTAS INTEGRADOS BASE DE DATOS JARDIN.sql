-- CONSULTAS INTEGRADOR
-- consultas simpples
-- 1 Devueleve un listado con el codigo de oficina y la ciudad donde hay oficinas

-- 1 Obtener un listado de las ciudades donde hay oficinas (sin repetir).--

SELECT ciudad 
FROM oficina
GROUP BY ciudad;

-- 2 Devuelve un listado con la ciudad y el de las oficinas de España.
SELECT 
    ciudad,
    codigo_oficina
FROM oficina
WHERE pais = 'España';

-- 3. Devuelve un listado con el nombre, apellidos y email de los empleados cuyo jefe tiene un código de jefe igual a 7.
SELECT 
    nombre,
    apellido1,
    email
FROM empleado
WHERE codigo_jefe = 7;

-- 4 Devuelve el nombre del puesto, nombre, apellidos y email del jefe de la empresa.
SELECT nombre , puesto, apellido1, apellido2, email
FROM empleado
WHERE puesto = "Director General";

-- 5 Devuelve un listado con el nombre
-- Devuelve un listado con el nombre apellido y puesto de aquellos empleados que no sean representante de ventas

SELECT
nombre AS nombre_empleado,
apellido1 AS apellido_empleado,
puesto AS puesto_empleado
FROM empleado
WHERE puesto <> 'Representante Ventas';


-- 6 Devuelve un listado con el nombre de los todos los clientes españoles.
SELECT nombre_cliente, codigo_cliente
FROM cliente
WHERE pais = 'Spain';

-- 7. Devuelve un listado con los distintos estados por los que puede pasar un pedido.

SELECT DISTINCT estado -- para que no me muestre estados repetidos, sino me va a mostrar el estado de todos los pedidos realizados
FROM pedido;

-- 8. Devuelve un listado con el código de cliente de aquellos clientes que realizaron algún pago
-- en 2008. Tenga en cuenta que deberá eliminar aquellos códigos de cliente que aparezcan
-- repetidos. Resuelva la consulta:
--  Utilizando la función YEAR de MySQL.
-- Utilizando la función DATE_FORMAT de MySQL.
-- Sin utilizar ninguna de las funciones anteriores.

SELECT DISTINCT codigo_cliente -- pongo distinct ya que no quiero que me aparezcan codigos de clientes repetidos, dice algun pago, no necesito todos
FROM pago
WHERE fecha_pago BETWEEN '2008-01-01' AND '2008-12-31'; 

-- 9- devolver un listado con codigo de pedido codigo de cliente, fecha ,
 -- esperada y fecha de entrega de los pedidos que no han sido entregados a tiempo

SELECT codigo_pedido,
       codigo_cliente,
       fecha_pedido,
       fecha_esperada,
       fecha_entrega,
       estado
FROM pedido
WHERE fecha_entrega IS NOT NULL
  AND fecha_entrega > fecha_esperada
  AND estado = 'Entregado';

-- 10. Devuelve un listado con el código de pedido, código de cliente, fecha esperada y fecha de
-- entrega de los pedidos cuya fecha de entrega ha sido al menos dos días antes de la fecha
-- esperada.
-- OTRA FORMA ES CON DATE_SUB + interva
SELECT 
    codigo_pedido,
    codigo_cliente,
    fecha_esperada,
    fecha_entrega
FROM pedido
WHERE fecha_entrega <= DATE_SUB(fecha_esperada, INTERVAL 2 DAY);

-- DATE IF
SELECT 
    codigo_pedido,
    codigo_cliente,
    fecha_esperada,
    fecha_entrega
FROM pedido
WHERE DATEDIFF(fecha_esperada, fecha_entrega) >= 2;

-- ADD DATE
SELECT 
    codigo_pedido,
    codigo_cliente,
    fecha_esperada,
    fecha_entrega
FROM pedido
WHERE fecha_entrega <= ADDDATE(fecha_esperada, INTERVAL -2 DAY);

-- SUMANDO RESTANDO
SELECT 
    codigo_pedido,
    codigo_cliente,
    fecha_esperada,
    fecha_entrega
FROM pedido
WHERE fecha_entrega <= fecha_esperada - INTERVAL 2 DAY;


-- 11- Devuelve un listado de todos los pedidos que fueron rechazados en 2009.
SELECT estado , fecha_pedido, codigo_pedido
FROM pedido
WHERE estado = 'Rechazado' 
AND fecha_pedido >= '2009-01-01' AND fecha_pedido <= '2009-12-31';
-- otra forma es.. AND YEAR(fecha_pedido) = 2009;
-- WHERE estado LIKE 'Rechazado' AND  fecha_pedido LIKE ''

-- 12 Devuelve un listado de todos los pedidos que han sido entregados en el mes de enero de
-- cualquier año.

SELECT codigo_pedido, estado , fecha_pedido
FROM pedido
WHERE estado = "Entregado" AND MONTH (fecha_pedido) = 1
GROUP BY YEAR(fecha_pedido);

-- 13. Devuelve un listado con todos los pagos que se realizaron en el año 2008 mediante Paypal.
-- Ordene el resultado de mayor a menor.

SELECT *
FROM pago
WHERE YEAR(fecha_pago) = 2008
  AND medio_pago = 'Paypal'
ORDER BY fecha_pago DESC;

-- 14 Devuelve un listado con todas las formas de pago que aparecen en la tabla pago. Tenga en cuenta que no deben aparecer formas de pago repetidas.
SELECT DISTINCT medio_pago
FROM pago;

-- 15 Devuelve un listado con todos los productos que pertenecen a la gama Ornamentales y
 -- que tienen más de 100 unidades en stock. El listado deberá estar ordenado por su precio de venta,
 -- mostrando en primer lugar los de mayor precio.

SELECT *
FROM producto
WHERE gama = 'Ornamentales'
  AND unidades_en_stock > 100
ORDER BY precio_venta DESC;

-- 16. Devuelve un listado con todos los clientes que sean de la ciudad de Madrid y cuyo
-- representante de ventas tenga el código de empleado 11 o 30

SELECT *
FROM cliente
WHERE ciudad = 'Madrid'
  AND codigo_empleado_rep_ventas IN (11, 30);



-- CONSULTAS MULTITABLA
-- 1 Mostrar el nombre de cada cliente junto con el nombre y apellido de su representante de ventas --
SELECT
c.nombre_cliente AS nombre_cliente,
e.nombre AS nombre_rep_ventas,
e.apellido1 AS apellido_rep_ventas
FROM cliente c
INNER JOIN empleado e
ON c.codigo_empleado_rep_ventas = e.codigo_empleado;

-- OTRA FORMA
SELECT c.nombre_cliente , e.apellido1 , e.apellido2
FROM cliente c, empleado e
WHERE c.codigo_empleado_rep_ventas = e.codigo_empleado;

-- 2 Muestra el nombre de los clientes que hayan realizado pagos junto con el nombre de sus
-- representantes de ventas
SELECT
c.nombre_cliente AS nombre_cliente,
e.nombre AS nombre_rep_ventas,
e.apellido1 AS apellido_rep_ventas,
p.fecha_pago AS fecha_pago
FROM cliente c
INNER JOIN empleado e
ON c.codigo_empleado_rep_ventas = e.codigo_empleado
INNER JOIN pago p
ON c.codigo_cliente = p.codigo_cliente;

-- 3 Muestra el nombre de los clientes que no hayan realizado pagos junto con el nombre de
-- sus representantes de ventas.
SELECT
c.nombre_cliente AS nombre_cliente,
e.nombre AS nombre_rep_ventas,
e.apellido1 AS apellido_rep_ventas,
p.fecha_pago AS fecha_pago
FROM cliente c
INNER JOIN empleado e
	ON c.codigo_empleado_rep_ventas = e.codigo_empleado
left JOIN pago p
	ON c.codigo_cliente = p.codigo_cliente
WHERE p.fecha_pago IS NULL;

-- 4. Devuelve el nombre de los clientes que han hecho pagos y el nombre de sus representantes
-- junto con la ciudad de la oficina a la que pertenece el representante.
SELECT
c.nombre_cliente AS nombre_cliente,
e.nombre AS nombre_rep_ventas,
e.apellido1 AS apellido_rep_ventas,
p.fecha_pago AS fecha_pago,
o.ciudad AS ciudad_oficina
FROM cliente c
INNER JOIN empleado e
	ON c.codigo_empleado_rep_ventas = e.codigo_empleado
INNER JOIN pago p
	ON c.codigo_cliente = p.codigo_cliente
INNER JOIN oficina o
ON e.codigo_oficina = o.codigo_oficina;

-- 5. Devuelve el nombre de los clientes que no hayan hecho pagos y el nombre de sus
-- representantes junto con la ciudad de la oficina a la que pertenece el representante.

SELECT
c.nombre_cliente AS nombre_cliente,
e.nombre AS nombre_rep_ventas,
e.apellido1 AS apellido_rep_ventas,
p.fecha_pago AS fecha_pago,
o.ciudad AS ciudad_oficina
FROM cliente c
INNER JOIN empleado e
	ON c.codigo_empleado_rep_ventas = e.codigo_empleado
LEFT JOIN pago p
	ON c.codigo_cliente = p.codigo_cliente
INNER JOIN oficina o
	ON e.codigo_oficina = o.codigo_oficina
WHERE p.fecha_pago IS NULL;

-- 6. Lista la dirección de las oficinas que tengan clientes en Fuenlabrada.
SELECT 
o.linea_direccion1 AS direccion,
o.ciudad AS oficina_ciudad
FROM cliente c
INNER JOIN empleado e
ON c.codigo_empleado_rep_ventas = e.codigo_empleado
INNER JOIN  oficina o
ON e.codigo_oficina = o.codigo_oficina
WHERE c.ciudad = "Fuenlabrada";

-- 7. Devuelve el nombre de los clientes y el nombre de sus representantes junto con la ciudad
-- de la oficina a la que pertenece el representante.
SELECT
c.nombre_cliente AS nombre_cliente,
e.nombre AS nombre_rep_ventas,
e.apellido1 AS apellido_rep_ventas,
o.ciudad AS ciudad_oficina
FROM cliente c
INNER JOIN empleado e
ON c.codigo_empleado_rep_ventas = e.codigo_empleado
INNER JOIN oficina o
ON e.codigo_oficina = o.codigo_oficina;


-- 8. Devuelve un listado con el nombre de los empleados junto con el nombre de sus jefes.
SELECT
e.nombre AS nombre_empleado,
e.apellido1 AS apellido_empleado,
c.nombre AS nombre_jefe
FROM empleado e
INNER JOIN empleado c
	ON e.codigo_jefe = c.codigo_empleado;

-- 9. Devuelve un listado que muestre el nombre de cada empleado, el nombre de su jefe y el
-- nombre del jefe de sus jefes.
SELECT
    e.nombre AS nombre_empleado,
    e.apellido1 AS apellido_empleado,
    j1.nombre AS nombre_jefe,
    j1.apellido1 AS apellido_jefe,
    j2.nombre AS nombre_jefe_del_jefe,
    j2.apellido1 AS apellido_jefe_del_jefe
FROM empleado e
LEFT JOIN empleado j1
    ON e.codigo_jefe = j1.codigo_empleado
LEFT JOIN empleado j2
    ON j1.codigo_jefe = j2.codigo_empleado;
    
-- 10. Devuelve el nombre de los clientes a los que no se les ha entregado a tiempo un pedido.
SELECT 
    c.nombre_cliente
FROM cliente c
INNER JOIN pedido p
    ON c.codigo_cliente = p.codigo_cliente
WHERE p.fecha_entrega > p.fecha_esperada;

-- 11. Devuelve un listado de las diferentes gamas de producto que ha comprado cada cliente.

SELECT
c.nombre_cliente AS nombre_cliente,
p.gama AS gama_producto
FROM cliente c
INNER JOIN pedido ped
ON c.codigo_cliente = ped.codigo_cliente
INNER JOIN detalle_pedido dp
ON ped.codigo_pedido = dp.codigo_pedido
INNER JOIN producto p
ON dp.codigo_producto = p.codigo_producto
GROUP BY c.nombre_cliente, p.gama
ORDER BY c.nombre_cliente;


-- PUNTO 3
-- 1 Devuelve un listado que muestre solamente los clientes que no hayan realizado ningun pago
SELECT 
c.nombre_cliente AS nombre_cliente,
c.apellido_contacto AS apellido_contacto
FROM cliente c
LEFT JOIN pago p
ON c.codigo_cliente = p.codigo_cliente
WHERE fecha_pago IS NULL; 

-- 2. Devuelve un listado que muestre solamente los clientes que no han realizado ningún
-- pedido.

SELECT
	c.nombre_cliente AS nombre_cliente,
    c.apellido_contacto AS apellido_cliente
    FROM cliente c
    LEFT JOIN pedido p
    ON c.codigo_cliente = p.codigo_pedido
    WHERE codigo_pedido IS NULL;


-- 3. Devuelve un listado que muestre los clientes que no han realizado ningún pago y los que no
-- han realizado ningún pedido.
SELECT distinct
	c.nombre_cliente AS nombre_cliente,
    c.apellido_contacto AS apellido_cliente
    FROM cliente c
    LEFT JOIN pedido p
    ON c.codigo_cliente = p.codigo_cliente
    LEFT JOIN pago pag
    ON c.codigo_cliente = pag.codigo_cliente
    WHERE p.codigo_pedido IS NULL AND pag.id_transaccion IS NULL;

-- 4. Devuelve un listado que muestre solamente los empleados que no tienen una oficina
-- asociada.

SELECT 
e.nombre AS nombre_empleado,
e.apellido1 AS apellido_empleado
FROM empleado e
LEFT JOIN oficina o
ON e.codigo_oficina = o.codigo_oficina;
-- WHERE o.codigo_oficina IS NULL ; NINGUNO TIENE OFICINA ASOCIADA

-- 5 Devuelve un listado que muestre solamente los empleados que no tienen un cliente
-- asociado.

SELECT e.codigo_empleado, e.nombre, e.apellido1, e.apellido2
FROM empleado e
LEFT JOIN cliente c 
    ON e.codigo_empleado = c.codigo_empleado_rep_ventas
WHERE c.codigo_cliente IS NULL;

-- 6 Devuelve un listado que muestre solamente los empleados que no tienen un cliente
-- asociado junto con los datos de la oficina donde trabajan.

SELECT  e.nombre AS nombre_empleado, e.apellido1, e.apellido2, o.*
FROM empleado e
LEFT JOIN cliente c 
    ON e.codigo_empleado = c.codigo_empleado_rep_ventas
INNER JOIN oficina o
ON e.codigo_oficina = o.codigo_oficina
WHERE c.codigo_cliente IS NULL;

-- 7. Devuelve un listado que muestre los empleados que no tienen una oficina asociada y los
-- que no tienen un cliente asociado.

SELECT 
e.nombre AS nombre_empleado,
e.apellido1 AS apellido_empleado
FROM empleado e
LEFT JOIN oficina o
ON e.codigo_oficina = o.codigo_oficina
LEFT JOIN cliente c
ON c.codigo_empleado_rep_ventas = e.codigo_empleado
WHERE o.codigo_oficina IS NULL OR c.codigo_cliente IS NULL;   

-- 8. Devuelve un listado de los productos que nunca han aparecido en un pedido.
SELECT
pr.nombre AS nombre_producto,
dp.codigo_producto
FROM producto pr
LEFT JOIN detalle_pedido dp
ON pr.codigo_producto = dp.codigo_producto
WHERE dp.codigo_producto IS NULL;

-- 9. Devuelve un listado de los productos que nunca han aparecido en un pedido. El resultado
-- debe mostrar el nombre, la descripción y la imagen del producto.
SELECT
pr.nombre AS nombre_producto, pr.descripcion, pr.gama,
dp.codigo_producto
FROM producto pr
LEFT JOIN detalle_pedido dp
ON pr.codigo_producto = dp.codigo_producto
WHERE dp.codigo_producto IS NULL;


-- 10. Devuelve las oficinas donde no trabajan ninguno de los empleados que hayan sido los
-- representantes de ventas de algún cliente que haya realizado la compra de algún producto
-- de la gama Frutales.

SELECT 
o.codigo_oficina AS oficina, o.pais AS pais_oficina, o.ciudad AS ciudad_oficina
FROM oficina o
LEFT JOIN empleado e
ON o.codigo_oficina = e.codigo_oficina
LEFT JOIN cliente c
ON e.codigo_empleado = c.codigo_empleado_rep_ventas
LEFT JOIN pedido p 
ON p.codigo_cliente = c.codigo_cliente
LEFT JOIN detalle_pedido dp
ON dp.codigo_pedido = p.codigo_pedido
LEFT JOIN producto pr
ON dp.codigo_producto = pr.codigo_producto
    AND pr.gama = 'Frutales'
WHERE  pr.codigo_producto IS NULL;
-- LEFT JOIN gama_producto gp
-- ON gp.gama = pr.gama
-- WHERE pr.gama = "FRUTALES" OR o.codigo_oficina IS NULL;




-- 11. Devuelve un listado con los clientes que han realizado algún pedido, pero no han realizado
-- ningún pago.

SELECT 
c.nombre_cliente AS nombre_cliente,
c.apellido_contacto AS apellido_cliente
FROM cliente c
INNER JOIN pedido p -- porque necesito traer solo los pedidos hechos, no los nulos
ON c.codigo_cliente = p.codigo_cliente
LEFT JOIN pago pag -- acá si porque necesito los nulos
ON pag.codigo_cliente = c.codigo_cliente
WHERE pag.id_transaccion IS NULL  ;


-- 12. Devuelve un listado con los datos de los empleados que no tienen clientes asociados y el
-- nombre de su jefe asociado.

SELECT 
    e.nombre AS nombre_empleado,
    e.apellido1 AS apellido_empleado,
    j.nombre AS nombre_jefe,
    j.apellido1 AS apellido_jefe
FROM empleado e
LEFT JOIN cliente c
    ON e.codigo_empleado = c.codigo_empleado_rep_ventas
 LEFT JOIN empleado j
    ON e.codigo_jefe = j.codigo_empleado
WHERE c.codigo_cliente IS NULL;

-- 4 Consultas resumen
-- 1. ¿Cuántos empleados hay en la compañía?

SELECT COUNT(codigo_empleado) AS cantidad_empleados
FROM empleado;
-- 2 ¿Cuántos clientes tiene cada país?

Select 
count(codigo_cliente) as cantidad_cliente, 
pais
FROM cliente
GROUP BY pais;


-- 3 ¿Cuál fue el pago medio en 2009?
SELECT 
    AVG(total) AS pago_medio_2009
FROM pago
WHERE YEAR(fecha_pago) = 2009;

-- 4 ¿Cuántos pedidos hay en cada estado? Ordena el resultado de forma descendente por el
-- número de pedidos.

SELECT count(codigo_pedido) as cantidad_pedidos,
estado
FROM pedido
group by estado
order by codigo_pedido desc;

-- 5 Calcula el precio de venta del producto más caro y más barato en una misma consulta.
SELECT 
    MAX(precio_venta) AS precio_mas_caro,
    MIN(precio_venta) AS precio_mas_barato
FROM producto;

-- 6 Calcula el número de clientes que tiene la empresa.

SELECT 
count(codigo_cliente)
FROM cliente ;

-- 7. ¿Cuantos clientes existen con domicilio en la ciudad de Madrid?
SELECT count(codigo_cliente) AS cantidad_clientes, ciudad
FROM cliente
WHERE ciudad = "Madrid";

-- 8. ¿Calcula cuántos clientes tiene cada una de las ciudades que empiezan por M?
SELECT 
    ciudad,
    COUNT(codigo_cliente) AS cantidad_clientes
FROM cliente
WHERE ciudad LIKE 'M%'
GROUP BY ciudad;

-- 9. Devuelve el nombre de los representantes de ventas y el número de clientes al que atiende
-- cada uno.

SELECT 
    e.nombre AS nombre_representante,
    e.apellido1 AS apellido_representante,
    COUNT(c.codigo_cliente) AS cantidad_clientes
FROM empleado e
LEFT JOIN cliente c
    ON e.codigo_empleado = c.codigo_empleado_rep_ventas
GROUP BY e.codigo_empleado, e.nombre, e.apellido1
ORDER BY cantidad_clientes DESC;

-- 10. Calcula el número de clientes que no tiene asignado representante de ventas.
SELECT 
    COUNT(codigo_cliente) AS clientes_sin_representante
FROM cliente
WHERE codigo_empleado_rep_ventas IS NULL;

-- 11. Calcula la fecha del primer y último pago realizado por cada uno de los clientes. El listado
-- deberá mostrar el nombre y los apellidos de cada cliente.
SELECT 
    c.nombre_cliente,
    c.apellido_contacto,
    MIN(p.fecha_pago) AS primer_pago,
    MAX(p.fecha_pago) AS ultimo_pago
FROM cliente c
LEFT JOIN pago p
    ON c.codigo_cliente = p.codigo_cliente
GROUP BY c.codigo_cliente, c.nombre_cliente, c.apellido_contacto
ORDER BY c.nombre_cliente;
 
-- 12. Calcula el número de productos diferentes que hay en cada uno de los pedidos.
SELECT codigo_pedido,
       COUNT(DISTINCT codigo_producto)
FROM detalle_pedido 
GROUP BY codigo_pedido;

-- 13. Calcula la suma de la cantidad total de todos los productos que aparecen en cada uno de
-- los pedidos.   

SELECT 
    codigo_pedido,
    SUM(cantidad) AS total_productos
FROM detalle_pedido
GROUP BY codigo_pedido
ORDER BY codigo_pedido;

-- 14. Devuelve un listado de los 20 productos más vendidos y el número total de unidades que se
-- han vendido de cada uno. El listado deberá estar ordenado por el número total de unidades
-- vendidas.

SELECT 
    dp.codigo_producto,
    SUM(dp.cantidad) AS total_unidades_vendidas
FROM detalle_pedido dp
GROUP BY dp.codigo_producto
ORDER BY total_unidades_vendidas DESC -- de esta forma se me ordena de mayor a menos
LIMIT 20; -- establezco un limite donde me muestra solo los 20 mas vendidos, los primeros 20 resultados que son los mayores


-- 15. La facturación que ha tenido la empresa en toda la historia, indicando la base imponible, el
-- IVA y el total facturado. La base imponible se calcula sumando el coste del producto por el
-- número de unidades vendidas de la tabla detalle_pedido. El IVA es el 21 % de la base
-- imponible, y el total la suma de los dos campos anteriores.
SELECT 
    SUM(dp.cantidad * p.precio_venta) AS base_imponible,
    SUM(dp.cantidad * p.precio_venta) * 0.21 AS iva,
    SUM(dp.cantidad * p.precio_venta) + SUM(dp.cantidad * p.precio_venta) * 0.21 AS total_facturado
FROM detalle_pedido dp
JOIN producto p
    ON dp.codigo_producto = p.codigo_producto;
    
-- 16. La misma información que en la pregunta anterior, pero agrupada por código de producto.
SELECT 
    dp.codigo_producto,
    SUM(dp.cantidad * p.precio_venta) AS base_imponible,
    SUM(dp.cantidad * p.precio_venta) * 0.21 AS iva,
    SUM(dp.cantidad * p.precio_venta) + SUM(dp.cantidad * p.precio_venta) * 0.21 AS total_facturado
FROM detalle_pedido dp
JOIN producto p
    ON dp.codigo_producto = p.codigo_producto
GROUP BY dp.codigo_producto
ORDER BY total_facturado DESC;


-- 17. La misma información que en la pregunta anterior, pero agrupada por código de producto
-- filtrada por los códigos que empiecen por OR.

SELECT 
    dp.codigo_producto,
    SUM(dp.cantidad * p.precio_venta) AS base_imponible,
    SUM(dp.cantidad * p.precio_venta) * 0.21 AS iva,
    SUM(dp.cantidad * p.precio_venta) * 1.21 AS total_facturado
FROM detalle_pedido dp
JOIN producto p
    ON dp.codigo_producto = p.codigo_producto
WHERE dp.codigo_producto LIKE 'OR%'
GROUP BY dp.codigo_producto
ORDER BY total_facturado DESC;

-- 18. Lista las ventas totales de los productos que hayan facturado más de 3000 euros. Se
-- mostrará el nombre, unidades vendidas, total facturado y total facturado con impuestos
-- (21% IVA).

SELECT 
    p.nombre_producto,
    SUM(dp.cantidad) AS unidades_vendidas,
    SUM(dp.cantidad * p.precio_venta) AS total_facturado,
    SUM(dp.cantidad * p.precio_venta) * 1.21 AS total_con_iva
FROM detalle_pedido dp
JOIN producto p
    ON dp.codigo_producto = p.codigo_producto
GROUP BY dp.codigo_producto, p.nombre_producto
HAVING SUM(dp.cantidad * p.precio_venta) > 3000 -- uso having para filtrar sobre un grupo
ORDER BY total_facturado DESC;

-- Subconsultas
-- 6 Con operadores básicos de comparación

-- 1. Devuelve el nombre del cliente con mayor límite de credito
SELECT nombre_cliente
FROM cliente
WHERE limite_credito = (
    SELECT MAX(limite_credito)
    FROM cliente
);


-- 2. Devuelve el nombre del producto que tenga el precio de venta más caro.

SELECT nombre_producto
FROM producto
WHERE precio_venta = (
    SELECT MAX(precio_venta)
    FROM producto
);



-- 3
-- Devuelve el nombre del producto del que se han vendido más unidades. 
-- (Tenga en cuenta que tendrá que calcular cuál es el número total de unidades
 -- que se han vendido de cada producto a partir de los datos de la tabla detalle_pedido)

SELECT nombre AS nombre_producto
FROM producto
WHERE codigo_producto = (
    SELECT codigo_producto
    FROM detalle_pedido
    GROUP BY codigo_producto
    ORDER BY SUM(cantidad_en_stock) DESC
    LIMIT 1 -- para el caso en que haya empate
);


-- 4 Los clientes cuyo límite de credito sea mayor que los pagos que haya realizado. (Sin 
-- utilizar INNER JOIN).

SELECT nombre_cliente, limite_credito
FROM cliente
WHERE limite_credito > (
    SELECT SUM(total)
    FROM pago
    WHERE pago.codigo_cliente = cliente.codigo_cliente
);

-- 5 Devuelve el producto que más unidades tiene en stock.

SELECT nombre AS nombre_producto, cantidad_en_stock
FROM producto
WHERE cantidad_en_stock = (
    SELECT MAX(cantidad_en_stock)
    FROM producto
);

 -- 6 Devuelve el producto que menos unidades tiene en stock.
 

SELECT nombre AS nombre_producto, cantidad_en_stock
FROM producto
WHERE cantidad_en_stock = (
    SELECT MIN(cantidad_en_stock)
    FROM producto
);
 
 
 -- 7 Devuelve el nombre, los apellidos y el email de los empleados que están a cargo de Alberto
-- Soria.

SELECT nombre, apellido1, email
FROM empleado
WHERE codigo_jefe = (
    SELECT codigo_empleado
    FROM empleado
    WHERE nombre = 'Alberto' AND apellido1 = 'Soria'
);
