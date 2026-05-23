package com.jchillah.asaservereye

import android.Manifest
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.os.Build
import android.os.Bundle
import androidx.core.app.NotificationCompat
import androidx.core.app.NotificationManagerCompat
import androidx.core.content.ContextCompat
import androidx.core.view.WindowCompat
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import kotlin.math.abs

class MainActivity : FlutterActivity() {
    private val notificationChannel = "asa_server_eye/local_notifications"
    private val alertChannelId = "asa_server_eye_alerts"

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        WindowCompat.setDecorFitsSystemWindows(window, false)
        createAlertNotificationChannel()
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            notificationChannel,
        ).setMethodCallHandler { call, result ->
            when (call.method) {
                "showAlertNotification" -> {
                    val title = call.argument<String>("title") ?: "ASA Server Eye Alert"
                    val body = call.argument<String>("body") ?: "Server activity changed."
                    val serverId = call.argument<String>("serverId") ?: body
                    val shown = showAlertNotification(title, body, serverId)
                    result.success(shown)
                }
                else -> result.notImplemented()
            }
        }
    }

    private fun createAlertNotificationChannel() {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.O) {
            return
        }

        val channel = NotificationChannel(
            alertChannelId,
            "ASA Server Eye Alerts",
            NotificationManager.IMPORTANCE_HIGH,
        ).apply {
            description = "Server population and activity alerts"
        }

        val manager = getSystemService(NotificationManager::class.java)
        manager.createNotificationChannel(channel)
    }

    private fun showAlertNotification(
        title: String,
        body: String,
        serverId: String,
    ): Boolean {
        if (!hasNotificationPermission()) {
            return false
        }

        val launchIntent = packageManager.getLaunchIntentForPackage(packageName)
            ?: Intent(this, MainActivity::class.java)
        val pendingIntent = PendingIntent.getActivity(
            this,
            0,
            launchIntent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE,
        )

        val notification = NotificationCompat.Builder(this, alertChannelId)
            .setSmallIcon(applicationInfo.icon)
            .setContentTitle(title)
            .setContentText(body)
            .setStyle(NotificationCompat.BigTextStyle().bigText(body))
            .setPriority(NotificationCompat.PRIORITY_HIGH)
            .setAutoCancel(true)
            .setContentIntent(pendingIntent)
            .build()

        val notificationId = abs(serverId.hashCode())
        NotificationManagerCompat.from(this).notify(notificationId, notification)
        return true
    }

    private fun hasNotificationPermission(): Boolean {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.TIRAMISU) {
            return true
        }

        return ContextCompat.checkSelfPermission(
            this,
            Manifest.permission.POST_NOTIFICATIONS,
        ) == PackageManager.PERMISSION_GRANTED
    }
}
