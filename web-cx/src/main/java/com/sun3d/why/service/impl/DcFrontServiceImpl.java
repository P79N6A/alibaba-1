package com.sun3d.why.service.impl;

import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpSession;

import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.sun3d.why.dao.DcFrontUserMapper;
import com.sun3d.why.model.DcFrontUser;
import com.sun3d.why.service.DcFrontService;
import com.sun3d.why.util.Constant;
import com.sun3d.why.util.Pagination;

@Service
@Transactional
public class DcFrontServiceImpl implements DcFrontService {
	@Resource
	private DcFrontUserMapper dcFrontUserMapper;

	@Override
	public String login(DcFrontUser user, HttpSession session) {

		try {

			if (StringUtils.isNotBlank(user.getUserName()) && StringUtils.isNotBlank(user.getUserPwd())) {

				List<DcFrontUser> userList=dcFrontUserMapper.queryDcFrontUserByCondition(user);
				
				if(userList.size()>0){
					DcFrontUser loginUser=userList.get(0);
					
					session.setAttribute("dcUser", loginUser);
				}
				else
				{
					return Constant.RESULT_STR_DISPWD;
				}
				
				
			} else
				return Constant.RESULT_STR_DISPWD;

		} catch (Exception e) {
			return Constant.RESULT_STR_FAILURE;
		}

		return Constant.RESULT_STR_SUCCESS;
	}

	
}
