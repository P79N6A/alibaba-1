package com.sun3d.ticketGdfs.http;

/**
 * HTTPurl请求列表
 *
 * @author yangyoutao
 */
public class HttpUrlList {
    /**
     * 正式环境IP:http://115.28.254.204
     */
    /**
     * 192.168.1.103:6080/whjd(丹青)
     * 测试环境IP：http://192.168.5.115:8081/whjd/
     */
//	private static final String IP = "http://192.168.5.115:8081/whjd";
//    private static final String IP = "http://192.168.5.46";
//    	private static final String IP = "http://www.whjd.sh.cn";
//    	private static final String IP = "http://103.25.64.84/pt-ticket";//测试
//    	private static final String IP = "http://139.196.6.197:9085/pt-ticket";//普陀
//    private static final String IP = "http://xc.bj.wenhuayun.cn";//北京西城
    private static final String IP = "http://fspre.gd.wenhuayun.cn";//广东佛山 测试
//    private static final String IP = "http://wh.fs.cn";//广东佛山 正式
    //    	private static final String IP = "http://192.168.42.30:8080/whjd";//嘉定
//    	private static final String IP = "http://192.168.42.30:8080/jd-ticket";//嘉定
//	 private static final String IP = "http://192.168.41.169:8080/whjd";
//	private static final String IP = "http://192.168.41.168:8080/whjd";
//    private static final String IP = "http://192.168.41.159:6080/whjd";
    //    public static final String HTTP_LON = "Lon";// 经度
    public static final String HTTP_LAT = "Lat";// 纬度
    // 公共参数
    public static final String HTTP_USER_ID = "userId";// 用户id
    public static final String HTTP_PAGE_NUM = "pageNum";
    public static final String HTTP_PAGE_INDEX = "pageIndex";
    public static final String HTTP_NUM = "10";

    /*
     * 所有参数
     * **/
    public static class AllParameter {

        /**
         * 活动验证码
         */
        public static final String VALIDATE_CODE = "orderValidateCode";
        //活动验证（单个座位取消）
        public static final String ACTIVITY_SEATS = "seats";
        //活动订单状态
        public static final String ACTIVITY_ORDER_PAY = "orderPayStatus";
        /**
         * 场馆验证码
         */
        public static final String VENUE_CODE = "orderValidateCode";

        //活动室订单状态
        public static final String VENUE_BOOK_STATUS = "bookStatus";
        //活动室订单ID
        public static final String VENUE_ROOM_ODERID = "roomOderId";
        public static final String VENUE_ROOM_TIME = "roomTime";
        //活动预定场次
        public static final String VENUE_ORDERIDS = "orderIds";
        public static final String NEW_VENUE_ORDERIDS = "orderValidateCode";

        //登录账户
        public static final String LOGIN_ACCOUNT = "userAccount";
        //登录密码
        public static final String LOGIN_PASSWORD = "userPassword";

    }

    /**
     * 用户url
     */
    public static class UserUrl {
        //登录
        public static final String LOGIN = IP + "/checkTicket/loginCheckSysUser.do";

    }

    /**
     * 管理员查询url
     */
    public static class SelectUrl {
        public static final String SELECT = IP + "/checkTicket/searchInfo.do";
    }


    /**
     * 场馆验证
     */
    public static class Venue {
        /**
         * 验证信息
         */
        public static final String PROVING_V = IP + "/checkTicket/orderRoomCode.do";
        /**
         * 确认验证
         */
        public static final String VERI_SUCCESS_V = IP + "/checkTicket/checkRoomCode.do";

    }

    /**
     * 活动验证
     */
    public static class ActivityProving {
        /*//验证信息
        public static final String PROVING = IP + "/userActivity/orderValidateCode.do";
		//确认验证
		public static final String VERI_SUCCESS = IP + "/userActivity/validateCode.do";*/

        //验证信息
        public static final String PROVING_INFO = IP + "/checkTicket/orderActivityCode.do";
        //单个座位验证
        public static final String ACTIVITY_SEAT = IP + "/checkTicket/activitySeatCode.do";
    }


    /**
     * 版本更新
     */
    public static class Version {
        public static final String APP_VESIONUPDATER_URL = IP + "/login/appAndroidVersion.do";
    }
}
