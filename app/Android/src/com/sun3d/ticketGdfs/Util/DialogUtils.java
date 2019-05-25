package com.sun3d.ticketGdfs.Util;

import android.app.AlertDialog;
import android.content.Context;
import android.view.View;
import android.view.WindowManager;
import android.widget.TextView;

import com.sun3d.ticketGdfs.R;
import com.sun3d.ticketGdfs.base.OnDialogListener;

/**
 * Created by ming on 2016/10/11.
 */

public class DialogUtils {

    /**
     * 提示对话框
     * @param context
     * @param content 提示内容
     * @param onDialogListener
     */
    public static void showDialog(Context context, String content, final OnDialogListener onDialogListener) {
        final AlertDialog dialog = new AlertDialog.Builder(context).show();
        WindowManager.LayoutParams lp = dialog.getWindow().getAttributes();
        // 控制对话框背景的透明度 0.0f~1.0f
        lp.dimAmount = 0.1f;
        dialog.getWindow().setAttributes(lp);
        dialog.setContentView(R.layout.dialog_feedback);
        dialog.setCanceledOnTouchOutside(false);// 点击返回键可取消对话框显示（点击屏幕其他区域不消失）
        TextView textView = (TextView) dialog.findViewById(R.id.settings_man_tv);
        textView.setText(content);

        TextView ok = (TextView) dialog.findViewById(R.id.about_feedback_no);
        ok.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                hideDialog(dialog);
                onDialogListener.onConfirm();
            }
        });
    }

    public static void hideDialog(AlertDialog dialog) {
        if (dialog != null) {
            if (dialog.isShowing()) {
                dialog.dismiss();
            }
        }
    }

}
