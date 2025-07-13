package com.leessmin.my_dashcam.activity.camera.data.listener

import androidx.lifecycle.LiveData
import androidx.lifecycle.MutableLiveData


/**
 * 监听取消录制广播
 */
object RecordStopListener {
    private val _stopRecordEvent = MutableLiveData<Unit>()
    // 停止事件
    val stopRecordEvent: LiveData<Unit> get() = _stopRecordEvent


    // 发送取消录制事件
    fun sendStopRecord() {
        _stopRecordEvent.postValue(Unit)
    }
}