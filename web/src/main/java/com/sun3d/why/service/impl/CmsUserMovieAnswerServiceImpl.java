package com.sun3d.why.service.impl;

import java.util.Date;
import java.util.HashMap;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.sun3d.why.dao.CmsUserMovieAnswerMapper;
import com.sun3d.why.model.CmsUserMovieAnswer;
import com.sun3d.why.service.CmsUserMovieAnswerService;
import com.sun3d.why.util.EmojiFilter;
import com.sun3d.why.util.UUIDUtils;

@Service
@Transactional(rollbackFor = Exception.class)
public class CmsUserMovieAnswerServiceImpl implements CmsUserMovieAnswerService {

    private Logger logger = LoggerFactory.getLogger(CmsUserMovieAnswerServiceImpl.class);

    @Autowired
    private CmsUserMovieAnswerMapper userMovieAnswerMapper;
    
	@Override
	public String saveOrUpdateMovieAnswer(CmsUserMovieAnswer record) {
		int result = 1;
		try {
			CmsUserMovieAnswer cmsUserMovieAnswer = userMovieAnswerMapper.selectById(record.getUserId());
			if(cmsUserMovieAnswer!=null){
				if(record.getUserScore()!=null||record.getUserName()!=null||
						record.getUserMobile()!=null||record.getUserEmail()!=null){
					if(record.getUserName()!=null){
						record.setUserName(EmojiFilter.filterEmoji(record.getUserName()));
					}
					result = userMovieAnswerMapper.updateById(record);
				}
			}else{
				record.setCreateTime(new Date());
				record.setUserScore(0);
				result = userMovieAnswerMapper.insert(record);
			}
			if(result == 1){
			    return  "200";
			}else{
			    return  "500";
			}
		} catch (Exception e) {
			e.printStackTrace();
			return  "500";
		}
	}

	@Override
	public CmsUserMovieAnswer statisticsMovieAnswer(Integer userScore, String userId) {
		CmsUserMovieAnswer result = null;
    	try {
    		CmsUserMovieAnswer cmsUserMovieAnswer = new CmsUserMovieAnswer();
    		cmsUserMovieAnswer.setUserId(userId);
    		cmsUserMovieAnswer.setUserScore(userScore);
			result = userMovieAnswerMapper.statisticsMovieAnswer(cmsUserMovieAnswer);
			result.setProportion(result.getProportion()!=null?result.getProportion():0);
		} catch (Exception e) {
			e.printStackTrace();
		}
        return result;
	}

	@Override
	public CmsUserMovieAnswer queryMovieUserInfo(String userId) {
		CmsUserMovieAnswer result = null;
    	try {
			result = userMovieAnswerMapper.selectById(userId);
		} catch (Exception e) {
			e.printStackTrace();
		}
        return result;
	}

	@Override
	public String saveMovieAnswerData() {
		try {
			for(int i=0;i<10;i++){
				CmsUserMovieAnswer cmsUserMovieAnswer = new CmsUserMovieAnswer();
				cmsUserMovieAnswer.setUserId(UUIDUtils.createUUId());
				cmsUserMovieAnswer.setUserScore(0);
				cmsUserMovieAnswer.setCreateTime(new Date());
				userMovieAnswerMapper.insert(cmsUserMovieAnswer);
			}
			for(int i=0;i<50;i++){
				CmsUserMovieAnswer cmsUserMovieAnswer = new CmsUserMovieAnswer();
				cmsUserMovieAnswer.setUserId(UUIDUtils.createUUId());
				cmsUserMovieAnswer.setUserScore(1);
				cmsUserMovieAnswer.setCreateTime(new Date());
				userMovieAnswerMapper.insert(cmsUserMovieAnswer);
			}
			for(int i=0;i<80;i++){
				CmsUserMovieAnswer cmsUserMovieAnswer = new CmsUserMovieAnswer();
				cmsUserMovieAnswer.setUserId(UUIDUtils.createUUId());
				cmsUserMovieAnswer.setUserScore(2);
				cmsUserMovieAnswer.setCreateTime(new Date());
				userMovieAnswerMapper.insert(cmsUserMovieAnswer);
			}
			for(int i=0;i<120;i++){
				CmsUserMovieAnswer cmsUserMovieAnswer = new CmsUserMovieAnswer();
				cmsUserMovieAnswer.setUserId(UUIDUtils.createUUId());
				cmsUserMovieAnswer.setUserScore(3);
				cmsUserMovieAnswer.setCreateTime(new Date());
				userMovieAnswerMapper.insert(cmsUserMovieAnswer);
			}
			for(int i=0;i<150;i++){
				CmsUserMovieAnswer cmsUserMovieAnswer = new CmsUserMovieAnswer();
				cmsUserMovieAnswer.setUserId(UUIDUtils.createUUId());
				cmsUserMovieAnswer.setUserScore(4);
				cmsUserMovieAnswer.setCreateTime(new Date());
				userMovieAnswerMapper.insert(cmsUserMovieAnswer);
			}
			for(int i=0;i<190;i++){
				CmsUserMovieAnswer cmsUserMovieAnswer = new CmsUserMovieAnswer();
				cmsUserMovieAnswer.setUserId(UUIDUtils.createUUId());
				cmsUserMovieAnswer.setUserScore(5);
				cmsUserMovieAnswer.setCreateTime(new Date());
				userMovieAnswerMapper.insert(cmsUserMovieAnswer);
			}
			for(int i=0;i<150;i++){
				CmsUserMovieAnswer cmsUserMovieAnswer = new CmsUserMovieAnswer();
				cmsUserMovieAnswer.setUserId(UUIDUtils.createUUId());
				cmsUserMovieAnswer.setUserScore(6);
				cmsUserMovieAnswer.setCreateTime(new Date());
				userMovieAnswerMapper.insert(cmsUserMovieAnswer);
			}
			for(int i=0;i<120;i++){
				CmsUserMovieAnswer cmsUserMovieAnswer = new CmsUserMovieAnswer();
				cmsUserMovieAnswer.setUserId(UUIDUtils.createUUId());
				cmsUserMovieAnswer.setUserScore(7);
				cmsUserMovieAnswer.setCreateTime(new Date());
				userMovieAnswerMapper.insert(cmsUserMovieAnswer);
			}
			for(int i=0;i<70;i++){
				CmsUserMovieAnswer cmsUserMovieAnswer = new CmsUserMovieAnswer();
				cmsUserMovieAnswer.setUserId(UUIDUtils.createUUId());
				cmsUserMovieAnswer.setUserScore(8);
				cmsUserMovieAnswer.setCreateTime(new Date());
				userMovieAnswerMapper.insert(cmsUserMovieAnswer);
			}
			for(int i=0;i<50;i++){
				CmsUserMovieAnswer cmsUserMovieAnswer = new CmsUserMovieAnswer();
				cmsUserMovieAnswer.setUserId(UUIDUtils.createUUId());
				cmsUserMovieAnswer.setUserScore(9);
				cmsUserMovieAnswer.setCreateTime(new Date());
				userMovieAnswerMapper.insert(cmsUserMovieAnswer);
			}
			for(int i=0;i<10;i++){
				CmsUserMovieAnswer cmsUserMovieAnswer = new CmsUserMovieAnswer();
				cmsUserMovieAnswer.setUserId(UUIDUtils.createUUId());
				cmsUserMovieAnswer.setUserScore(10);
				cmsUserMovieAnswer.setCreateTime(new Date());
				userMovieAnswerMapper.insert(cmsUserMovieAnswer);
			}
		} catch (Exception e) {
			e.printStackTrace();
			return "500";
		}
		return "200";
	}
}
