package com.sun3d.ticketGdfs.Util;

import android.content.Context;
import android.view.View;
import android.view.WindowManager;
import android.view.inputmethod.InputMethodManager;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;

public class WindowsUtil {
	/** 获取屏幕的宽度 */
	public final static int getWindowsWidth(Context mContext) {

		WindowManager manager = (WindowManager) mContext.getSystemService(Context.WINDOW_SERVICE);
		int width = manager.getDefaultDisplay().getWidth();

		return width;
	}

	public final static int getwindowsHight(Context mContext) {
		WindowManager manager = (WindowManager) mContext.getSystemService(Context.WINDOW_SERVICE);
		int height = manager.getDefaultDisplay().getHeight();
		return height;

	}


	/**
	 * 隐藏键盘
	 *
	 * @param view
	 */
	public static void HideKeyboard(View view) {
		InputMethodManager imm = (InputMethodManager) view.getContext()
				.getSystemService(Context.INPUT_METHOD_SERVICE);
		imm.hideSoftInputFromWindow(view.getWindowToken(), 0);
	}

	/**
	 * 比较时间与当前时间
	 */
	public static boolean isMaxData(String str) {
		Date date1 = new Date();
		SimpleDateFormat dd = new SimpleDateFormat("yyyy-MM-dd HH:mm");
		try {
			Date date = dd.parse(str);  //String->Date
			//判断时间（与（当前时间-1）比较）
			if (date.after(new Date(date1.getTime()))) {
				return true;
			}
		} catch (ParseException e) {
			e.printStackTrace();
		}
		return false;
	}
}
