package com.leessmin.my_dashcam.activity.camera.utils

import android.graphics.Canvas
import android.graphics.Color
import android.graphics.Paint
import android.graphics.Path
import android.graphics.Rect
import android.util.Log

/**
 * 绘制水印层
 */
class DrawWatermark {
    // 填充色
    private val textPaint = Paint().apply {
        color = Color.WHITE
        textSize = 80f
        isAntiAlias = true // 抗锯齿
    }

    // 描边
    private val strokePaint = Paint().apply {
        color = Color.BLACK
        textSize = 80f
        isAntiAlias = true
        style = Paint.Style.STROKE // 描边样式
        strokeWidth = 10f
    }

    // 描绘文字的路径
    private val path = Path()

    /**
     * 绘制水印
     * @param canvas 画布
     * @param text 需要描绘的文字
     * @param rotate 绘制方向 90的倍数 1-90 2-180 3-270
     */
    fun draw(canvas: Canvas, text: String, rotate: Int) {
        // 获取可绘制区域
        val rect = canvas.clipBounds

        // 更改绘制方向 真正可绘画的中心点
        canvas.rotate(rotate * 90f, (rect.right + rect.left) / 2f, (rect.bottom + rect.top) / 2f)

        // 计算文本宽度和高度
        val textBounds = Rect()
        textPaint.getTextBounds(text, 0, text.length, textBounds)
        val textWidth = textPaint.measureText(text)

        // 文本绘制坐标
        val x = rect.right - textWidth - 50f
        val y = rect.bottom - 50f

        textPaint.getTextPath(text, 0, text.length, x, y, path)
        // 绘制描边
        canvas.drawPath(path, strokePaint)
        // 绘制填充
        canvas.drawPath(path, textPaint)
    }
}