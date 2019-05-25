package com.sun3d.why.webservice.api.util;

public class CmsApiStatusConstant {
	public static final int ERROR=10000;//未知错误
	public static final int SUCCESS = 20000;//成功
	public static final int SYSNO_ERROR=10001;//系统编号不能为空;
	public static final int TOKEN_ERROR=10002;//token错误，可能密钥不对,或者时间过期
	public static final int USER_ERROR=10003;//用户名错误，用户不存在,或者系统没有权限
	public static final int DATA_ERROR = 10004;//数据为空
	

	public static final int VENUE_ERROR=10005;//场所已经存在
	public static final int ACTIVITY_ERROR=10006;//活动已经存在
	public static final int ANTIQUE_ERROR=10007;//馆藏已经存在
	public static final int ACTIVITYROOM_ERROR=10008;//活动室已经
	
	public static final int VENUE_ERROR_NULL=10005;//场所不存在
	public static final int ACTIVITY_ERROR_NULL=10006;//活动不存在
	public static final int ANTIQUE_ERROR_NULL=10007;//馆藏不存在
	public static final int ACTIVITYROOM_ERROR_NULL=10008;//活动室不存在
	
	
	public static final int ATT_MAX_SIZE=1024*1024*2;
	public static final int IMG_SMALL_SIZE=750;
	//public static final int VENUE_ERROR=10006;//
	//public static final int VENUE_ERROR=10006;//
	
	

}
