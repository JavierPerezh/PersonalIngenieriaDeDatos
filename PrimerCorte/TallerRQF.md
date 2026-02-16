# Taller: Definición de Requisitos Funcionales

## 1. Definición de Requisitos Funcionales para el Sistema de Gestión de Vacantes para Eventos

| **CÓDIGO** | **REQUISITOS FUNCIONALES** |
|:----------:|:----------------------------|
| **RQF001** | **Nombre:** Gestión de Eventos |
| | **Descripción:** El sistema debe permitir a los usuarios autorizados crear, modificar y consultar los eventos. Para cada evento se debe poder registrar: nombre, fecha de inicio, fecha de fin, departamento, municipio y los sitios específicos donde se llevará a cabo. |
| | **Usuarios:** Administradores nacionales, Personal de planeación |

| **CÓDIGO** | **REQUISITOS FUNCIONALES** |
|:----------:|:----------------------------|
| **RQF002** | **Nombre:** Definición de Cupos por Cargo y Sitio |
| | **Descripción:** El sistema debe permitir asociar a un evento y a un sitio específico los cargos requeridos (Coordinador, Supervisor, Digitador, Apoyo logístico, entre otros) y definir la cantidad de cupos disponibles para cada uno de estos cargos. El sistema deberá validar que no se creen registros duplicados para la combinación de evento, sitio y cargo. |
| | **Usuarios:** Administradores nacionales, Personal de planeación |

| **CÓDIGO** | **REQUISITOS FUNCIONALES** |
|:----------:|:----------------------------|
| **RQF003** | **Nombre:** Consulta de Disponibilidad de Cupos |
| | **Descripción:** El sistema debe proporcionar una funcionalidad de búsqueda y consulta que permita visualizar en tiempo real los cupos disponibles para un cargo específico en un sitio y evento determinados. Los resultados deben poder filtrarse por ciudad, cargo y evento. |
| | **Usuarios:** Administradores nacionales, Coordinadores regionales, Personal de planeación |

| **CÓDIGO** | **REQUISITOS FUNCIONALES** |
|:----------:|:----------------------------|
| **RQF004** | **Nombre:** Modificación y Bloqueo de Cupos |
| | **Descripción:** El sistema debe permitir la modificación de los cupos definidos para un cargo en un sitio siempre y cuando el evento no haya iniciado. Una vez que la fecha de inicio del evento haya llegado, el sistema bloqueará automáticamente cualquier modificación en los cupos, garantizando la integridad de la información para la ejecución del evento. |
| | **Usuarios:** Administradores nacionales, Personal de planeación |

| **CÓDIGO** | **REQUISITOS FUNCIONALES** |
|:----------:|:----------------------------|
| **RQF005** | **Nombre:** Generación de Reportes |
| | **Descripción:** El sistema debe permitir la generación de reportes consolidados con información histórica y actual. Los reportes deberán poder filtrarse y visualizarse por ciudad, cargo y evento, mostrando la ocupación de cupos. El sistema debe facilitar la consulta de históricos de eventos anteriores. |
| | **Usuarios:** Administradores nacionales, Coordinadores regionales, Personal de planeación |

---

## 2. Análisis de Requisitos Funcionales (Sistema de Facturación y Ventas)

| **Código del RQF** | **Administrador** | **Vendedor** |
|:-------------------:|:-------------------:|:--------------:|
| **RQF001** | **Ingresar al Sistema** | **Ingresar al Sistema** |
| **RQF002** | **Gestionar Productos** | **Consultar Productos** |
| **RQF003** | **Gestionar Clientes** | **Registrar Cliente** |
| **RQF004** | **Gestionar Usuarios** | |
| **RQF005** | **Abrir Caja** | **Abrir Caja** |
| **RQF006** | **Realizar Venta** | **Realizar Venta** |
| **RQF007** | **Anular Venta** | |
| **RQF008** | **Gestionar Formas de Pago** | **Consultar Formas de Pago** |
| **RQF009** | **Generar Reporte de Ventas** | |
| **RQF010** | **Consultar Histórico de Ventas** | **Consultar Histórico de Ventas** |

**Respuesta a la pregunta:**
Sí, es evidente que el usuario con perfil de **Vendedor** tiene acceso limitado a las funciones del sistema. Mientras que el **Administrador** puede **Gestionar** (crear, modificar, eliminar) entidades como productos, clientes y usuarios, así como anular ventas y generar reportes, el Vendedor solo puede realizar tareas operativas del día a día, como consultar información, registrar clientes y ejecutar ventas. Esta diferenciación de permisos es un principio básico de seguridad y control en los sistemas de información, asegurando que cada usuario tenga acceso únicamente a las funciones necesarias para cumplir con su rol.
