package com.sun3d.ticketGdfs.activity;

import android.annotation.SuppressLint;
import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.content.res.Resources;
import android.os.Bundle;
import android.util.Log;
import android.view.KeyEvent;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;
import android.widget.TextView;
import android.widget.Toast;

import com.sun3d.ticketGdfs.MyApplication;
import com.sun3d.ticketGdfs.R;
import com.sun3d.ticketGdfs.Util.Constants;
import com.sun3d.ticketGdfs.Util.Constants.CODE_STATE;
import com.sun3d.ticketGdfs.view.FastBlur;

public class MainActivity extends Activity implements OnClickListener {
    private final static int SCANNIN_GREQUEST_CODE = 1;

    private String TAG = "MainActivity";
    private RelativeLayout mTitleLeft = null;
    private TextView mHeaderCampaign = null;
    private TextView mHeaderVenue = null;
    private View line1;
    private View line2;
    private ImageView title_right;
    private long mExitTime;

    private LinearLayout mQrCode = null;
    private LinearLayout mInputCode = null;

    private Context mContext = null;

    private LinearLayout contentLayout;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        MyApplication.addActivitys(this);
        this.mContext = this;

        initView();
    }

    private void initView() {
        // TODO Auto-generated method stub

        RelativeLayout mTitle = (RelativeLayout) findViewById(R.id.main_title);
        TextView mTitleText = (TextView) mTitle
                .findViewById(R.id.title_content);
        mTitleLeft = (RelativeLayout) mTitle
                .findViewById(R.id.title_left_layout);
        title_right = (ImageView) findViewById(R.id.title_right);
        title_right.setVisibility(View.VISIBLE);
        title_right.setImageResource(R.drawable.icon_select);
        mTitleText.setText(R.string.main_title_content);

        mHeaderCampaign = (TextView) findViewById(R.id.header_campaign);
        mHeaderVenue = (TextView) findViewById(R.id.header_venue);

        line1 = (View)findViewById(R.id.line1);
        line2 = (View)findViewById(R.id.line2);

        mQrCode = (LinearLayout) findViewById(R.id.main_scan_qr_code);
        mInputCode = (LinearLayout) findViewById(R.id.main_scan_input_code);

        setVeriType(MyApplication.mVerificationType);
        mQrCode.setOnClickListener(this);
        mInputCode.setOnClickListener(this);
        mHeaderVenue.setOnClickListener(this);
        mHeaderCampaign.setOnClickListener(this);
        mTitleLeft.setOnClickListener(this);
        title_right.setOnClickListener(this);

    }

    @Override
    public void onClick(View view) {
        // TODO Auto-generated method stub
        Intent intent = null;
        switch (view.getId()) {
            case R.id.title_left_layout:// 登录
                if (MyApplication.getUserInfo() == null) {
                    intent = new Intent(getApplicationContext(),
                            FuzzyInterfaceActivity.class);
                    FastBlur.getScreen((Activity) mContext);
                    intent.putExtra(Constants.INTENT_TRANSFER.CHOICE,
                            Constants.INTENT_TRANSFER.INTENT_MAIN);
                } else {
                    intent = new Intent(getApplicationContext(),
                            AccountInfoActivity.class);
                }
                startActivity(intent);
                break;
            case R.id.main_scan_qr_code:// 扫描验证码
                if (MyApplication.getUserInfo() == null) {
                    intent = new Intent(getApplicationContext(),
                            FuzzyInterfaceActivity.class);
                    FastBlur.getScreen((Activity) mContext);
                    intent.putExtra(Constants.INTENT_TRANSFER.CHOICE,
                            Constants.INTENT_TRANSFER.INTENT_MAIN);
                    intent.putExtra(Constants.INTENT_TRANSFER.CHOICE_LOGIN,
                            Constants.INTENT_TRANSFER.INTENT_TESTING_S);
                    startActivityForResult(intent,
                            Constants.INTENT_TRANSFER.INTENT_TESTING_S);
                    return;
                }
                intent = new Intent();
                intent.setClass(MainActivity.this, SQRActivity.class);
                intent.setFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP);
                startActivityForResult(intent, SCANNIN_GREQUEST_CODE);
                break;
            case R.id.main_scan_input_code:// 输入验证码
                if (MyApplication.getUserInfo() == null) {
                    intent = new Intent(getApplicationContext(),
                            FuzzyInterfaceActivity.class);
                    FastBlur.getScreen((Activity) mContext);
                    intent.putExtra(Constants.INTENT_TRANSFER.CHOICE,
                            Constants.INTENT_TRANSFER.INTENT_MAIN);
                    intent.putExtra(Constants.INTENT_TRANSFER.CHOICE_LOGIN,
                            Constants.INTENT_TRANSFER.INTENT_TESTING_I);
                    startActivityForResult(intent,
                            Constants.INTENT_TRANSFER.INTENT_TESTING_I);
                    return;
                }
                intent = new Intent(getApplicationContext(),
                        InputCodeActivity.class);
                startActivity(intent);
                break;
            case R.id.header_campaign:// 活动验证
                setVeriType(CODE_STATE.ACTIVITY_VERIFICATION);
                break;
            case R.id.header_venue:// 场馆验证
                setVeriType(CODE_STATE.VENUE_VERIFICATION);
                break;
            case R.id.title_right://点击查询
//                if (MyApplication.getUserInfo() == null) {
//                    intent = new Intent(getApplicationContext(),
//                            FuzzyInterfaceActivity.class);
//                    FastBlur.getScreen((Activity) mContext);
//                    intent.putExtra(Constants.INTENT_TRANSFER.CHOICE,
//                            Constants.INTENT_TRANSFER.INTENT_MAIN);
//                    intent.putExtra(Constants.INTENT_TRANSFER.CHOICE_LOGIN,
//                            Constants.INTENT_TRANSFER.INTENT_TESTING_I);
//                    startActivityForResult(intent,
//                            Constants.INTENT_TRANSFER.INTENT_TESTING_I);
//                    return;
//                }
                intent = new Intent(getApplicationContext(),
                        SelectInputCodeActivity.class);
                startActivity(intent);
                break;
            default:
                break;
        }
    }

    @SuppressLint({"ResourceAsColor", "NewApi"})
    private void setVeriType(int type) {

        Resources resources = getBaseContext().getResources();
        MyApplication.mVerificationType = type;
        if (type == CODE_STATE.ACTIVITY_VERIFICATION) {
            line1.setVisibility(View.VISIBLE);
            line2.setVisibility(View.GONE);
        } else if (type == CODE_STATE.VENUE_VERIFICATION) {
            line1.setVisibility(View.GONE);
            line2.setVisibility(View.VISIBLE);
        }

    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        // TODO Auto-generated method stub
        super.onActivityResult(requestCode, resultCode, data);
        Intent intent = null;

        switch (requestCode) {
            case SCANNIN_GREQUEST_CODE:
                if (resultCode == RESULT_OK) {
                    Bundle bundle = data.getExtras();
                    intent = new Intent(MainActivity.this, InputCodeActivity.class);
                    intent.putExtra("ticketCode", bundle.getString("result"));
                    Log.i(TAG, bundle.getString("result"));
                    startActivity(intent);
                }
                break;
            case Constants.INTENT_TRANSFER.INTENT_TESTING_S:
                if (MyApplication.loginUserInfo != null) {
                    intent = new Intent();
                    intent.setClass(MainActivity.this, SQRActivity.class);
                    intent.setFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP);
                    startActivityForResult(intent, SCANNIN_GREQUEST_CODE);
                }
                break;
            case Constants.INTENT_TRANSFER.INTENT_TESTING_I:
                if (MyApplication.loginUserInfo != null) {
                    intent = new Intent(MainActivity.this, InputCodeActivity.class);
                }
                break;
        }
    }

    @Override
    public boolean onKeyDown(int keyCode, KeyEvent event) {
        // TODO Auto-generated method stub
        if (keyCode == KeyEvent.KEYCODE_BACK) {
            if ((System.currentTimeMillis() - mExitTime) > 2000) {
                Toast.makeText(this, "再按一次退出程序", Toast.LENGTH_SHORT).show();
                mExitTime = System.currentTimeMillis();

            } else {
                MyApplication.getInstance().exit();
            }
            return true;
        }

        return super.onKeyDown(keyCode, event);
    }

}
