package com.sun3d.why.service.impl;

import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.sun3d.why.dao.CmsSuperOrderUserMapper;
import com.sun3d.why.model.CmsSuperOrderUser;
import com.sun3d.why.service.CmsSuperOrderUserService;
import com.sun3d.why.util.Constant;
import com.sun3d.why.util.JSONResponse;
import com.sun3d.why.util.SmsUtil;

@Service
@Transactional
public class CmsSuperOrderUserServiceImpl implements CmsSuperOrderUserService {

	private Logger logger = Logger.getLogger(CmsSuperOrderUserServiceImpl.class);
    @Autowired
    private CmsSuperOrderUserMapper cmsSuperOrderUserMapper;
    @Autowired
    private HttpSession session;
    @Autowired
	private SmsUtil SmsUtil;
	@Override
	public CmsSuperOrderUser querySuperOrderUserByUserMobileNo(String userMobileNo) {
        return cmsSuperOrderUserMapper.querySuperOrderUserByUserMobileNo(userMobileNo);
	}

	@Override
	public String sendCode(CmsSuperOrderUser cmsSuperOrderUser, String userMobileNo) {
		String code = SmsUtil.getValidateCode();
    	
		cmsSuperOrderUser.setLoginCode(code);
    	
    	int flag=cmsSuperOrderUserMapper.update(cmsSuperOrderUser);
    	
    	Map<String,Object> smsParams = new HashMap<>();
        smsParams.put("code",code);
        smsParams.put("product",Constant.PRODUCT);
        SmsUtil.sendActivityCode(userMobileNo, smsParams);
        
        if (flag > 0) {
            return JSONResponse.toAppResultFormat(200, code);
        }else {
            return JSONResponse.toAppResultFormat(500, "短信验证码失败");
        }
	}

}
