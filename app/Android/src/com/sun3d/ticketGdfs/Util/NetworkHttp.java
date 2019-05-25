package com.sun3d.ticketGdfs.Util;

import android.content.Context;
import android.net.ConnectivityManager;
import android.net.NetworkInfo;
import android.widget.Toast;

public class NetworkHttp {

	/**
	 * 检测网络是否可用
	 * */
	public static boolean isNetworkConnected(Context context) {
		if (context != null) {
			ConnectivityManager mConnectivityManager = (ConnectivityManager) context
					.getSystemService(Context.CONNECTIVITY_SERVICE);
			NetworkInfo mNetworkInfo = mConnectivityManager
					.getActiveNetworkInfo();
			if (mNetworkInfo != null) {
				return mNetworkInfo.isAvailable();
			}else{
				Toast.makeText(context, "您的网络异常，请先确认是否可用！", Toast.LENGTH_LONG).show();
			}
		}
		return false;
	}

}
