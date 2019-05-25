package com.sun3d.ticketGdfs.http;


public class HttpCode {
    /**
     * 接口请求失败
     */
    public static final int HTTP_Request_Failure_CODE = 0;
    /**
     * 接口请求成功
     */
    public static final int HTTP_Request_Success_CODE = 1;

    public static final int HTTP_RequestType_Post = 2;

    public static final int HTTP_RequestType_Get = 3;

    public static class serverCode {
        /**
         * 数据返回成功
         */
        public static final String DATA_Success_CODE = "0";

    }

    public static class ServerCode_Veri {
        /**
         * 活动座位验证
         */
        public static final int ACTIVITY_SEAT_VARI = 101;
        /**
         * 活动取票码缺失
         */
        public static final int VERI_CODE_Defect = 14112;
        /**
         * 活动取票码有误
         * (或该座位验票成功)
         */
        public static final int VERI_CODE_Error = 14113;
        /**
         * 活动验证（座位验证）
         * 验证成功（进入场地）
         */
        public static final int VERI_SEAT_CODE = 14114;
        /**
         * 该座位验票成功
         */
        public static final int VERI_SEAT_SUCCESS = 14113;

    }

    public static class Login_Veri {
        /**
         * 账号或密码错误
         */
        public static final String LOGIN_ACC_ERROR = "RESULT_USER_ERROR_CODE_10003";
        /**
         * 系统错误
         */
        public static final String LOGIN_ACC_SYSTEM = "RESULT_ERROR_CODE_99999";
    }

}
