Perfecto, actuaré como DBA del proyecto **Dog Club**. Primero déjame diseñar el esquema de base de datos completo.---

## 🐾 Dog Club — Diseño de Base de Datos

Aquí está el esquema completo. A continuación el detalle técnico de cada decisión:

<img width="520" height="780" alt="image" src="https://github.com/user-attachments/assets/fbfc2d3c-0c1f-49a6-9b98-cc84ae38221e" />

---

### Entidades principales

**`CLIENTES`** — dueños de las mascotas. Núcleo del negocio; todas las interacciones parten de aquí.

**`MASCOTAS`** — vinculadas a un cliente (`id_cliente FK`). El campo `tamanio` (pequeño/mediano/grande) es clave porque el precio de muchos servicios varía según este dato. `notas_medicas` permite registrar alergias, condiciones especiales o restricciones de cuidado.

**`SERVICIOS`** — catálogo de lo que ofrece la guardería: guardería diurna, guardería nocturna, paseo, baño y corte, etc. `categoria` agrupa los servicios (`guarderia`, `cuidado`, `paseo`) para filtros y reportes. `duracion_min` es necesario para calcular disponibilidad de empleados.

**`EMPLEADOS`** — paseadores, cuidadores, grooming. El campo `rol` define qué tipo de servicios puede atender cada uno.

**`RESERVACIONES`** — tabla central que cruza mascota + servicio + empleado + horario. El campo `estado` maneja el ciclo: `pendiente → confirmada → en_curso → completada → cancelada`.

**`PAGOS`** — separado de reservaciones para soportar pagos parciales, cobros posteriores o métodos mixtos. El `estado` puede ser `pendiente`, `pagado`, `reembolsado`.

**`INCIDENCIAS`** — registro de eventos durante el servicio (accidente, conducta agresiva, enfermedad repentina). Crítico para guarderías con muchos animales. `severidad`: `baja`, `media`, `alta`.

---

### Decisiones de diseño relevantes

- **Un pago por reservación** (`||--o|`) — si se necesitara cuotas, se cambiaría a `o{`.
- **Precio final en RESERVACIONES** — permite aplicar descuentos o ajustes sin tocar el catálogo de servicios.
- **`activo` en SERVICIOS y EMPLEADOS** — borrado lógico; nunca se eliminan registros con historial.

¿Quieres que avancemos con el DDL en SQL, los índices recomendados, o alguna entidad adicional como `VACUNAS` o `SUSCRIPCIONES`?
