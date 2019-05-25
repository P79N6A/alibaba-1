package com.sun3d.ticketGdfs.activity;

import android.annotation.SuppressLint;
import android.app.Activity;
import android.app.ProgressDialog;
import android.content.Context;
import android.content.DialogInterface;
import android.content.DialogInterface.OnKeyListener;
import android.content.Intent;
import android.content.SharedPreferences;
import android.content.SharedPreferences.Editor;
import android.os.Bundle;
import android.os.Handler;
import android.util.Log;
import android.view.Gravity;
import android.view.KeyEvent;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.EditText;
import android.widget.LinearLayout;
import android.widget.TextView;
import android.widget.Toast;

import com.sun3d.ticketGdfs.MyApplication;
import com.sun3d.ticketGdfs.R;
import com.sun3d.ticketGdfs.Util.Constants;
import com.sun3d.ticketGdfs.Util.JsonUtil;
import com.sun3d.ticketGdfs.Util.NetworkHttp;
import com.sun3d.ticketGdfs.entity.UserInfo;
import com.sun3d.ticketGdfs.http.HttpCode;
import com.sun3d.ticketGdfs.http.HttpRequestCallback;
import com.sun3d.ticketGdfs.http.HttpUrlList;
import com.sun3d.ticketGdfs.http.MyHttpRequest;

import java.util.HashMap;
import java.util.Map;

public class FuzzyInterfaceActivity extends Activity implements OnClickListener {

    private Context mContext;
    private LinearLayout contentLayout;

    public int select = 0;
    private int shoice = 404;

    private ProgressDialog mProgress;
    private SharedPreferences sp;

    @SuppressLint("WrongConstant")
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        // TODO Auto-generated method stub
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_userdialog_layout);
        MyApplication.addActivitys(this);
        sp = getSharedPreferences("login", Intent.FILL_IN_ACTION);
        this.mContext = this;
        initIntent();

        initDialog();

        LinearLayout main = (LinearLayout) findViewById(R.id.main);
        contentLayout = (LinearLayout) findViewById(R.id.content_layout);
//        FastBlur.setLinearLayoutBG(mContext, main);
        selectInterface(select);
//        addValidation();
    }


    private void initDialog() {
        // TODO Auto-generated method stub
        if (mProgress == null) {
            mProgress = new ProgressDialog(this);
            mProgress.setTitle("");
            mProgress.setMessage("登录中请稍后···");
            // 设置在激活状态不可点击关闭
            mProgress.setCancelable(false);
            // 设置在按下返回键的时候关闭对话框
            mProgress.setOnKeyListener(new OnKeyListener() {
                @Override
                public boolean onKey(DialogInterface dialog, int keyCode,
                                     KeyEvent event) {
                    if (keyCode == KeyEvent.KEYCODE_BACK) {
                        mProgress.dismiss();
                    }
                    return false;
                }
            });
        }
    }

    private void closeDialog() {
        if (mProgress != null) {
            mProgress.dismiss();
            mProgress = null;
        }
    }

    private void initIntent() {
        // TODO Auto-generated method stub
        int sel = getIntent().getIntExtra(Constants.INTENT_TRANSFER.CHOICE, 404);
        shoice = getIntent().getIntExtra(Constants.INTENT_TRANSFER.CHOICE_LOGIN, 404);
        if (sel == 404) {
            Toast.makeText(getApplicationContext(), "界面跳转错误！", Toast.LENGTH_LONG).show();
            FuzzyInterfaceActivity.this.finish();
        } else {
            select = sel;
        }
    }

    public void selectInterface(int select) {
        switch (select) {
            case Constants.INTENT_TRANSFER.INTENT_MAIN:
                initDialog();
                addFastLogin();
                break;
            case Constants.INTENT_TRANSFER.INTENT_VERI:
                addValidation();
                break;
            default:
                break;
        }
    }

    private void addValidation() {
        contentLayout.removeAllViewsInLayout();
        LinearLayout fastloginLayout = (LinearLayout) getLayoutInflater()
                .inflate(R.layout.code_info_dialog, null);

//        ImageButton back = (ImageButton) fastloginLayout.findViewById(R.id.fastlogin_return);
//        back.setOnClickListener(new OnClickListener() {
//            @Override
//            public void onClick(View v) {
//                finish();
//            }
//        });
        TextView back = (TextView) fastloginLayout.findViewById(R.id.code_info_dialog_back);
        back.setOnClickListener(new OnClickListener() {
            @Override
            public void onClick(View v) {
                finish();
            }
        });
        contentLayout.setGravity(Gravity.CENTER);
        contentLayout.addView(fastloginLayout);


        new Handler().postDelayed(new Runnable() {

            public void run() {
                //execute the task
                FuzzyInterfaceActivity.this.finish();
            }

        }, 10000);
    }

    /**
     * login登录界面
     */
    private void addFastLogin() {
        contentLayout.removeAllViewsInLayout();
        LinearLayout fastloginLayout = (LinearLayout) getLayoutInflater()
                .inflate(R.layout.dialog_fastlogin_layout, null);
        fastloginLayout.findViewById(R.id.fastlogin_return).setOnClickListener(
                this);
        final EditText inputaccount = (EditText) fastloginLayout
                .findViewById(R.id.fastlogin_input_account);
        final EditText inputpassword = (EditText) fastloginLayout
                .findViewById(R.id.fastlogin_input_password);
        inputaccount.setText(sp.getString("account", ""));
//		inputpassword.setText(sp.getString("password", ""));

        contentLayout.addView(fastloginLayout);
        fastloginLayout.findViewById(R.id.fastlogin_login).setOnClickListener(
                new OnClickListener() {

                    @Override
                    public void onClick(View arg0) {
                        final String account = inputaccount.getText().toString();
                        final String password = inputpassword.getText().toString();
                        Map<String, String> params = new HashMap<String, String>();
                        params.put(HttpUrlList.AllParameter.LOGIN_ACCOUNT,
                                account);
                        params.put(HttpUrlList.AllParameter.LOGIN_PASSWORD,
                                password);
                        if (account == null || account.equals("")
                                || password == null || password.equals("")) {
                            Toast.makeText(getApplicationContext(),
                                    "请先输入账户或密码！", Toast.LENGTH_LONG).show();
                            closeDialog();
                            return;
                        }
                        if (!NetworkHttp.isNetworkConnected(mContext)) {
                            closeDialog();
                            return;
                        }
                        initDialog();
                        mProgress.show();
                        MyHttpRequest.onStartHttpGET(HttpUrlList.UserUrl.LOGIN,
                                params, new HttpRequestCallback() {

                                    @Override
                                    public void onPostExecute(int statusCode,
                                                              String resultStr) {
                                        // TODO Auto-generated method stub
                                        Intent intent = null;
                                        Log.i("TAG_login", resultStr.toString());
                                        UserInfo mUser = JsonUtil.getUserInfo(resultStr);
                                        if (JsonUtil.status.equals(HttpCode.serverCode.DATA_Success_CODE)) {
                                            MyApplication.setUserInfo(mUser);
                                            closeDialog();
                                            if (shoice != 404) {
                                                FuzzyInterfaceActivity.this.finish();
                                                return;
                                            }
                                            Editor edit = sp.edit();
                                            edit.putString("account", account);
                                            edit.putString("password", password);
                                            edit.commit();

                                            intent = new Intent(getApplicationContext(), AccountInfoActivity.class);
                                            startActivity(intent);
                                            FuzzyInterfaceActivity.this.finish();
                                        } else if (JsonUtil.status.equals(HttpCode.Login_Veri.LOGIN_ACC_ERROR)) {
                                            Toast.makeText(getApplicationContext(),
                                                    "账号或密码错误!", Toast.LENGTH_LONG).show();
                                        } else if (JsonUtil.status.equals( HttpCode.Login_Veri.LOGIN_ACC_SYSTEM)) {
                                            Toast.makeText(getApplicationContext(),
                                                    "抱歉系统出错！", Toast.LENGTH_LONG).show();
                                        }
                                        closeDialog();
                                    }
                                });

                    }
                });
    }

    @Override
    public void onClick(View view) {
        // TODO Auto-generated method stub
        switch (view.getId()) {
            case R.id.fastlogin_return:
                FuzzyInterfaceActivity.this.finish();
                break;

            default:
                break;
        }
    }

}
