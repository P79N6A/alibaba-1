package com.sun3d.why.service.impl;

import java.util.List;
import java.util.Random;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.sun3d.why.dao.WechatPrizeMapper;
import com.sun3d.why.model.WechatPrize;
import com.sun3d.why.service.WechatPrizeService;
@Service
@Transactional
public class WechatPrizeServiceImpl implements WechatPrizeService {
	
    private Logger logger = LoggerFactory.getLogger(WechatPrizeServiceImpl.class);
    
    @Autowired
    private WechatPrizeMapper wechatPrizeMapper;

	@Override
	public int wechatPrizeByOpenId(String openId) {
		WechatPrize vo = new WechatPrize();
		vo.setOpenId(openId);
		List<WechatPrize> list = wechatPrizeMapper.selectWechatPrizeByCondition(vo);
		if(list.size()>0){
			return 0;
		}else{
			Random ra = new Random();
			int r = ra.nextInt(10)+1;
		}
		return 0;
	}
    
    
}
