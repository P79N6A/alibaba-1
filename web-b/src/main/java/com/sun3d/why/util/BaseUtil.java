package com.sun3d.why.util;

import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class BaseUtil {
	public static String getMainMenu() {  

		   StringBuffer buffer = new StringBuffer();  
		   
//		   buffer.append("您好，亲！欢迎关注洗护管家"+
//                              "洗护管家是苏州管到家网络科技有限公司下设的一个子品牌"+
//                              "洗护管家第一季为您带来一个公开、透明、快速、便捷和高品质的在线洗护"+
//                          "平台。亲们可以通过我们的微信公众号，400电话进行预约。我们的个人管家"+
//                          "会在最短的时间内上门服务。"+
//						      "要洗护，找管家。我们秉承着“卓越洗护，用心服务”的理念。"+
//						      "预约电话:400-9699-210"+
//						      "客服时间：上午9:00至晚上9:00"+
//						      "亲！我们开始约吧！").append("\n\n");
		   
           buffer.append("您好，亲！欢迎关注文化云").append("\n");

//		   buffer.append("1  百度搜索").append("\n");  
//
//		   buffer.append("2  最新活动").append("\n");  
//
//		   buffer.append("3  课程查询").append("\n");  
//
//		   buffer.append("4  成绩查询").append("\n\n");  
//
//		   buffer.append("回复“?”显示此帮助菜单");  

		   return buffer.toString();  

		}  
	/** 

	 * 判断是否是QQ表情 

	 */  
	
	public static boolean isQqFace(String content) {  

	    boolean result = false;  

	  

	    // 判断QQ表情的正则表达式  

	    String qqfaceRegex = "/::\\)|/::~|/::B|/::\\||/:8-\\)|/::<|/::$|/::X|/::Z|/::'\\(|/::-\\||/::@|/::P|/::D|/::O|/::\\(|/::\\+|/:--b|/::Q|/::T|/:,@P|/:,@-D|/::d|/:,@o|/::g|/:\\|-\\)|/::!|/::L|/::>|/::,@|/:,@f|/::-S|/:\\?|/:,@x|/:,@@|/::8|/:,@!|/:!!!|/:xx|/:bye|/:wipe|/:dig|/:handclap|/:&-\\(|/:B-\\)|/:<@|/:@>|/::-O|/:>-\\||/:P-\\(|/::'\\||/:X-\\)|/::\\*|/:@x|/:8\\*|/:pd|/:<W>|/:beer|/:basketb|/:oo|/:coffee|/:eat|/:pig|/:rose|/:fade|/:showlove|/:heart|/:break|/:cake|/:li|/:bome|/:kn|/:footb|/:ladybug|/:shit|/:moon|/:sun|/:gift|/:hug|/:strong|/:weak|/:share|/:v|/:@\\)|/:jj|/:@@|/:bad|/:lvu|/:no|/:ok|/:love|/:<L>|/:jump|/:shake|/:<O>|/:circle|/:kotow|/:turn|/:skip|/:oY|/:#-0|/:hiphot|/:kiss|/:<&|/:&>";  

	    Pattern p = Pattern.compile(qqfaceRegex);  

	    Matcher m = p.matcher(content);  

	    if (m.matches()) {  

	        result = true;  

	    }  

	    return result;  

	}
}
