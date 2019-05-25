package com.sun3d.why.controller.china;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import com.alibaba.fastjson.JSON;
import com.culturecloud.enumeration.common.IntegralTypeEnum;
import com.sun3d.why.dao.UserIntegralDetailMapper;
import com.sun3d.why.dao.UserIntegralMapper;
import com.sun3d.why.model.CmsActivityOrder;
import com.sun3d.why.model.CmsComment;
import com.sun3d.why.model.CmsTerminalUser;
import com.sun3d.why.model.UserIntegral;
import com.sun3d.why.model.UserIntegralDetail;
import com.sun3d.why.service.CmsTerminalUserService;
import com.sun3d.why.service.UserIntegralDetailService;
import com.sun3d.why.service.UserIntegralService;
import com.sun3d.why.util.Constant;
import com.sun3d.why.util.JSONResponse;
import com.sun3d.why.util.PaginationApp;
import com.sun3d.why.util.UUIDUtils;
import com.sun3d.why.webservice.service.TerminalUserAppService;

@RequestMapping("/chinaTerminalUser")
@Controller
public class TerminalUserController {
	private Logger logger = LoggerFactory.getLogger(TerminalUserController.class);
	@Autowired
    private UserIntegralDetailService userIntegralDetailService;
	@Autowired
    private CmsTerminalUserService terminalUserService;
	@Autowired
	private HttpSession session;

	/**
     * 添加用户(json字符串)
     * @param json
     * @return
	 * @throws IOException 
     */
    @RequestMapping(value = "/insertTerminalUserByJson", method = RequestMethod.POST)
    public String insertTerminalUserByJson(HttpServletResponse response,@RequestBody String jsonUser) throws IOException{
    	CmsTerminalUser terminalUser = JSON.parseObject(jsonUser, CmsTerminalUser.class);//把data数据解析成对象
    	int result = 0;
		try {
			if (terminalUser != null) {
				// 查讯手机是否已经注册
		        Map<String, Object> param = new HashMap<String, Object>();
		        param.put("userMobileNo", terminalUser.getUserMobileNo());
		        List<CmsTerminalUser> extList = terminalUserService.getCmsTerminalUserList(param);
		        if (!CollectionUtils.isEmpty(extList)&&!Constant.USER_NOT_ACTIVATE.equals(extList.get(0).getUserIsDisable())) {
		        	result = -2;
		        }else{
		        	result = terminalUserService.insertTerminalUser(terminalUser);
		        	if(result == 1){
		        		userIntegralDetailService.registerAddIntegral(terminalUser.getUserId());
		        	}
		        }
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		response.getWriter().print(Integer.toString(result));
		response.getWriter().flush();
		response.getWriter().close();
		return null;
    }
    
    /**
     * 修改用户(json字符串)
     * @param json
     * @return
	 * @throws IOException 
     */
    @RequestMapping(value = "/updateTerminalUserByJson", method = RequestMethod.POST)
    public String updateTerminalUserByJson(HttpServletResponse response,@RequestBody String jsonUser) throws IOException{
    	int result = 0;
		try {
			CmsTerminalUser terminalUser = JSON.parseObject(jsonUser, CmsTerminalUser.class);//把data数据解析成对象
			result = 0;
			try {
				if (terminalUser != null) {
					result = terminalUserService.updateTerminalUserById(terminalUser);
				}
			} catch (Exception e) {
				e.printStackTrace();
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		response.getWriter().print(Integer.toString(result));
		response.getWriter().flush();
		response.getWriter().close();
		return null;
    }
}
