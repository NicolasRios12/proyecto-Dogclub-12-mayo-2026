# 📋 Plan de Implementación: "Guardería Canina" (Flutter + Firebase + Provider)

> 📌 **Nota preliminar:** El término `antigravity` no corresponde a un servicio oficial de Firebase. Se asume que te refieres a la suite estándar de Firebase (Authentication, Firestore, Storage, Crashlytics, etc.). Si `antigravity` es un paquete de terceros específico, la arquitectura planteada permite integrarlo sin modificar la estructura base.

---

## 🔧 Fase 1: Preparación del Entorno y Herramientas
1. **Instalar SDK y herramientas base**
   - Flutter SDK (versión estable LTS)
   - Dart SDK (incluido con Flutter)
   - IDE recomendado: VS Code + extensiones oficiales de Flutter/Dart, o Android Studio
   - Firebase CLI y FlutterFire CLI
   - Git para control de versiones

2. **Configurar emuladores y dispositivos**
   - Android Emulator / iOS Simulator
   - Habilitar modo desarrollador en dispositivo físico (Android/iOS)
   - Verificar conectividad con `flutter doctor`

3. **Crear repositorio y estructura inicial**
   - Inicializar repositorio Git
   - Definir ramas: `main`, `develop`, `feature/*`, `hotfix/*`
   - Configurar `.gitignore` para Flutter y Firebase

---

## 🎨 Fase 2: Diseño UI/UX
1. **Investigación y definición de usuarios**
   - Roles: Dueño de mascota, Staff/Empleado, Administrador
   - Flujos clave: Onboarding → Autenticación → Panel principal → Gestión de perros → Reserva de servicios → Perfil

2. **Wireframes y Prototipos**
   - Crear en Figma/Adobe XD: pantallas de baja y alta fidelidad
   - Validar usabilidad con pruebas rápidas (click-through prototypes)
   - Definir estados de la UI: carga, error, vacío, éxito

3. **Sistema de Diseño (Design Tokens)**
   - Paleta de colores (primario, secundario, acentos, estados)
   - Tipografía (escalas, pesos, jerarquía)
   - Espaciado, bordes, sombras y radios
   - Componentes reutilizables: botones, campos de formulario, tarjetas de perro, calendarios, modales

4. **Accesibilidad y Responsive**
   - Cumplir WCAG 2.1 AA (contraste, tamaños táctiles, lectura en voz alta)
   - Layouts adaptables a móvil, tablet y desktop (Web/Windows/macOS si aplica)

---

## ☁️ Fase 3: Configuración de Firebase
1. **Crear proyecto en Firebase Console**
   - Activar servicios: Authentication, Firestore Database, Crashlytics, Analytics
   - Configurar aplicación: registrar ID de bundle (Android) y bundle ID (iOS)
   - Descargar archivos de configuración (`google-services.json`, `GoogleService-Info.plist`)

2. **Configurar Authentication**
   - Habilitar método: Email/Password
   - Configurar plantillas de correo (verificación, restablecimiento de contraseña)
   - Establecer políticas de seguridad (bloqueo por intentos fallidos, expiración de sesión)

3. **Preparar Firestore**
   - Iniciar en modo prueba (solo para desarrollo)
   - Planear reglas de seguridad por roles
   - Definir índices compuestos necesarios para consultas frecuentes

---

## 📦 Fase 4: Estructura del Proyecto y `pubspec.yaml`
1. **Inicializar proyecto Flutter**
   - `flutter create guarderia_canina --org com.tuempresa`
   - Configurar `pubspec.yaml`: nombre, versión, descripción, assets, fuentes

2. **Organizar directorios**
   ```
   lib/
   ├── core/          # constantes, temas, utilidades, rutas
   ├── data/          # modelos, repositorios, fuentes de datos
   ├── domain/        # entidades, casos de uso, contratos
   ├── presentation/  # pantallas, widgets, providers
   └── main.dart
   ```

3. **Definir dependencias en `pubspec.yaml`** (categorías)
   - **Firebase:** `firebase_core`, `firebase_auth`, `cloud_firestore`, `firebase_crashlytics`
   - **Estado:** `provider`
   - **Navegación:** `go_router` o `auto_route`
   - **UI/Utilidades:** `intl`, `flutter_localizations`, `image_picker`, `cached_network_image`, `formz` o `form_field_validator`, `shimmer`
   - **Testing:** `flutter_test`, `mockito`, `integration_test`
   - **Ejecutar:** `flutter pub get` y verificar compatibilidad de versiones

---

## 🧠 Fase 5: Arquitectura y State Management (Provider)
1. **Configurar inyección de proveedores**
   - `MultiProvider` en `main.dart` con `AuthNotifier`, `ThemeNotifier`, `FirestoreNotifier`
   - Separar proveedores por feature (`DogProvider`, `BookingProvider`, `UserProvider`)

2. **Definir patrón de capas**
   - **Domain:** Entidades puras, interfaces de repositorio, casos de uso
   - **Data:** Implementación de repositorios, mapeo a/desde Firestore, manejo de errores
   - **Presentation:** Widgets conectados a `Consumer`/`Provider.of`, manejo de estados locales

3. **Configurar enrutamiento protegido**
   - Rutas públicas: login, registro, recuperación
   - Rutas privadas: dashboard, gestión, perfil
   - Interceptor de rutas que consulte estado de autenticación antes de renderizar

---

## 🔐 Fase 6: Flujo de Autenticación (Email/Password)
1. **Implementar pantalla de Login**
   - Campos: email, contraseña, botón "Iniciar sesión"
   - Estados: validación, carga, error, redirección exitosa

2. **Implementar registro y recuperación**
   - Registro: email, contraseña, confirmación, términos
   - Recuperación: campo email, envío de enlace, feedback de éxito/error

3. **Conectar con Firebase Auth**
   - Métodos: `signInWithEmailAndPassword`, `createUserWithEmailAndPassword`, `sendPasswordResetEmail`
   - Manejo de excepciones (cuenta no existe, contraseña débil, correo ya registrado)
   - Persistencia de sesión automática (Firebase lo maneja nativamente)

4. **AuthProvider (ChangeNotifier)**
   - Expone: `isLoading`, `errorMessage`, `currentUser`, `isAuthenticated`
   - Métodos: `login()`, `register()`, `resetPassword()`, `logout()`
   - Notifica cambios a la UI para actualizar rutas y datos

---

## 🗃️ Fase 7: Diseño e Integración con Firestore
1. **Estructura de colecciones**
   - `users/{uid}`: perfil, rol, preferencias, fecha de registro
   - `dogs/{dogId}`: nombre, raza, edad, fotos, historial médico, `ownerId` (ref)
   - `bookings/{bookingId}`: `ownerId`, `dogId`, fecha, servicio, estado, `staffId` (opcional)
   - `staff/{uid}`: horario, permisos, asignaciones

2. **Reglas de seguridad (draft)**
   - Solo el dueño puede leer/escribir sus datos y los de sus perros
   - Staff/Admin puede leer/actualizar reservas y perros asignados
   - Validar tipos de datos y campos obligatorios en escritura

3. **Capa de Repositorio**
   - `UserRepository`, `DogRepository`, `BookingRepository`
   - Métodos CRUD + streams en tiempo real (`snapshots()`)
   - Mapeo seguro: `fromJson`, `toJson`, validación de nulos

4. **Optimización de consultas**
   - Uso de `.limit()`, `.startAfterDocument()` para paginación
   - Índices compuestos para filtros combinados (fecha + estado + dueño)
   - Caché local implícita de Firestore + estrategias de refresco manual

---

## 📱 Fase 8: Desarrollo de Interfaces de Usuario
1. **Widget Library interna**
   - `AppButton`, `AppTextField`, `DogCard`, `StatusBadge`, `EmptyStateWidget`, `LoadingOverlay`
   - Tema unificado con `ThemeData` y extensiones de estilo

2. **Pantallas principales**
   - **Dashboard:** resumen de próximas reservas, estado de perros, accesos rápidos
   - **Gestión de Perros:** lista, añadir/editar, galería de fotos, historial
   - **Calendario/Reservas:** vista mensual/semanal, creación de citas, estados
   - **Perfil y Configuración:** datos personales, cambio de contraseña, notificaciones, cierre de sesión
   - **Vista Staff/Admin:** panel de asignaciones, control de asistencia, reportes

3. **Conexión UI ↔ Provider ↔ Firestore**
   - `Consumer` para reactividad
   - Manejo de estados: `loading`, `success`, `error`, `empty`
   - Validación de formularios antes de llamadas a repositorios
   - Feedback visual: SnackBars, diálogos, toasts, shimmer loaders

---

## 🧪 Fase 9: Pruebas y Optimización
1. **Pruebas Unitarias**
   - Modelos, repositorios mock, casos de uso, providers
   - Cobertura mínima del 70% en lógica de negocio

2. **Pruebas de Widgets**
   - Flujos de login, registro, navegación protegida
   - Validación de formularios, estados de carga/error

3. **Pruebas de Integración**
   - Auth + Firestore end-to-end en emulador
   - Verificación de reglas de seguridad con `emulators:start`

4. **Rendimiento y Seguridad**
   - Optimizar queries (evitar lecturas innecesarias)
   - Caché de imágenes, lazy loading de listas
   - Auditoría de reglas de Firestore y manejo de datos sensibles
   - Integración de Crashlytics y Analytics para monitoreo en producción

---

## 🚀 Fase 10: Despliegue y Mantenimiento
1. **Preparación para lanzamiento**
   - Iconos, splash screen, metadatos de tienda
   - Firmado de apps (keystore Android, provisioning iOS)
   - Generar builds de release (`flutter build appbundle`, `flutter build ipa`)

2. **Distribución y publicación**
   - Firebase App Distribution / TestFlight para beta testing
   - Revisión y envío a Google Play Console y Apple App Store Connect
   - Cumplir políticas de privacidad (GDPR/LGPD si aplica), añadir política de privacidad en app

3. **CI/CD y monitoreo**
   - Pipeline con GitHub Actions o Codemagic (test → build → deploy)
   - Alertas de Crashlytics, métricas de uso en Analytics
   - Estrategia de versionado semántico y hotfixes

4. **Mantenimiento continuo**
   - Backups de Firestore (export programado)
   - Rotación de claves y revisión de reglas cada 3 meses
   - Roadmap de features: notificaciones push, pagos, chat staff-dueño, integración con veterinarias

---

## ✅ Checklist de Validación antes de codificar
- [ ] Diseño UI/UX aprobado en Figma con flujos validados
- [ ] Firebase project configurado con Auth y Firestore activos
- [ ] `pubspec.yaml` revisado con versiones compatibles y sin conflictos
- [ ] Estructura de carpetas y naming conventions definidas
- [ ] Reglas de seguridad de Firestore redactadas y probadas en emulador
- [ ] Estrategia de Provider documentada (qué notifica qué y cuándo)
- [ ] Plan de testing y cobertura aceptado
- [ ] Cronograma de sprints asignado (ej. 2 semanas por fase)

---

📌 **Próximo paso:** Cuando este plan sea validado, procederé a generar el código modular por capas (Auth → Provider → Firestore → UI), manteniendo la estructura definida y añadiendo comentarios de arquitectura en cada archivo. ¿Deseas ajustar algún flujo, rol de usuario o prioridad de features antes de continuar?
