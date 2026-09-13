// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'MealBox 🍱';

  @override
  String get breakfast => 'Desayuno';

  @override
  String get lunch => 'Almuerzo';

  @override
  String get dinner => 'Cena';

  @override
  String get snack => 'Snack';

  @override
  String get meal => 'Comida';

  @override
  String get addMeal => 'Agregar';

  @override
  String get addMealTitle => 'Agregar Comida';

  @override
  String get history => 'Historial';

  @override
  String get settings => 'Configuración';

  @override
  String get safeFoods => 'Comidas Seguras';

  @override
  String get safeFoodsDesc =>
      'Agrega comida que siempre puedas comer cuando nada más funcione.';

  @override
  String get therapyExport => 'Exportar Terapia';

  @override
  String get exportPdf => 'Exportar como PDF';

  @override
  String get exportCsv => 'Exportar como CSV';

  @override
  String get exportSuccess => '✅ Datos exportados correctamente';

  @override
  String get noEnergy => '¿Sin energía?';

  @override
  String get sosTitle => 'Ayuda 🆘';

  @override
  String get sosMessageFallback =>
      'Bebe un vaso de agua, come una cucharada de mantequilla de maní o dale una mordida a una manzana. ¡Todo sirve!';

  @override
  String get sosMessagePrefix => '¿Te sientes sin energía? Prueba esto:\n\n';

  @override
  String get cancel => 'Cancelar';

  @override
  String get logNow => '¡Regístralo!';

  @override
  String get delete => 'Eliminar';

  @override
  String get deleteConfirmTitle => 'Confirmar eliminación';

  @override
  String deleteConfirmMessage(String mealType, String time) {
    return '¿Estás seguro/a que quieres eliminar $mealType de la(s) $time?';
  }

  @override
  String todayEaten(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'comidas',
      one: 'comida',
    );
    return 'Comido hoy: $count $_temp0';
  }

  @override
  String water(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'vasos',
      one: 'vaso',
    );
    return 'Agua: $count $_temp0';
  }

  @override
  String get weeklyStats => 'Estadísticas Semanales';

  @override
  String streakDays(int count) {
    return '$count días';
  }

  @override
  String get statsEncouragement =>
      '¡Buen trabajo! En los días con +3 comidas, tu energía es notablemente mejor. 🚀';

  @override
  String get energyHigh => '⚡ Alto';

  @override
  String get energyMed => '🔋 Medio';

  @override
  String get energyLow => '🪫 Bajo';

  @override
  String get tookMeds => '¿Tomar medicamento?';

  @override
  String get loggedLate => 'Agregado tarde';

  @override
  String timeAt(String time) {
    return 'a las $time';
  }

  @override
  String get noMealsToday => 'Sin comidas aún';

  @override
  String get pressAddToStart => '¡Presiona Agregar para empezar!';

  @override
  String get breakfastReminderTitle => '¡Hora del desayuno! 🍳';

  @override
  String get breakfastReminderBody => '¿Ya has desayunado? Registra tu comida.';

  @override
  String get lunchReminderTitle => '¡Hora del almuerzo! 🥗';

  @override
  String get lunchReminderBody => 'No olvides registrar tu comida.';

  @override
  String get dinnerReminderTitle => '¡Hora de la cena! 🍽️';

  @override
  String get dinnerReminderBody =>
      'Hora de la cena. Recuerda registrar tu comida!';

  @override
  String get testNotificationTitle => 'Notificación de prueba 🚀';

  @override
  String get testNotificationBody =>
      'Si ves esto, ¡las notificaciones funcionan!';

  @override
  String get noMealsDesc =>
      'Presiona agregar para comenzar a registrar tu día.';

  @override
  String get simpleMode => 'Simple';

  @override
  String mealAdded(String mealType) {
    return '$mealType agregado ✅';
  }

  @override
  String get themeMode => 'Tema';

  @override
  String get themeSystem => 'Sistema';

  @override
  String get themeLight => 'Claro';

  @override
  String get themeDark => 'Oscuro';

  @override
  String get notifications => 'Notificaciones';

  @override
  String get reminders => 'Recordatorios (Desayuno, Almuerzo, Cena)';

  @override
  String get simpleModeDesc =>
      'Modo simple (Omitir sugerencias de hora/energía)';

  @override
  String get showStats =>
      'Mostrar estadísticas semanales en la pantalla de inicio';

  @override
  String get addSafeFood => 'Agregar Comida Segura';

  @override
  String get newSafeFood => 'Nueva Comida Segura';

  @override
  String get save => 'Guardar';

  @override
  String get deleteData => 'Eliminar todos los datos';

  @override
  String get deleteDataWarning =>
      'Esto eliminará todas tus comidas registradas. Esta acción no se puede deshacer.';

  @override
  String get dataDeleted => 'Todos los datos han sido eliminados';

  @override
  String appVersion(String version) {
    return 'Versión $version';
  }

  @override
  String get todayMealsTitle => 'Comidas de hoy';

  @override
  String exportFailed(String error) {
    return '❌ Error al exportar: $error';
  }

  @override
  String get importDataConfirmTitle => '¿Importar datos?';

  @override
  String get importDataConfirmDesc =>
      'Esto reemplazará TODAS tus comidas existentes.\n¿Estás seguro/a que quieres continuar?';

  @override
  String get importBtn => 'Importar';

  @override
  String get importSuccess => '✅ Datos importados correctamente';

  @override
  String importFailed(String error) {
    return '❌ Error al importar: $error';
  }

  @override
  String get clearDataConfirmTitle => '¿Quieres eliminar todos los datos?';

  @override
  String get clearDataConfirmDesc =>
      'Esto eliminará TODAS tus comidas existentes y no se puede deshacer.\n¿Estás seguro/a que quieres continuar?';

  @override
  String get clearDataBtn => 'Eliminar';

  @override
  String get clearDataSuccess => '✅ Todos los datos han sido eliminados';

  @override
  String clearDataFailed(String error) {
    return '❌ Error al eliminar: $error';
  }

  @override
  String get simpleModeDescSub => 'Solo un botón, sin opciones';

  @override
  String get renameMeals => 'Renombrar comidas';

  @override
  String get renameMealsDesc =>
      'Establece nombres y emojis personalizados para los botones';

  @override
  String get remindersDesc => 'Activar recordatorios leves';

  @override
  String get testNotification => 'Notificación de prueba';

  @override
  String get testNotificationDesc => 'Enviar un mensaje de prueba inmediato';

  @override
  String get testNotificationSent => '¡Notificación de prueba enviado!';

  @override
  String get medicationTracker => 'Registro de medicamentos';

  @override
  String get medicationTrackerDesc =>
      'Preguntar por medicamentos al registrar una comida';

  @override
  String get weeklyStatsDesc =>
      'Mostrar resumen de racha en la pantalla de inicio';

  @override
  String get exportPdfDesc => 'Resumen para un doctor/terapeuta';

  @override
  String get exportCsvName => 'Exportar como CSV (Excel)';

  @override
  String get exportCsvDesc => 'Datos sin procesar en formato de tabla';

  @override
  String get dataManagement => 'Gestionar datos';

  @override
  String get exportData => 'Exportar datos';

  @override
  String get exportDataDesc => 'Crear una copia de seguridad JSON';

  @override
  String get importData => 'Importar datos';

  @override
  String get importDataDesc =>
      'Restaurar desde un archivo de copia de seguridad';

  @override
  String get clearDataWarn => 'Advertencia: Esta acción no se puede deshacer';

  @override
  String get darkModeDesc => 'Activar modo oscuro';

  @override
  String get privacy => 'Privacidad';

  @override
  String get privacyDesc => 'Todos los datos se almacenan localmente';

  @override
  String get privacyDialogText =>
      'Todos los datos se almacenan localmente en su dispositivo. No se envía información a ningún servidor.\n\nLas copias de seguridad solo se crean con su consentimiento explícito.';

  @override
  String get ok => 'De acuerdo';

  @override
  String get developer => 'Desarrollador';

  @override
  String get githubRepo => 'Repositorio GitHub';

  @override
  String get githubRepoDesc => 'Ver código fuente y contribuir';

  @override
  String get devWebsite => 'Sitio web del desarrollador';

  @override
  String get devWebsiteDesc => 'Más información del autor';

  @override
  String get linkError => 'No se pudo abrir el enlace';

  @override
  String get aboutApp => 'Sobre MealBox';

  @override
  String get historyTitle => 'Historial de Comidas 📅';

  @override
  String get mealDeleted => 'Comida eliminada';

  @override
  String get noMealsOnDay => 'Sin comidas este día';

  @override
  String totalMeals(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'comidas',
      one: 'comida',
    );
    return 'Total: $count $_temp0';
  }

  @override
  String get safeFoodsTitle => 'Comidas Seguras 🛟';

  @override
  String get noSafeFoods => 'Aún no se han agregado comidas seguras.';

  @override
  String get safeFoodName => 'Nombre de la comida';

  @override
  String get safeFoodAction => '¿Qué quieres hacer?';

  @override
  String get logFood => 'Registro (Energía baja)';

  @override
  String get time => 'Hora';

  @override
  String get energyLevelText => 'Nivel de energía';

  @override
  String get unknown => 'Desconocido';

  @override
  String get weekPrefix => 'Semana de';

  @override
  String get whatDidYouEat => '¿Qué comiste? 🍽️';

  @override
  String get selectTime => 'Seleccionar hora';

  @override
  String get resetToNow => 'Restablecer actual';

  @override
  String get loggedLateHint => 'Se registrará como Agregado tarde';

  @override
  String get currentTimeHint =>
      'Si no se selecciona una, se utiliza la hora actual.';

  @override
  String get energyLevelOpt => 'Nivel de energía (opcional):';

  @override
  String get addPhoto => 'Agregar imagen';

  @override
  String mealNumber(int number) {
    return 'Comida $number';
  }
}
