GreenBite - Sistema de Gestión de Pedidos

Requisitos Funcionales

RQF001 Nombre: Registro de Pedidos a Domicilio
 Descripción: El sistema debe permitir al propietario de GreenBite y a los clientes registrar un nuevo pedido a domicilio. El propietario podrá registrar los pedidos que los clientes solicitan por teléfono, mientras que los clientes podrán hacerlo directamente a través de una página web. El formulario de registro debe capturar los datos del cliente como nombre, teléfono y dirección, así como los productos seleccionados, las cantidades, el valor total y el medio de pago. Cada pedido debe quedar almacenado en la base de datos con un número de orden único y con estado Pendiente al momento de crearlo.
 Usuarios: Propietario, Cliente

RQF002 Nombre: Consulta y Actualización de Estado de Pedidos
 Descripción: El sistema debe permitir consultar el estado de un pedido específico mediante su número de orden. Los posibles estados son Pendiente, En preparación, En camino y Entregado. Los usuarios autorizados como el personal de cocina y los domiciliarios deben poder actualizar el estado del pedido a medida que avanza en el proceso de preparación y entrega. Los clientes pueden consultar el estado de su pedido a través de la página web ingresando su número de orden.
 Usuarios: Personal de cocina, Domiciliarios, Cliente, Propietario

Historias de Usuario

---

Usuario: Propietario de GreenBite

Historia: Quiero poder registrar en el sistema los pedidos que los clientes solicitan por teléfono para tener un control organizado de todas las órdenes y evitar la pérdida de información que actualmente ocurre con el uso de papel y lápiz.

Usuario: Cliente de GreenBite

Historia: Quiero poder realizar mis pedidos a través de una página web para solicitar los productos de manera más rápida y práctica sin necesidad de llamar por teléfono.

Usuario: Cliente de GreenBite

Historia: Quiero poder consultar el estado de mi pedido en la página web ingresando mi número de orden para saber en qué etapa del proceso se encuentra mi comida y tener una idea de cuándo llegará a mi domicilio.

Usuario: Domiciliario de GreenBite

Historia: Quiero poder actualizar el estado de los pedidos en el sistema cuando voy en ruta y cuando entrego para que los clientes y el propietario estén informados del progreso de la entrega en tiempo real.
