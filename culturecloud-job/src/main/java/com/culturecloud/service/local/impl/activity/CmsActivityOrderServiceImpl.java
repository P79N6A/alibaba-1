package com.culturecloud.service.local.impl.activity;

import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.culturecloud.dao.activity.CmsActivityOrderMapper;
import com.culturecloud.dao.dto.activity.CmsActivityOrderDto;
import com.culturecloud.model.bean.activity.CmsActivityOrder;
import com.culturecloud.service.local.activity.CmsActivityOrderService;

@Service
@Transactional
public class CmsActivityOrderServiceImpl implements CmsActivityOrderService {

    @Autowired
    private CmsActivityOrderMapper cmsActivityOrderMapper;
	
	@Override
	public List<CmsActivityOrderDto> queryTimeOutNotVerificationOrder(int dayAgo) {
	
		 // 获取几天前的日期
        Calendar calendar = Calendar.getInstance();
        calendar.setTime(new Date());
        calendar.set(Calendar.DATE, calendar.get(Calendar.DATE) - dayAgo);
        Date date = calendar.getTime();

        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");

        String strDate = sdf.format(date);

        List<CmsActivityOrderDto> cmsActivityOrderList = cmsActivityOrderMapper.queryTimeOutNotVerificationOrder(strDate);

        return cmsActivityOrderList;
	}

}
