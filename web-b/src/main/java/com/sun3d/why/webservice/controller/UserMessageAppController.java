package com.sun3d.why.webservice.controller;
import com.sun3d.why.util.JSONResponse;
import com.sun3d.why.webservice.service.UserMessageAppService;
import org.apache.commons.lang3.StringUtils;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import javax.servlet.http.HttpServletResponse;
/**
 * 手机app接口 获取用户消息
 * Created by Administrator on 2015/7/8
 *
 */
@RequestMapping("/appUserMessage")
@Controller
public class UserMessageAppController {
    private Logger logger = Logger.getLogger(UserMessageAppController.class);
    @Autowired
    private UserMessageAppService userMessageAppService;

    /**
     * app获取用户信息
     * @param userId    用户id
     * @return json 10111:用户id不存在
     */
    @RequestMapping(value = "/userAppMessage")
    public String userAppMessage( HttpServletResponse response,String userId) throws Exception {
        String json="";
            if (StringUtils.isNotBlank (userId) && userId!=null) {
                json=userMessageAppService.queryUserMessageById(userId);
            } else {
                json=JSONResponse.commonResultFormat(10111,"用户id缺失!",null);
            }
        response.setContentType("text/html;charset=UTF-8");
        response.getWriter().write(json);
        response.getWriter().flush();
        response.getWriter().close();
        return null;
    }

    /**
     * app删除用户消息
     * @param userMessageId 消息id
     * @return
     */
    @RequestMapping(value = "/delAppMessage")
    public String deleteAppUserMessage(HttpServletResponse response,String userMessageId) throws Exception {
          String json="";
       try {
          if(StringUtils.isNotBlank(userMessageId) && userMessageId!=null){
              json=userMessageAppService.deleteUserMessageById(userMessageId);
          }else {
              json=JSONResponse.commonResultFormat(14145,"用户消息id缺失!",null);
          }
          }catch (Exception e){
              logger.info("系统出错!");
          }
        response.setContentType("text/html;charset=UTF-8");
        response.getWriter().write(json);
        response.getWriter().flush();
        response.getWriter().close();
        return null;
    }

}