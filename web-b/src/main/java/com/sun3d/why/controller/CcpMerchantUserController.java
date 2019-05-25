package com.sun3d.why.controller;

import java.util.List;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.sun3d.why.model.ccp.CcpMerchantUser;
import com.sun3d.why.service.CcpMerchantUserService;
import com.sun3d.why.util.Pagination;

@RequestMapping("/onlineRegister")
@Controller
public class CcpMerchantUserController {

	@Autowired
	private CcpMerchantUserService ccpMerchantUserService;

	@Autowired
	private HttpSession session;

	@RequestMapping("/merchantUserIndex")
	public ModelAndView merchantUserIndex(CcpMerchantUser ccpMerchantUser, Pagination page) {
		ModelAndView model = new ModelAndView();
		List<CcpMerchantUser> list = ccpMerchantUserService.queryMerchantUserByCondition(ccpMerchantUser, page);
		model.addObject("list", list);
		model.addObject("page", page);
		model.addObject("entity", ccpMerchantUser);
		model.setViewName("admin/onlineRegister/merchantUserIndex");
		return model;
	}

	/**
     * 激活用户
     * @param request
     * @return
     */
    @RequestMapping(value = "/saveSysUser")
    @ResponseBody
    public String saveSysUser(String merchantUserId) {
    	return ccpMerchantUserService.saveSysUser(merchantUserId);
    }
}
