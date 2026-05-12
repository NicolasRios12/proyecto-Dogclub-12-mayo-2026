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

<img width="795" height="504" alt="image" src="https://github.com/user-attachments/assets/fc63b30f-4a58-4862-a18a-353cf6633432" />
<img width="794" height="441" alt="image" src="https://github.com/user-attachments/assets/870f55f1-cfef-4a2d-bedf-889b556e639e" />
<img width="792" height="437" alt="image" src="https://github.com/user-attachments/assets/1baff6aa-9dcd-483a-bef7-fe938c209334" />
<img width="793" height="380" alt="image" src="https://github.com/user-attachments/assets/5cf758e2-4d44-4cbf-8ddd-dcf0bff46072" />
<img width="784" height="567" alt="image" src="https://github.com/user-attachments/assets/bd28310d-7fb0-4b5e-946a-d35c6af77f6e" />
<img width="800" height="401" alt="image" src="https://github.com/user-attachments/assets/4d2f82b4-3395-4d59-973f-cb2067a6d9ba" />
<img width="806" height="408" alt="image" src="https://github.com/user-attachments/assets/23556836-5c17-4c32-b830-b4b8b76c2fd1" />

