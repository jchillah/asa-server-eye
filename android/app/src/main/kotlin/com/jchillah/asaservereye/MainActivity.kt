package com.jchillah.asaservereye

import android.Manifest
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
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

class MainActivity : FlutterActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        WindowCompat.setDecorFitsSystemWindows(window, false)
        createAlertNotificationChannel()
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            LOCAL_NOTIFICATIONS_CHANNEL,
        ).setMethodCallHandler { call, result ->
            when (call.method) {
                METHOD_SHOW_ALERT_NOTIFICATION -> {
                    val title = call.argument<String>(ARG_TITLE)
                        ?: DEFAULT_ALERT_TITLE
                    val body = call.argument<String>(ARG_BODY)
                        ?: DEFAULT_ALERT_BODY
                    val serverId = call.argument<String>(ARG_SERVER_ID)
                    val ruleType = call.argument<String>(ARG_RULE_TYPE)
                    val alertId = call.argument<String>(ARG_ALERT_ID)

                    if (serverId.isNullOrBlank()) {
                        result.success(statusResult(STATUS_MISSING_SERVER_ID))
                        return@setMethodCallHandler
                    }

                    result.success(
                        showAlertNotification(
                            title = title,
                            body = body,
                            serverId = serverId,
                            ruleType = ruleType,
                            alertId = alertId,
                        ),
                    )
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
            ALERT_CHANNEL_ID,
            ALERT_CHANNEL_NAME,
            NotificationManager.IMPORTANCE_HIGH,
        ).apply {
            description = ALERT_CHANNEL_DESCRIPTION
        }

        val manager = getSystemService(NotificationManager::class.java)
        manager.createNotificationChannel(channel)
    }

    private fun showAlertNotification(
        title: String,
        body: String,
        serverId: String,
        ruleType: String?,
        alertId: String?,
    ): Map<String, String> {
        if (!hasNotificationPermission()) {
            return statusResult(STATUS_PERMISSION_DENIED)
        }

        val stableAlertId = alertId?.takeIf { it.isNotBlank() }
            ?: "${serverId}-${System.currentTimeMillis()}"
        val launchIntent = packageManager.getLaunchIntentForPackage(packageName)
            ?: Intent(this, MainActivity::class.java)
        launchIntent.putExtra(EXTRA_SERVER_ID, serverId)
        launchIntent.putExtra(EXTRA_RULE_TYPE, ruleType)
        launchIntent.putExtra(EXTRA_ALERT_ID, stableAlertId)
        launchIntent.addFlags(Intent.FLAG_ACTIVITY_SINGLE_TOP)

        val notificationId = stableAlertId.hashCode() and Int.MAX_VALUE
        val pendingIntent = PendingIntent.getActivity(
            this,
            notificationId,
            launchIntent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE,
        )

        val notification = NotificationCompat.Builder(this, ALERT_CHANNEL_ID)
            .setSmallIcon(applicationInfo.icon)
            .setContentTitle(title)
            .setContentText(body)
            .setStyle(NotificationCompat.BigTextStyle().bigText(body))
            .setPriority(NotificationCompat.PRIORITY_HIGH)
            .setAutoCancel(true)
            .setContentIntent(pendingIntent)
            .build()

        return try {
            NotificationManagerCompat.from(this).notify(notificationId, notification)
            statusResult(STATUS_SHOWN)
        } catch (_: SecurityException) {
            statusResult(STATUS_PERMISSION_DENIED)
        }
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

    private fun statusResult(status: String): Map<String, String> {
        return mapOf(RESULT_STATUS to status)
    }

    companion object {
        private const val LOCAL_NOTIFICATIONS_CHANNEL =
            "asa_server_eye/local_notifications"
        private const val METHOD_SHOW_ALERT_NOTIFICATION =
            "showAlertNotification"

        private const val ARG_TITLE = "title"
        private const val ARG_BODY = "body"
        private const val ARG_SERVER_ID = "serverId"
        private const val ARG_RULE_TYPE = "ruleType"
        private const val ARG_ALERT_ID = "alertId"

        private const val RESULT_STATUS = "status"
        private const val STATUS_SHOWN = "shown"
        private const val STATUS_PERMISSION_DENIED = "permission_denied"
        private const val STATUS_MISSING_SERVER_ID = "missing_server_id"

        private const val EXTRA_SERVER_ID = "asa_server_eye.extra.SERVER_ID"
        private const val EXTRA_RULE_TYPE = "asa_server_eye.extra.RULE_TYPE"
        private const val EXTRA_ALERT_ID = "asa_server_eye.extra.ALERT_ID"

        private const val ALERT_CHANNEL_ID = "asa_server_eye_alerts"
        private const val ALERT_CHANNEL_NAME = "ASA Server Eye Alerts"
        private const val ALERT_CHANNEL_DESCRIPTION =
            "Server population and activity alerts"

        private const val DEFAULT_ALERT_TITLE = "ASA Server Eye Alert"
        private const val DEFAULT_ALERT_BODY = "Server activity changed."
    }
}
