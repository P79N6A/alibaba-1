package com.sun3d.ticketGdfs.activity;

import com.sun3d.ticketGdfs.MyApplication;
import com.sun3d.ticketGdfs.R;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.ImageView;
import android.widget.RelativeLayout;
import android.widget.TextView;
import android.widget.Toast;

public class AccountInfoActivity extends Activity implements OnClickListener {
	
	private com.sun3d.ticketGdfs.entity.UserInfo mUser = null;
	
	private TextView mAccountReturn =null;
	
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		// TODO Auto-generated method stub
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_account_info);
		MyApplication.addActivitys(this);
		initDate();
		
		initView();
	}

	private void initDate() {
		// TODO Auto-generated method stub
		Intent intent =null;
		if(MyApplication.getUserInfo() == null){
			intent = new Intent(getApplicationContext(), FuzzyInterfaceActivity.class);
			Toast.makeText(getApplicationContext(), "请先登录！", Toast.LENGTH_LONG).show();
			startActivity(intent);
		}else{
			mUser = MyApplication.getUserInfo();
		}
	}

	private void initView() {
		// TODO Auto-generated method stub
		RelativeLayout mTitle = (RelativeLayout) findViewById(R.id.account_title);
		RelativeLayout mReturn = (RelativeLayout)mTitle.findViewById(R.id.title_left_layout);
		((ImageView) mTitle.findViewById(R.id.title_left)).setImageResource(R.drawable.sh_icon_return);
		((TextView)mTitle.findViewById(R.id.title_content)).setText(R.string.account_info_title);
		
		((TextView) findViewById(R.id.account_content_id)).setText(mUser.getUserNema());
		((TextView) findViewById(R.id.account_content_belonging)).setText(mUser.getBelonging());
		((TextView) findViewById(R.id.account_content_user)).setText(mUser.getFigure());
		
		mAccountReturn = (TextView) findViewById(R.id.account_return);
		
		mReturn.setOnClickListener(this);
		mAccountReturn.setOnClickListener(this);
		
	}

	@Override
	public void onClick(View view) {
		// TODO Auto-generated method stub
		Intent intent = null;
		switch (view.getId()) {
		case R.id.account_return:
			MyApplication.loginUserInfo = null;
			AccountInfoActivity.this.finish();
			intent = new Intent(getApplicationContext(), MainActivity.class);
			startActivity(intent);
			break;
		case R.id.title_left_layout:
			AccountInfoActivity.this.finish();
			break;
		default:
			break;
		}
	}

}
