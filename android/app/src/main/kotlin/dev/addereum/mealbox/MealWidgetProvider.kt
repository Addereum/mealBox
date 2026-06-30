package dev.addereum.mealbox

import android.appwidget.AppWidgetManager
import android.content.Context
import android.content.SharedPreferences
import android.net.Uri
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetProvider
import es.antonborri.home_widget.HomeWidgetBackgroundIntent

class MealWidgetProvider : HomeWidgetProvider() {
    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray,
        widgetData: SharedPreferences
    ) {
        for (appWidgetId in appWidgetIds) {
            val views = RemoteViews(context.packageName, R.layout.widget_layout)

            val backgroundIntent = HomeWidgetBackgroundIntent.getBroadcast(
                context,
                Uri.parse("myAppWidget://log_simple_meal")
            )
            views.setOnClickPendingIntent(R.id.widget_button, backgroundIntent)

            appWidgetManager.updateAppWidget(appWidgetId, views)
        }
    }
}
