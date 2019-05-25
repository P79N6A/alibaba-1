package com.sun3d.why.region.cd.service.impl;

import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Isolation;
import org.springframework.transaction.annotation.Transactional;

import com.sun3d.why.dao.region.cd.CdTrainingSignMapper;
import com.sun3d.why.model.extmodel.StaticServer;
import com.sun3d.why.region.cd.model.CdTrainingSign;
import com.sun3d.why.region.cd.service.CdTrainingSignService;
import com.sun3d.why.util.SmsUtil;
import com.sun3d.why.util.UUIDUtils;

@Service
@Transactional
public class CdTrainingSignServiceImpl implements CdTrainingSignService{
    
    @Resource
    private CdTrainingSignMapper cdTrainingSignMapper;
    @Autowired
    private HttpSession session;
    @Autowired
    private StaticServer staticServer;
    @Autowired
	private SmsUtil SmsUtil;
    @Override
	public String checkSignLimit(CdTrainingSign vo) {
    	try {
			Map<String,Object> map = new HashMap<String,Object>();
			map.put("signCourse", vo.getSignCourse());
			List<CdTrainingSign> list = cdTrainingSignMapper.queryTrainingSignList(map);
			if(list.size()>=vo.getLimitNum()){
				return "limit";
			}
		} catch (Exception e) {
			e.printStackTrace();
			return "500";
		}
		return "200";
	}
    
	@Override
	@Transactional(isolation = Isolation.SERIALIZABLE)
	public String addSign(CdTrainingSign vo) {
		Map<String,Object> map = new HashMap<String,Object>();
		map.put("signCourse", vo.getSignCourse());
		List<CdTrainingSign> list = cdTrainingSignMapper.queryTrainingSignList(map);
		if(list.size()>=vo.getLimitNum()){
			return "limit";
		}
		map = new HashMap<String,Object>();
		map.put("signIdcard", vo.getSignIdcard());
		list = cdTrainingSignMapper.queryTrainingSignList(map);
		if(list.size()>0){
			return "repeat";
		}
		
		vo.setSignId(UUIDUtils.createUUId());
		vo.setCreateTime(new Date());
		int count = cdTrainingSignMapper.insert(vo);
		if (count > 0) {
			final Map<String,Object> smsMap = new HashMap<String,Object>();
			final String mobileNo = vo.getSignMobile();
			smsMap.put("name", vo.getSignCourse());
			if(vo.getSignSmsType() == 1){
				smsMap.put("time", "2017年3月2日");
			}else if(vo.getSignSmsType() == 2){
				smsMap.put("time", "2017年3月3日");
			}
			Runnable runnable = new Runnable() {
				@Override
				public void run() {
					SmsUtil.cdTrainingSignSms(mobileNo, smsMap);
				}
			};
			Thread thread = new Thread(runnable);
			thread.start();
			return "200";
		}else{
			return "500";
		}
	}

}
