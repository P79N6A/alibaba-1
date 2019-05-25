package com.sun3d.ticketGdfs;

import java.util.LinkedList;
import java.util.List;

import android.app.Activity;
import android.app.Application;
import android.content.Context;
import android.content.pm.ActivityInfo;
import android.os.Handler;

import com.nostra13.universalimageloader.core.ImageLoader;
import com.nostra13.universalimageloader.core.ImageLoaderConfiguration;
import com.sun3d.ticketGdfs.Util.Constants;
import com.sun3d.ticketGdfs.Util.WindowsUtil;
import com.sun3d.ticketGdfs.entity.UserInfo;

public class MyApplication extends Application {
	private static int windowHeight;
	private static Context mContext;
	private static int windowWidth;
	private static MyApplication instance;
	private static List<Activity> activitys;
	private Handler mReserveHandler;
	private Handler mRoomHandler;
	private static Handler mMainHandler;
	private static Handler mUserHandler;
	public static final int HANDLER_USER_CODE = 101;// ���շ���֪ͨ
	public static UserInfo loginUserInfo = null;
	// private SearchListInfo searchListInfo;
	// public AMapLocation MyLocation;
	private ImageLoader mImageLoader;
	public static Boolean UserIsLogin = false;
	//判断点击的是否查询（查询：1，默认为：0）
	public static int isSelectActivity = 0;

	// 验证类型
	public static int mVerificationType = Constants.CODE_STATE.ACTIVITY_VERIFICATION;
	static int ii = 0;
	@Override
	public void onCreate() {
		// TODO Auto-generated method stub
		super.onCreate();
		mContext = getApplicationContext();
		init();

	}

	public MyApplication() {
		activitys = new LinkedList<Activity>();
	}
	
	public static synchronized MyApplication context() {
		return (MyApplication) mContext;
	}

	private void init() {
		windowHeight = WindowsUtil.getwindowsHight(mContext);
		windowWidth = WindowsUtil.getWindowsWidth(mContext);
		mImageLoader = ImageLoader.getInstance();
		mImageLoader.init(ImageLoaderConfiguration.createDefault(mContext));
	}

	public static MyApplication getInstance() {
		if (instance == null) {
			instance = new MyApplication();
		}
		return instance;
	}

	public static void addActivitys(Activity activity) {
		if (activity != null) {
			activity.setRequestedOrientation(ActivityInfo.SCREEN_ORIENTATION_PORTRAIT);
			activitys.add(activity);
		}
	}

	/**
	 * 退出APP
	 */
	public void exit() {
		if (activitys != null && activitys.size() > 0) {
			for (Activity activity : activitys) {
				activity.finish();
			}
		}
		System.exit(0);
	}

	/**
	 * �˳�activity�Ĳ���
	 * */
	public void exitLayer(int number) {
		if (activitys != null && number <= activitys.size()) {
			for (int i = number - 1; i >= (activitys.size() - number); i--) {
				activitys.get(i).finish();
				activitys.remove(i);
			}
		}
	}

	public ImageLoader getImageLoader() {
		return ImageLoader.getInstance();
	}

	public static void setUserInfo(UserInfo mUser){
		loginUserInfo = mUser;
	}
	
	public static UserInfo getUserInfo(){
		return loginUserInfo;
	}

	public static Context getContext() {
		return mContext;
	}

	public static int getWindowHeight() {
		return windowHeight;
	}

	public static int getWindowWidth() {
		return windowWidth;
	}

	public Handler getmReserveHandler() {
		return mReserveHandler;
	}

	public void setmReserveHandler(Handler mReserveHandler) {
		this.mReserveHandler = mReserveHandler;
	}

	public Handler getmRoomHandler() {
		return mRoomHandler;
	}

	public void setmRoomHandler(Handler mRoomHandler) {
		this.mRoomHandler = mRoomHandler;
	}

	public static Handler getmMainHandler() {
		return mMainHandler;
	}

	public static void setmMainHandler(Handler mMainHandler) {
		MyApplication.mMainHandler = mMainHandler;
	}

	public static Handler getmUserHandler() {
		return mUserHandler;
	}

	public static void setmUserHandler(Handler mUserHandler) {
		MyApplication.mUserHandler = mUserHandler;
	}

}
