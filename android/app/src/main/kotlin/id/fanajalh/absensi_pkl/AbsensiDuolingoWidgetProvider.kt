package id.fanajalh.absensi_pkl

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.widget.RemoteViews

class AbsensiDuolingoWidgetProvider : AppWidgetProvider() {

    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray
    ) {
        for (appWidgetId in appWidgetIds) {
            updateAppWidget(context, appWidgetManager, appWidgetId)
        }
    }

    companion object {
        private const val PREFS_NAME = "absensi_duolingo_widget_prefs"

        fun saveAndRefresh(
            context: Context,
            streak: String,
            badge: String,
            title: String,
            subtitle: String,
            cta: String
        ) {
            context.getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)
                .edit()
                .putString("streak", streak)
                .putString("badge", badge)
                .putString("title", title)
                .putString("subtitle", subtitle)
                .putString("cta", cta)
                .apply()

            val manager = AppWidgetManager.getInstance(context)
            val ids = manager.getAppWidgetIds(
                ComponentName(context, AbsensiDuolingoWidgetProvider::class.java)
            )
            for (id in ids) {
                updateAppWidget(context, manager, id)
            }
        }

        fun updateAppWidget(
            context: Context,
            appWidgetManager: AppWidgetManager,
            appWidgetId: Int
        ) {
            val prefs = context.getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)
            val streak = prefs.getString("streak", "🔥 15 Hari Streak") ?: "🔥 15 Hari Streak"
            val badge = prefs.getString("badge", "📍 42m · Valid") ?: "📍 42m · Valid"
            val title = prefs.getString("title", "Streak Absen Aman!") ?: "Streak Absen Aman!"
            val subtitle = prefs.getString(
                "subtitle",
                "Sen ✓ · Sel ✓ · Rab ✓ · Kam ✓ · Jum ★"
            ) ?: "Sen ✓ · Sel ✓ · Rab ✓ · Kam ✓ · Jum ★"
            val cta = prefs.getString("cta", "📷 Absen") ?: "📷 Absen"

            val views = RemoteViews(context.packageName, R.layout.widget_duolingo_4x2)
            views.setTextViewText(R.id.widget_streak, streak)
            views.setTextViewText(R.id.widget_badge, badge)
            views.setTextViewText(R.id.widget_title, title)
            views.setTextViewText(R.id.widget_subtitle, subtitle)
            views.setTextViewText(R.id.widget_cta, cta)

            val launchIntent = Intent(context, MainActivity::class.java).apply {
                flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TOP
            }
            val pendingIntent = PendingIntent.getActivity(
                context,
                0,
                launchIntent,
                PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
            )
            views.setOnClickPendingIntent(R.id.widget_root, pendingIntent)
            views.setOnClickPendingIntent(R.id.widget_cta, pendingIntent)

            appWidgetManager.updateAppWidget(appWidgetId, views)
        }
    }
}
