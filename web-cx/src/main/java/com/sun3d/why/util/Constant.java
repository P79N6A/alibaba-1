package com.sun3d.why.util;

import java.util.regex.Pattern;

public class Constant {
	/**
     * 待审核
     */
    public final static Integer EXAMINE = 0;

    /**
     * 正常状态（审核通过）
     */
    public final static Integer NORMAL = 1;

    /**
     * 删除状态
     */
    public final static Integer DELETE = 2;

    /**
     * 审核不通过
     */
    public final static Integer PULL = 3;

    /**
     * 状态 1-草稿
     */
    public final static Integer DRAFT = 1;

    /**
     * 状态 2-已审核
     */
    public final static Integer APPROVE = 2;

    /**
     * 状态 3-审核中
     */
    public final static Integer APPROVING = 3;

    /**
     * 状态 4-退回
     */
    public final static Integer REVERT = 4;
    /**
     * 状态 5-回收站
     */
    public final static Integer TRASH = 5;

    /**
     * 状态 6-发布
     */
    public final static Integer PUBLISH = 6;

    /**
     * 状态 7-推荐
     */
    public final static Integer RECOMMEND = 7;

    /**
     * 状态 99-无效状态
     */
    public final static Integer UNUSED = 99;
    /**
     * 场馆类型
     */
    public final static Integer TYPE_VENUE = 1;
    /**
     * 活动
     */
    public final static Integer TYPE_ACTIVITY = 2;
    /**
     * 藏品
     */
    public final static Integer TYPE_ANTIQUE = 3;
    /**
     * 专题活动(城市名片、我在现场)
     */
    public final static Integer TYPE_SUBJECT = 4;
    /**
     * 会员
     */
    public final static Integer TYPE_USER = 5;
    /**
     * 团体
     */
    public final static Integer TYPE_TEAM_USER = 6;
    /**
     * 活动室
     */
    public final static Integer TYPE_ACTIVITY_ROOM = 7;
    /**
     * 非遗
     */
    public final static Integer TYPE_CULTURE = 8;
    /**
     * 广场通知
     */
    public final static Integer TYPE_CULTURE_SQUARE = 9;

    /**
     * 收藏对象类型  场馆-1
     */
    public final static Integer COLLECT_VENUE = 1;
    /**
     * 收藏对象类型  活动-2
     */
    public final static Integer COLLECT_ACTIVITY = 2;
    /**
     * 收藏对象类型  藏品-3
     */
    public final static Integer COLLECT_ANTIQUE = 3;
    /**
     * 收藏对象类型  团体-4
     */
    public final static Integer COLLECT_TEAMUSER = 4;
    /**
     * 收藏对象类型 非遗-5
     */
    public  final  static  Integer COLLECT_CULTURE=5;
    /**
     * 返回字符串-success 成功
     */
    public final static String RESULT_STR_SUCCESS = "success";
    /**
     * 返回字符串-failure 失败
     */
    public final static String RESULT_STR_FAILURE = "failure";


    /**
     * 返回字符串-repeat 重复
     */
    public final static String RESULT_STR_REPEAT = "repeat";

    /**
     * 返回字符串-mobileRepeat 手机重复
     */
    public final static String RESULT_STR_MOBILE_REPEAT = "mobileRepeat";

    /**
     * 返回字符串-cardNoRepeat 身份证重复
     */
    public final static String RESULT_STR_CARD_NO_REPEAT = "cardNoRepeat";

    /**
     * 返回字符串-disPwd 密码不一致
     */
    public final static String RESULT_STR_DISPWD = "disPwd";

    /**
     * 返回字符串-noActive
     */
    public final static String RESULT_STR_FREEZE = "isFreeze";

    /**
     * 返回字符串-noActive
     */
    public final static String RESULT_STR_NOACTIVE = "noActive";


    /**
     * 返回字符串-exceedNumber 超过次数
     */
    public final static String RESULT_STR_EXCEED_NUMBER = "exceedNumber";

    /**
     * 返回团体申请审核状态 审核中-1
     */
    public final static Integer APPLY_CHECK_ING = 1;

    /**
     * 返回团体申请审核状态 未通过-2
     */
    public final static Integer APPLY_NOT_PASS = 2;

    /**
     * 返回团体申请审核状态 已通过-3
     */
    public final static Integer APPLY_ALREADY_PASS = 3;

    /**
     * 返回团体申请审核状态 已退出-4
     */
    public final static Integer APPLY_ALREADY_QUIT = 4;
    /**
     * app之前参加的团体除已通过状态
     */

    /**
     * 图片类型
     * param Img 图片格式
     * Video 视频格式
     * Audio  音频格式
     * ATTACH  文件附件  word exl
     */
    public static final String IMG = "Img";
    public static final String FILE = "File";
    public static final String VIDEO = "Video";
    public static final String AUDIO = "Audio";
    public static final String  ATTACH = "Attach";
    public static final String IMG_LOCAL = "local";
    /**
     * 游客与会员状态  1.游客  2.会员
     */
    public final static Integer STATUS1 = 1;

    public final static Integer STATIS2 = 2;
    /**
     * 是否登陆成功 1-成功
     */
    public final static Integer LOGIN_SUCCESS = 1;

    /**
     * 是否登陆成功 0-失败
     */
    public final static Integer LOGIN_ERROR = 0;

    private String base_path_window;

    /**
     * 登录方式 1-app 2-网页
     */
    public final static Integer LOGIN_TYPE_APP=1;
    public final static Integer LOGIN_TYPE2=2;

    /**
     *用户等级 1-普通用户 2-管理员用户 3-待认证 4-认证不通过
     */
    public final static Integer USER_TYPE1=1;
    public final static Integer USER_TYPE2=2;
    public final static Integer USER_TYPE3=3;
    public final static Integer USER_TYPE4=4;

    /**
     * 标签类型编码
     */
    public final static String TAG_TYPE = "TAG_TYPE";


    /**
     * 标签类型名称 活动
     */
    public final static String ACTIVITY_NAME = "活动";

    /**
     * 标签类型名称 场所
     */
    public final static String VENUE_NAME = "场馆";
    /**
     * 标签类型名称 馆藏
     */
    public final static String ANTIQUE_NAME = "馆藏";

    /**
     * 标签类型名称 团体
     */
    public final static String TEAM_NAME = "团体";

    public final static String COLUMN_NAME = "场馆";


    /**
     * 场所类型编码
     */
    public final static String VENUE_TYPE = "VENUE_TYPE";
    public final static String VENUE_CROWD = "VENUE_CROWD";
    public final static String ROOM_TAG = "ROOM_TAG";

    public  final static String NEWS_TAG = "新闻标签";

    /**
     * 新闻类型
     */
    public  final static String NEWS_TYPE = "NEWS_TYPE";
    /**
     * 新闻类型-年俗文化展示
     */
    public  final static String YEAR_CUSTOM_CULTURE_SHOW = "YEAR_CUSTOM_CULTURE_SHOW";
    /**
     * 新闻类型-访谈
     */
    public  final static String INTERVIEWS = "INTERVIEWS";
    /**
     * 新闻类型-主题报道
     */
    public  final static String THEME_REPORT = "THEME_REPORT";

    /**
     * 个人show类型
     */
    public  final static String PERSONAL_SHOW_TYPE = "PERSONAL_SHOW_TYPE";

    /**
     * 个人show类型-团团圆圆照相馆
     */
    public  final static String REUNION_PHOTO_HOUSE = "REUNION_PHOTO_HOUSE";

    /**
     * 个人show类型-剪纸与上海“闲话
     */
    public  final static String CUT_PAPER_AND_GOSSIP = "CUT_PAPER_AND_GOSSIP";

    /**
     * 非遗类型编码
     */
    public  final  static  String CULTURE_YEAR="CULTUREYEAR";
    public final  static  String  CULTURE_SYSTEM="CULTURESYSTEM";
    public  final  static  String CULTURE_TYPE="CULTURETYPE";
    /**
     * 反馈类型编码
     */
    public final static  String FEED_BACK_TYPE="FEEDBACKTYPE";
    /**
     * 转编码功工具
     *
     */

    /**
     * 用户是否冻结-冻结
     */
    public final static Integer USER_IS_FREEZE = 2;

    /**
     * 用户是否激活-已激活
     */
    public final static Integer USER_IS_ACTIVATE = 1;

    /**
     * 用户是否激活-未激活
     */
    public final static Integer USER_NOT_ACTIVATE = 0;

    /**
     * 当前端用户没有登录时，默认为游客，对应数据库中默认存在的一条游客记录
     */
    public final static String DEFAULT_SESSION_USER_NAME = "游客";


    public final static String fileURLEmpty = "文件路径为空!";


    /**
     * 返回字符串活动名称重复
     */
    public final static String ACTIVITY_NAME_REPEAT = "活动名称重复!";



    public final static String USER_ID_PREFIX = "why_";


    /**
     * 场馆座位状态-正常
     */
    public final static Integer VENUE_SEAT_STATUS_NORMAL = 1;

    /**
     * 场馆座位状态-占用
     */
    public final static Integer VENUE_SEAT_STATUS_MAINTANANCE = 2;

    /**
     * 场馆座位状态-不存在
     */
    public final static Integer VENUE_SEAT_STATUS_NONE = 3;

    /**
     * 场馆座位状态-VIP
     */
    public final static Integer VENUE_SEAT_STATUS_VIP = 4;

    public static final int MAX_ORDER_SUFFIX = 1000000;

    public static final int MAX_USER_SUFFIX = 1000000;


    /**
     * 时间类型进行统计
     */
    public final static String Week_TaskJob = "week";
    public final static String Month_TaskJob = "month";
    public final static String OneQuarter_TaskJob = "oneQuarter";
    public final static String TwoQuarter_TaskJob = "twoQuarter";
    public final static String ThirdQuarter_TaskJob = "thirdQuarter";
    public final static String FourQuarter_TaskJob = "fourQuarter";
    public final static String Year_TaskJob = "year";

    /**
     * 按统计类型来进行统计
     * 统计类型 1：场馆 2：活动 3：藏品 4.团体 5.非遗
     */
    public final static Integer type1 = 1;
    public final static Integer type2 = 2;
    public final static Integer type3 = 3;
    public final static Integer type4 = 4;
    public final static Integer type5=5;
    /**
     * 查询朝代与类型code数据
     *朝代 藏品类型
     */
    public final static String DYNASTY="DYNASTY";
    public  final static String ANTIQUE="ANTIQUE";

    /**
     * 消息类型
     * 目标用户
     */
    public static final String MESSAGE_TYPE = "MESSAGE_TYPE";
    public static final String MESSAGE_TARGET_USER = "MESSAGE_TARGET_USER";

    public static final String MobileCode = "MobileCode";

    public static final String MobileCodeErr = "短信验证码验证失败";
    public static final String SmsCodeErr = "SmsCodeErr";

	/**
	 * 验证码
	 */
	public final static String CAPTCHA = "captcha";
	/**
	 * 发送系统消息类型
	 * SendMessageType
	 */
    //发送消息
	public static final String SYSTEM_NOTICE="系统通知";
    public static final String SYSTEM_NOTICE_REFUSEUSER_ACTIVITY="会员活动审核未通过系统通知";
	public static final String Register_Success="注册成功";

    //后台添加用户短信
    public static final String ADD_TERMINAL_USER_MESSAGE="后台添加用户短信";

    //手机注册成功短信
    public static final String MOBILE_REGISTER_SMS="手机注册成功短信";
    /**
     * 活动短信
     */
    public static final String ACTIVITY_ORDER_SMS="活动预定成功短信";
    public static final String ACTIVITY_ORDER_FREE_SMS="活动订票成功自由入座";
    public static final String ACTIVITY_CANCEL_ORDER="取消免费活动订单短信";
    /**
     * 场馆短信
     */
    public static final String VENUE_ORDER_SMS="场馆预订成功短信";
    public static final String VENUE_CANCEL_ORDER="取消预订场馆";



    /**
     * 团体  消息
     */
    public static final String TEAM_JOIN_FAIL="团体加入失败";
    public static final String TEAM_QUIT="退出团体";
    public static final String TEAM_JOIN_APPLY="申请加入团体";


    public static final String TEAM_JOIN_SUC_SMS="团体加入成功短信";
    public static final String TEAM_JOIN_FAIL_SMS="团体加入失败短信";



	/*************** SendMessageType******************/

    public static final String AutoLogin="AutoLogin";

    /**
     * 前台Session user
     */
    public static final String terminalUser="terminalUser";


    /**
     * 轮播图
     */
    public static final String advertPos_app = "App首页轮播图";
    public static final String advertPos_app_1 = "近期活动广告位";

    public static final String advertPos_45 = "上海市轮播图";
    public static final String advertPos_46 = "黄浦区轮播图";
    public static final String advertPos_48 = "徐汇区轮播图";
    public static final String advertPos_50 = "静安区轮播图";
    public static final String advertPos_49 = "长宁区轮播图";
    public static final String advertPos_51 = "普陀区轮播图";
    public static final String advertPos_52 = "闸北区轮播图";
    public static final String advertPos_53 = "虹口区轮播图";
    public static final String advertPos_54 = "杨浦区轮播图";
    public static final String advertPos_55 = "闵行区轮播图";
    public static final String advertPos_56 = "宝山区轮播图";
    public static final String advertPos_57 = "嘉定区轮播图";
    public static final String advertPos_58 = "浦东新区轮播图";
    public static final String advertPos_59 = "金山区轮播图";
    public static final String advertPos_60 = "松江区轮播图";
    public static final String advertPos_61 = "青浦区轮播图";

    public static final String advertPos_63 = "奉贤区轮播图";
    public static final String advertPos_64 = "崇明县轮播图";

    public static final String ADVERT_NOT_INSERT = "ADVERT_NOT_INSERT";
    public static final String ADVERT_HAVE_POSITION = "ADVERT_HAVE_POSITION";
    public static final String AdvertSizeWidth = "123";
    public static final String AdvertSizeHeight = "345";
    public static final Integer AdvertType = 1;
    public static final Integer AdvertState = 1;
    public static final Integer AdvertConnectTarget = 1;

    public static final String advertDefaultPos = "45";

    /**
     * 标签维护
     */
    /**
     * 活动标签
     */
    public static final String ACTIVITY_CROWD="ACTIVITY_CROWD";
    public static final String ACTIVITY_MOOD="ACTIVITY_MOOD";
    public static final String ACTIVITY_THEME="ACTIVITY_THEME";
    public static final String ACTIVITY_TYPE="ACTIVITY_TYPE";
    /**
     * 团体标签
     */
    public static final String TEAMUSER_PROPERTY="TEAMUSER_PROPERTY";
    public static final String TEAMUSER_SITE="TEAMUSER_SITE";
    public static final String TEAMUSER_CROWD="TEAMUSER_CROWD";
    /**
     * type文件类型  admin后台文件类型  from 前台文件类型
     */
    public static final String type_admin="admin";
    public static final String type_front="front";
    /**
     * 是否是推荐标签 0不推荐 1 推荐
     */

    public static final Integer  IS_RECOMMEND_TAG=1;
    public static final Integer  NO_RECOMMEND_TAG=0;
    /**
     * app中查无此人
     */
    public static final String Forgive="Forgive";

    /**
     * 用户评论状态 0-禁止
     */
    public final static Integer DISABLE_TERMINAL_USER_COMMENT = 2;

    /**
     * 用户评论状态 1-正常
     */
    public final static Integer NO_DISABLE_TERMINAL_USER_COMMENT = 1;

    /**
     * 内容平台统计 1-场馆
     */
    public static final Integer CONTENT_STATISTIC_VENUE = 1;

    /**
     * 内容平台统计 2-活动室
     */
    public static final Integer CONTENT_STATISTIC_ROOM = 2;

    /**
     * 内容平台统计 3-藏品
     */
    public static final Integer CONTENT_STATISTIC_ANTIQUE = 3;

    /**
     * app活动室购买须知用语
     */
    public  static  final String roomInformation="使用说明：本平台场馆活动室仅向团体用户开放;预订成功后，使用当天请准时入场;如需退订，请提前办理取消预订手续;活动室数量有限，取消预订后再次预订可能遇到已被他人预订的情况而导致预订失败，由用户自行负责;如累计超过2次预订活动室却没有到场使用者，将取消该团体本年度购票资格。如遇重大原因导致活动室临时变更开放时间或取消开放，场馆负责人有义务以短信或站内信的方式告知场馆预订团体，最终解释权归场馆管理方。" ;
    /**
     * app活动购买须知
     */
    public  static  final String activityInformation="使用说明：如预订在线选座活动，且当日有儿童同行，请预订儿童票；订票成功后，活动开始当日请提前入场，避免拥堵；如需退票，请在活动开始前办理相关手续；每场活动票数有限，退票后再次预订可能遇到票已售完，无法订票的情况，由用户自行负责；如累计超过2次订票却没有到场参加活动者，将取消本年度购票资格。如遇非人为可控因素或重大天气等影响，导致活动无法举办，举办方有权利延后或取消活动，并以短信和站内信形式告知订票人办理相关手续。活动最终解释权归举办方。" ;
    /**
     * app产品介绍
     */
    public  static  final  String productInfornation="文化云（wenhuayun.cn）是一款基于政府公共文化资源而提供在线预约、预订服务的平台。用户可以注册登录本平台，通过手机端app和电脑端网站浏览文化活动、文化场馆、文化团体资讯，进行在线预订活动票务，在线申请加入团体，团体在线预订场馆活动室等操作，并可以进行网上评论、个人信息、个人爱好管理等。徜徉在文化的海洋，探知非遗文化带来的历史痕迹，总有惊喜和感动；海量免费的文化活动，不管您是甜蜜情侣还是三口之家，又或者是父母亲情，总有适合您的一款；另外还有众多优质场馆，多种文化团体，丰富您的文化生活。上海文化云平台，洞悉上海的一扇窗。";


    /**
     * 网页判断敏感词定义
     */
    public  static  final String SensitiveWords_EXIST="sensitiveWordsExist";
    public  static  final String SensitiveWords_NOT_EXIST="sensitiveWordsNotExist";
    public static final Integer RECOMMENT_ACTIVITY = 1;

    public static final String advertConnectUrl="http://115.28.254.204/";


    //首页热点推荐 存放在内存中的key
    public static final String RecommendActivityList = "recommendActivityList";

    //首页最新活动 存放在内存中的key
    public static final String FrontNewestActivity = "frontNewestActivity";

    /**
     * 订单发送短信 1-未发送
     */
    public static final Integer ORDER_NOT_SEND_SMS = 1;

    /**
     * 订单发送短信 2-发送成功
     */
    public static final Integer ORDER_SEND_SMS_SUCCESS = 2;

    /**
     * 订单发送短信 3-发送失败
     */
    public static final Integer ORDER_SEND_SMS_FAILURE = 3;

    /**
     * 评论置顶-未置顶
     */
    public final static Integer COMMENT_TOP_FALSE = 0;

    /**
     * 评论置顶-已置顶
     */
    public final static Integer COMMENT_TOP_TRUE = 1;

    //跳转首页url
    public final static String IndexPage ="redirect:/frontIndex/index.do";


    //活动订单 支付状态
    //订单是否支付状态(1-未出票 2-已取消 3-已出票 4-已验票 5-已失效 )
    public final static short ACTIVITY_ORDER_PAY_STATUS_UNBILLED = 1;
    public final static short ACTIVITY_ORDER_PAY_STATUS_CANCELLED = 2;
    public final static short ACTIVITY_ORDER_PAY_STATUS_TAKED = 3;
    public final static short ACTIVITY_ORDER_PAY_STATUS_CHECKED = 4;
    public final static short ACTIVITY_ORDER_PAY_STATUS_EXPIRED = 5;


    /**场馆推荐状态：1-没有推荐*/
    public final static Integer RECOMMEND_NO = 1;
    /**场馆推荐状态：2-推荐*/
    public final static Integer RECOMMEND_YES = 2;

   //注册来源 1 文化云，2 QQ  3 新浪微博 4 微信
   public final static  Integer REGISTER_ORIGIN_WHY=1;
    /**
     * 用户活动统计 操作类型:1.浏览次数 2.被赞次数 3.收藏次数4.分享次数
     */
    public final static Integer OPERATE_TYPE_BROWSE=1;
    public final static Integer OPERATE_TYPE_PRAISE=2;
    public final static Integer OPERATE_TYPE_COLLECT=3;
    public final static Integer OPERATE_TYPE_SHARE=4;
    /**
     * app中活动与展馆分享url请求
     */
    public  static  final  String commentActivityUrl="wechatActivity/preActivityDetail.do?";
    public  static  final  String commentVenueUrl="wechatVenue/venueDetailIndex.do?";
    /**
     * 正则表达式：验证手机号
     */
    public static final String REGEX_MOBILE = "^((13[0-9])|(14[0-9])|(15[0-9])|(17([0-9]))|(18[0-9]))\\d{8}$";
    /**
     * 校验手机号
     * @param userMobileNo 手机号码
     * @return 校验通过返回true，否则返回false
     */
    public static boolean isMobile(String userMobileNo) {
        return Pattern.matches(REGEX_MOBILE, userMobileNo);
    }
    /**
     * 场馆首页缓存的KEY值前缀
     */
    public static final String VENUE_INDEX_REDIS_PREFIX = "VENUE_INDEX_";

    /**
     * 场馆首页缓存的列表(第一页)--上海市
     */
    public static final String VENUE_INDEX_REDIS_DEFAULT = VENUE_INDEX_REDIS_PREFIX + "SH";

    /**
     * 场馆首页缓存的总数(所有)--上海市
     */
    public static final String VENUE_INDEX_DEFAULT_TOTAL = VENUE_INDEX_REDIS_PREFIX + "SH_TOTAL";

    /**
     * 用户团体级别 1.管理员 2.团体用户
     */
    public static final Integer APPLY_IS_STATE_ADMIN=1;
    public static final Integer APPLY_IS_STATE=2;
    /**
     * 取票机验证活动票的状态 1(预定) 2:已取消预定 3-已出票 4-已验票 5-已失效
     */
    public  static final  Integer ORDER_PAY_STATUS1=1;
    public static final Integer  ORDER_PAY_STATUS3 = 3;
    public  static  final  Short ORDER_STATUS3=3;
    public static  final  Integer ORDER_SEAT_STATUS4=4;
    public static final short  ORDER_PAY_STATUS4 =4;

    /**
     * app活动室验证票的状态 1 已预订,2 已取消,3 已入场 4 已删除 5 已出票 6 已失效
     */
    public static final Integer BOOK_STATUS1 = 1;
    public static final Integer BOOK_STATUS4 = 4;
    public  static final Integer BOOK_STATUS3=3;
    public static final Integer BOOK_STATUS5= 5;
    /**
     * app首页主题标签推荐活动列表
     */
    public  static final String FREE_ACTIVITY="免费看演出";
    public static  final String  CHILDREN_ACTIVITY="孩子学艺术";
    public static  final String WHERE_ACTIVITY="周末去哪儿";

    /**
     * 场馆是否可预定 1-否
     */
    public static final Integer VENUE_NOT_RESERVE = 1;

    /**
     * 场馆是否可预定 2-是
     */
    public static final Integer VENUE_IS_RESERVE = 2;
    /**
     * 活动是否推荐 Y-是 (文化云3.1前端首页栏目)
     */
    public static final String ACTIVITY_IS_RECOMMEND = "Y";

    /**
     * 活动是否推荐 N-否 (文化云3.1前端首页栏目)
     */
    public static final String ACTIVITY_NOT_RECOMMEND = "N";
    /**
     * 取票机logo图片路径
     */
    public static  final  String TICKET_LOGO="/why/STATIC/image/logo-print.png";
    /**
     * 活动或展馆视频类型 1-活动 2-场馆 3-团体
     */
    public static  final Integer ACTIVITY_VIDEO_TYPE=1;
    public static final Integer  VENUE_VIDEO_TYPE=2;
    /**
     * 主题下视频状态 1.启用 2.删除 3.草稿
     */
   public static final  Integer VIDEO_STATE=1;
    /**
     * 活动推荐栏目类型 1-免费看演出 2-孩子学艺术 3-周末去哪儿
     */
    public static final Integer RECOMMEND_COLUMN_TYPE1=1;
    public static final Integer RECOMMEND_COLUMN_TYPE2=2;
    public static final Integer RECOMMEND_COLUMN_TYPE3=3;
    /**
     * 玩家秀-状态 1.前端用户发布 待审核 2.后台管理员审核通过 3.后台管理员审核不通过 4.已删除 SHOW_STATE
     */
    public static final Integer SHOW_STATE1=1;


    //第三方用户登录sessionUserId
    public static  final String THIRD_USER_ID="THIRD_USER_ID";
    /**
     * 用户消息状态 Y-已读 N-未读
     */
    public static final String USER_MESSAGE_STATUS="N";



/*********************** 阿里大鱼短信服务 请勿修改*********************************************/
//短信签名
public  static  final String  PRODUCT="文化云";

    //注册验证码 内容:验证码${code}，您正在注册成为${product}用户，感谢您的支持！
    public static  final String SMS_TPL_REG_CODE="SMS_140635011";

    //找回密码验证码 或 验证身份 内容：  验证码${code}，您正在进行${product}身份验证，打死不要告诉别人哦！
    public static  final String SMS_TPL_USER_CODE="SMS_140635014";

    //预订活动时验证手机号 【文化云】您的验证码为${code},请在页面中输入以完成验证，如有疑问，请致电4000-018-2346。
    public static  final String SMS_ACTIVITY_CODE="SMS_140635013";

    //修改个人信息验证码  内容：验证码${code}，您正在尝试变更${product}重要信息，请妥善保管账户信息
    public static  final String SMS_TPL_UPDATE_CODE="SMS_140635009";

    //后台添加用户
    public static  final String SMS_USER_INFO_CODE="SMS_157350353";

    //【文化云】亲爱的${userName}，您已成功预订【${activityName}】活动的${ticketCount}张票，时间为${time},请凭验证码${ticketCode}入场，如需退票，请提前取消订单。
    public static  final String SMS_ACTIVITY_ORDER_CODE="SMS_36090002";
    //【文化云】亲爱的${username}，您已成功预订${activityName}活动的${num}张票，时间为${time}，请凭取票码${yzcode}在指定时间至指定地点文化云自助取票机取票，凭纸质票务入场。一经出票，该订单不可退改。
    public static  final String SMS_ACTIVITY_ORDER_CODE2="SMS_157345004";
    //【文化云】亲爱的${username}，您已成功预订${activityName}活动的${num}张票，时间为${time}，请凭取票码${yzcode}提前至指定取票地换取入场凭证后入场，凭证一经换取不可取消订单。
    public static  final String SMS_ACTIVITY_ORDER_CODE3="SMS_157335136";

    //亲爱的${username}，您已成功预订上海国际艺术节之艺术天空${date}${activityName}的${ticket}张票,请您在演出开始前凭[取票码]${getCode}至指定取票地址领取实体票务，取票时间与地点因场次不同有所不同，请点击这里了解：http://t.cn/RcryQNC
    public static  final String SMS_ACTIVITY_ORDER_ARTSKY_CODE="SMS_16685264";

    //活动通知
    public static  final String SMS_ACTIVITY_NOTICE_CODE="SMS_157355403";

    //场馆订单
    public static  final String SMS_VENUE_ORDER_CODE="SMS_157350349";
    public static  final String SMS_CANCEL_VENUE_ORDER_CODE="SMS_157335137";

    //活动取消通知 【文化云】尊敬的用户：因${content}，活动取消，给您带来不便，敬请谅解！
    public static  final String SMS_CANCEL_ACTIVITY_CODE="SMS_157335138";
    // 活动取消通知已下单的用户 SMS_12140508
    // 新内容：【文化云】亲爱的${userName}，您预订的${activityName}活动${num}张票，时间为${time}，因系统升级，
    // 原有座位已被取消，为您安排了新的座位${site1},请凭验证码${ticketNum}于活动开场前取票入场，
    // 如需退票，请提前取消订单。！
    public static  final String SMS_CHANGE_ACTIVITY_CODE="SMS_12140508";

    //活动订单取消 自由入座 SMS_11875073  【文化云】亲爱的${userName}，您预定的【${activityName}】活动的${ticketCount}张票已成功退订。
    public static  final String SMS_CANCEL_ACTIVITY_FREE_ORDER_CODE="SMS_157350407";

    //活动订单取消 在线选座 SMS_11930070 【文化云】亲爱的${userName}，您预定的【${activityName}】活动的座位(${seatInfo})已成功退订。
    public static  final String SMS_CANCEL_ACTIVITY_SEAT_ORDER_CODE="SMS_157335141";

    //票务未核销的通知 【文化云】通知：亲爱的${userName}，很抱歉的通知您，您预订的X月X日的X活动的X张票，在活动开始后未到场核销，按相关规定，您将被扣除XX积分。文化云致力于为公众提供免费公益的文化活动，因票务十分抢手，希望预约过的朋友们都能如约到场喔！
    public static  final String SMS_DEDUCTION_ORDER_CODE="SMS_157350513";

    //场次审核通过的通知 【文化云】亲爱的${userName}，您预订的XXX场馆-XXX活动室-【YYYY年YY月YY日，XX:00-XX:00】的场次，已经审核通过，请凭验票码${ticketCode}或扫描二维码入场。如需退票，请提前取消订单。
    public static  final String SMS_PASS_ROOM_ORDER_CODE="SMS_157335142";

    //场次审核拒绝的通知(手动) 【文化云】亲爱的${userName}，您预订的XXX场馆-XXX活动室-【YYYY年YY月YY日，XX:00-XX:00】的场次，审核未通过，原因为“自定义内容”，如有疑问，请致电4000-018-2346。
    public static  final String SMS_MAN_CANCEL_ROOM_ORDER_CODE="SMS_157350420";

    //场次审核拒绝的通知(自动) 【文化云】亲爱的${userName}，您预订的XXX场馆-XXX活动室-【YYYY年YY月YY日，XX:00-XX:00】的场次，已经被抢订。更多免费优质场地，请登录文化云。
    public static  final String SMS_AUTO_CANCEL_ROOM_ORDER_CODE="SMS_157355419";

    //取消场馆订单【文化云】亲爱的${userName}，您预订的XXX场馆-XXX活动室-【YYYY年YY月YY日，XX:00-XX:00】的场次已成功退订。
    public static  final String SMS_CANCEL_ROOM_ORDER_CODE="SMS_157350427";

    //实名认证通过的通知【文化云】亲爱的${userName}，您提交的实名认证申请已经通过审核。您可以进入“我的空间-实名认证”进行查询，更多免费公益活动，请登录文化云。
    public static  final String SMS_PASS_REAL_NAME_CODE="SMS_157345007";

    //实名认证拒绝的通知【文化云】亲爱的${userName}，很抱歉的通知您，您提交的实名认证申请未通过审核，原因为“自定义内容”，您可以进入“我的空间-实名认证”修改后重新提交。更多免费公益活动，请登录文化云。
    public static  final String SMS_FAIL_REAL_NAME_CODE="SMS_157350430";

    //使用者认证通过的通知【文化云】亲爱的${userName}，您提交的“使用者名称”认证申请已通过审核。您可以进入“我的空间-资质认证”修改后重新提交。更多免费优质场地，请登录文化云。
    public static  final String SMS_PASS_USER_CODE="SMS_157355423";

    //使用者认证拒绝的通知【文化云】亲爱的${userName}，很抱歉的通知您，您提交的“使用者名称”认证申请未通过审核，原因为“自定义内容”，您可以进入“我的空间-资质认证”修改后重新提交。更多免费优质场地，请登录文化云。
    public static  final String SMS_FAIL_USER_CODE="SMS_157350437";

    public static  final  String SMS_WHY_PUBLISH_CODE="SMS_6200067";

    public static  final  String SMS_WHY_PAY_ORDER_CANCAL="SMS_49055080";

    public static final String SMS_WHY_PAY_ORDER_SUCCESS="SMS_64220042";

    //尊敬的市民朋友，您已成功报名 ${name}课程，请凭此短信于${time}前往常德市文化馆一楼大厅确认报名信息。如有疑问请致电：0736—7222902 （此信息转发无效）
    public static  final  String SMS_TRAINING_SIGN_CODE="SMS_49290003";

    public static  final  String SMS_INDEX_URL="wechat/index.do";


/*********************** 阿里大鱼短信服务 请勿修改*********************************************/


    //前台用户在会话中的userId
    public static  final String SESSION_USER_ID="sessionUserId";
    //忘记密码返回的随机uuid
    public static  final String SESSION_USER_CODE="sessionUserCode";


    /**********微信服务号 请勿修改*********/
    public static  final String WX_APP_ID="wx92332ac0bdb1ad30";
    public static  final String WX_APP_SECRET="d6d4d2875b10aeac235d0b20e51158a0";
    /**********微信服务号 请勿修改*********/

    /**
     * 我想去(点赞)-场馆
     */
    public final static Integer WANT_GO_VENUE = 1;

    /**
     * 我想去(点赞)-活动
     */
    public final static Integer WANT_GO_ACTIVITY = 2;

    /**
     * 我想去(点赞)-北票资讯
     */
    public final static Integer WANT_GO_BEIPIAOINFO = 20;

    /**
     * 我想去(点赞)-采编
     */
    public final static Integer WANT_GO_EDITORIAL = 3;

    /**
     * 我想去(点赞)-非遗
     */
    public final static Integer WANT_GO_HERITAGE = 4;

    /**
     * 我想去(点赞)-文物
     */
    public final static Integer WANT_GO_WENWU = 21;

    /**
     * 我想去(点赞)-商城
     */
    public final static Integer WANT_GO_PRODUCT = 22;

    public final static String RATINGS_INFO="RATINGS_INFO";

    public final static String ACTIVITY="activity";

    public final static String EDITORIAL="editorial";

    // 查看区县数据的角色名称
    public final static String COUNTY_STATISTICS_ROLE_NAME="场馆角色";

    public final static String VIEW_COUNTY_STATISTICS_ROLE_NAME="区级角色";

    public final static String SUPER_USER="超级管理员";
}

