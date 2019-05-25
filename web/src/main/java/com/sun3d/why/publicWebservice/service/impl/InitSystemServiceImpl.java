package com.sun3d.why.publicWebservice.service.impl;

import java.util.List;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.sun3d.why.dao.UserIntegralDetailMapper;
import com.sun3d.why.publicWebservice.service.InitSystemService;
import com.sun3d.why.service.UserIntegralDetailService;

@Service
public class InitSystemServiceImpl implements InitSystemService {
	
	private Logger logger = Logger.getLogger(this.getClass());

	@Autowired
	private UserIntegralDetailMapper userIntegralDetailMapper;
	
	@Autowired
	private UserIntegralDetailService userIntegralDetailService;

	/* (non-Javadoc)
	 * @see com.sun3d.why.publicWebservice.service.InitSystemService#initAllRegisterIntegral()
	 */
	@Override
	public int initAllRegisterIntegral() {
		
		int result=0;
		
		try {
			
			List<String> userId=userIntegralDetailMapper.queryNoRegisterUser();
			
			for (String id : userId) {
				result=userIntegralDetailService.registerAddIntegral(id);
			}
			
		} catch (Exception e) {
			logger.error("插入初始化注册数据错误", e);
			
			result=0;
		}
		
		return result;
	}
	
}
