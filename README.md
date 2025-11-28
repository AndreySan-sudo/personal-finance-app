# Finances App - Documentación Técnica

Este documento describe las principales decisiones técnicas y arquitectónicas tomadas durante el desarrollo de la aplicación **Finances App**.

## 1. Arquitectura: Clean Architecture

El proyecto sigue los principios de **Clean Architecture** para asegurar la separación de responsabilidades, la escalabilidad y la facilidad de prueba. El código se organiza en tres capas principales:

*   **Domain (Dominio)**: Es el núcleo de la aplicación. Contiene las **Entidades** (modelos de negocio puros), los **Repositorios** (interfaces abstractas) y los **Casos de Uso** (lógica de negocio específica). Esta capa no depende de ninguna otra capa externa (ni de Flutter, ni de bases de datos).
*   **Data (Datos)**: Implementa las interfaces definidas en el dominio. Contiene los **Modelos** (que extienden las entidades y añaden lógica de serialización JSON), los **Data Sources** (conexiones a APIs, bases de datos Firebase) y las implementaciones de los **Repositorios**.
*   **Presentation (Presentación)**: Contiene la interfaz de usuario (UI) y la gestión de estado. Aquí se encuentran las **Pages** (pantallas), **Widgets** y **BLoCs**.

## 2. Gestión de Estado: BLoC (Business Logic Component)

Se utiliza el patrón **BLoC** (con la librería `flutter_bloc`) para separar la lógica de negocio de la interfaz de usuario.
*   **Eventos**: Representan acciones del usuario (ej. `LoadTransactionsEvent`, `AddTransactionEvent`).
*   **Estados**: Representan la respuesta de la aplicación (ej. `TransactionLoading`, `TransactionLoaded`, `TransactionError`).
*   Esto permite un flujo de datos unidireccional y predecible, facilitando el manejo de estados complejos como cargas, errores y actualizaciones en tiempo real.

## 3. Inyección de Dependencias: GetIt

Se utiliza **GetIt** como "Service Locator" para gestionar la inyección de dependencias.
*   Permite desacoplar las clases, ya que no necesitan instanciar sus dependencias directamente.
*   Facilita el testing al permitir inyectar mocks o implementaciones falsas.
*   La configuración se centraliza en `lib/app/di/injector.dart`.

## 4. Navegación: GoRouter

Se utiliza **GoRouter** para la gestión de rutas.
*   Ofrece una API declarativa y fácil de usar.
*   Soporta rutas anidadas, parámetros en la URL y redirecciones.
*   Es ideal para aplicaciones que funcionan tanto en móvil como en web, permitiendo el uso de URLs limpias (ej. `/home`, `/add`).

## 5. Backend y Autenticación: Firebase

*   **Firebase Auth**: Para la autenticación de usuarios (Login y Registro).
*   **Cloud Firestore**: Como base de datos NoSQL en tiempo real para almacenar las transacciones de los usuarios.

## 6. UI/UX y Diseño

*   **Material Design 3**: Se utiliza la última versión del sistema de diseño de Google.
*   **Responsividad**: Se implementaron restricciones de ancho (`ConstrainedBox`) para asegurar que la aplicación se vea bien en pantallas grandes (Web/Desktop).
*   **Feedback Visual**: Uso de `SnackBar` para mensajes, indicadores de carga (`CircularProgressIndicator`) y validaciones de formularios.
*   **Gráficos**: Se utiliza `fl_chart` para visualizar la distribución de gastos e ingresos.
*   **Formato**: Se implementó `intl` para el formateo de fechas y números (separadores de miles) adaptado a la configuración regional (es_ES).

## 7. Estrategia de URL en Web

Se configuró `PathUrlStrategy` para eliminar el símbolo `#` de las URLs en la versión web, logrando rutas más limpias y estándares (ej. `midominio.com/home` en lugar de `midominio.com/#/home`).
