package com.twodaycom.starvane

import android.media.AudioAttributes
import android.media.SoundPool
import android.content.res.AssetManager
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.starvane/sfx"
    private var soundPool: SoundPool? = null
    private val soundIds = mutableMapOf<String, Int>()
    private val loadedSounds = mutableSetOf<Int>()
    private var sfxVolume = 0.3f

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        val attrs = AudioAttributes.Builder()
            .setUsage(AudioAttributes.USAGE_GAME)
            .setContentType(AudioAttributes.CONTENT_TYPE_SONIFICATION)
            .build()

        soundPool = SoundPool.Builder()
            .setMaxStreams(10)
            .setAudioAttributes(attrs)
            .build()

        soundPool!!.setOnLoadCompleteListener { _, sampleId, status ->
            if (status == 0) loadedSounds.add(sampleId)
        }

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
            .setMethodCallHandler { call, result ->
                try {
                    when (call.method) {
                        "loadSound" -> {
                            val name = call.argument<String>("name")!!
                            val assetManager: AssetManager = assets
                            val path = "flutter_assets/assets/audio/$name"
                            val afd = assetManager.openFd(path)
                            val id = soundPool!!.load(afd, 1)
                            soundIds[name] = id
                            result.success(true)
                        }
                        "playSound" -> {
                            val name = call.argument<String>("name")!!
                            val id = soundIds[name]
                            if (id != null && loadedSounds.contains(id)) {
                                // Per-sound volume adjustment
                                val vol = when {
                                    name.contains("fire") -> sfxVolume * 0.1f
                                    name.contains("enemy_death") -> sfxVolume * 0.35f
                                    name.contains("enemy_hit") -> sfxVolume * 0.25f
                                    else -> sfxVolume
                                }
                                soundPool!!.play(id, vol, vol, 1, 0, 1.0f)
                            }
                            result.success(true)
                        }
                        "setVolume" -> {
                            sfxVolume = (call.argument<Double>("volume") ?: 0.5).toFloat()
                            result.success(true)
                        }
                        else -> result.notImplemented()
                    }
                } catch (e: Exception) {
                    result.success(false)
                }
            }
    }

    override fun onDestroy() {
        soundPool?.release()
        soundPool = null
        super.onDestroy()
    }
}
