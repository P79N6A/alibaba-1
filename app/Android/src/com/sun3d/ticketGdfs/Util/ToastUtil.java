package com.sun3d.ticketGdfs.Util;

import com.sun3d.ticketGdfs.MyApplication;

import android.widget.Toast;

/**
 * 弹出显示
 *
 * @author yangyoutao
 */
public class ToastUtil {
    private static Toast toast;

    public static void showToast(String str) {

        if (toast == null) {
            toast = Toast.makeText(MyApplication.getContext(), str, Toast.LENGTH_SHORT);
        } else {
            toast.setText(str);
        }
        toast.show();

    }

    public static void showErrorToast(String status) {
        String tips = "";
        switch (status) {
            case "RESULT_ACTIVITY_ERROR_CODE_10001":
                tips = "对不起，活动订单取票码参数缺失!";
                break;
            case "RESULT_ACTIVITY_ERROR_CODE_10002":
                tips = "对不起，活动订单取票码有误!";
                break;
            case "RESULT_ACTIVITY_ERROR_CODE_10003":
                tips = "对不起，该取票码对应的活动已退订!";
                break;
            case "RESULT_ACTIVITY_ERROR_CODE_10004":
                tips = "对不起，该取票码对应的活动已验票!";
                break;
            case "RESULT_ACTIVITY_ERROR_CODE_10005":
                tips = "对不起，该取票码对应的活动已开始两个小时,不可验票!";
                break;
            case "RESULT_ERROR_CODE_99999":
                tips = "系统错误!";
                break;
            case "RESULT_ROOM_ERROR_CODE_10001":
                tips = "对不起，活动室订单取票码参数缺失!!";
                break;

            case "RESULT_ROOM_ERROR_CODE_10002":
                tips = "对不起，活动室订单取票码有误!";
                break;
            case "RESULT_ROOM_ERROR_CODE_10003":
                tips = "对不起，当天没有已预订的场次，请到网页端\"我的空间\"查询取票码对应的活动/活动场次!";
                break;
            case "RESULT_ROOM_ERROR_CODE_10004":
                tips = "对不起，您预订的活动室已过期,不可验票!";
                break;
            case "RESULT_ROOM_ERROR_CODE_10005":
                tips = "对不起，该取票码对应的活动室已验票!";
                break;
        }
        toast = Toast.makeText(MyApplication.getContext(), tips, Toast.LENGTH_SHORT);
        toast.show();
    }

}
