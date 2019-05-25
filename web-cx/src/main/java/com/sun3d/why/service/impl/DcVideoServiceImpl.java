package com.sun3d.why.service.impl;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpSession;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Isolation;
import org.springframework.transaction.annotation.Transactional;

import com.culturecloud.enumeration.common.IntegralTypeEnum;
import com.culturecloud.utils.Constant;
import com.sun3d.why.dao.DcReviewMapper;
import com.sun3d.why.dao.DcScoreMapper;
import com.sun3d.why.dao.DcVideoMapper;
import com.sun3d.why.dao.DcVoteMapper;
import com.sun3d.why.dao.UserIntegralDetailMapper;
import com.sun3d.why.dao.UserIntegralMapper;
import com.sun3d.why.model.DcFrontUser;
import com.sun3d.why.model.DcReview;
import com.sun3d.why.model.DcScore;
import com.sun3d.why.model.DcVideo;
import com.sun3d.why.model.DcVote;
import com.sun3d.why.model.SysUser;
import com.sun3d.why.model.UserIntegral;
import com.sun3d.why.model.UserIntegralDetail;
import com.sun3d.why.service.DcVideoService;
import com.sun3d.why.service.UserIntegralService;
import com.sun3d.why.util.Pagination;
import com.sun3d.why.util.UUIDUtils;

@Service
@Transactional
public class DcVideoServiceImpl implements DcVideoService{
    @Resource
    private DcVideoMapper dcVideoMapper;
    @Resource
    private DcReviewMapper dcReviewMapper;
    @Resource
    private DcScoreMapper dcScoreMapper;
    @Resource
    private DcVoteMapper dcVoteMapper;
    @Autowired
    private HttpSession session;
    @Autowired
	private UserIntegralDetailMapper userIntegralDetailMapper;
    @Autowired
	private UserIntegralService userIntegralService;
    @Autowired
	private UserIntegralMapper userIntegralMapper;

	@Override
	public List<DcVideo> queryDcVideoByCondition(DcVideo dcVideo,Pagination page) {
		Map<String, Object> map = new HashMap<String, Object>();
		if(dcVideo!=null){
			if (StringUtils.isNotBlank(dcVideo.getUserId())) {
	            map.put("userId", dcVideo.getUserId());
	        }
			if(dcVideo.getReviewType()!=null)
			if(dcVideo.getReviewType()==2 || dcVideo.getReviewType()==4){
				SysUser sysUser = (SysUser) session.getAttribute("user");
				if(sysUser!=null){
					map.put("videoReviewUser", sysUser.getUserId());
				}else{
					return null;
				}
			}
			if (StringUtils.isNotBlank(dcVideo.getVideoId())) {
				map.put("videoId", dcVideo.getVideoId());
			}
			if (StringUtils.isNotBlank(dcVideo.getUserArea())) {
				map.put("userArea", dcVideo.getUserArea());
			}
			if (StringUtils.isNotBlank(dcVideo.getVideoType())) {
	            map.put("videoType", dcVideo.getVideoType());
	        }
			if (dcVideo.getVideoStatus()!=null) {
	            map.put("videoStatus", dcVideo.getVideoStatus());
	        }
			if (dcVideo.getSearchType()!=null) {
	            map.put("searchType", dcVideo.getSearchType());
	        }
			if (StringUtils.isNotBlank(dcVideo.getSearchKey())) {
	            map.put("searchKey", "%" + dcVideo.getSearchKey() + "%");
	        }
			if (dcVideo.getReviewType()!=null) {
	            map.put("reviewType", dcVideo.getReviewType());
	        }
	
	        //分页
	        if (page != null && page.getFirstResult() != null && page.getRows() != null) {
	            map.put("firstResult", page.getFirstResult());
	            map.put("rows", page.getRows());
	            int total = dcVideoMapper.queryDcVideoByCount(map);
		        //设置分页的总条数来获取总页数
		        page.setTotal(total);
	        }
	        return dcVideoMapper.queryDcVideoByContent(map);
		}
        return null;
	}

	@Override
	@Transactional(isolation = Isolation.SERIALIZABLE)
	public String editDcVideo(DcVideo dcVideo) {
		if(dcVideo.getReviewType()==1){
    		dcVideo.setVideoTreviewTime(new Date());
    	}else if(dcVideo.getReviewType()==2){
    		DcReview dcReview = new DcReview();
    		dcReview.setReviewId(UUIDUtils.createUUId());
    		dcReview.setUserId(dcVideo.getVideoReviewUser());
    		dcReview.setVideoId(dcVideo.getVideoId());
    		dcReview.setReviewResult(Integer.valueOf(dcVideo.getVideoReviewResult()));
    		if(dcVideo.getVideoReviewResult().equals("0")){
    			dcReview.setReviewReason(dcVideo.getVideoReviewReason());
    		}
    		dcReview.setCreateTime(new Date());
    		int count = dcReviewMapper.insert(dcReview);
    		if (count > 0) {
    			if(dcReviewMapper.queryReviewCount(dcVideo.getVideoId(),null)==4){
    				if(dcReviewMapper.queryReviewCount(dcVideo.getVideoId(),1)>=3){
    					dcVideo.setVideoStatus(5);
    				}else{
    					dcVideo.setVideoStatus(4);
    				}
    			}else{
    				if(dcReviewMapper.queryReviewCount(dcVideo.getVideoId(),1)>=3){
    					dcVideo.setVideoStatus(5);
    				}else if(dcReviewMapper.queryReviewCount(dcVideo.getVideoId(),0)>=2){
    					dcVideo.setVideoStatus(4);
    				}else{
    					return "200";
    				}
    			}
    		}else{
				return "500";
			}
    	}else if(dcVideo.getReviewType()==3){
    		dcVideo.setVideoSreviewTime(new Date());
    	}else if(dcVideo.getReviewType()==4){
    		DcScore dcScore = dcScoreMapper.queryScoreByCondition(dcVideo.getVideoReviewUser(),dcVideo.getVideoId());
    		if(dcScore!=null){
    			dcScore.setVideoScore(Integer.valueOf(dcVideo.getVideoReviewResult()));
        		dcScore.setVideoReason(dcVideo.getVideoReviewReason());
        		dcScore.setCreateTime(new Date());
        		int count = dcScoreMapper.update(dcScore);
        		if (count > 0) {
        			return "200";
        		}else{
    				return "500";
    			}
    		}else{
    			dcScore = new DcScore();
        		dcScore.setScoreId(UUIDUtils.createUUId());
        		dcScore.setUserId(dcVideo.getVideoReviewUser());
        		dcScore.setVideoId(dcVideo.getVideoId());
        		dcScore.setVideoScore(Integer.valueOf(dcVideo.getVideoReviewResult()));
        		dcScore.setVideoReason(dcVideo.getVideoReviewReason());
        		dcScore.setCreateTime(new Date());
        		int count = dcScoreMapper.insert(dcScore);
        		if (count > 0) {
        			return "200";
        		}else{
    				return "500";
    			}
    		}
    	}
		int count = dcVideoMapper.update(dcVideo);
		if (count > 0) {
		    return "200";
		}else{
			return "500";
		}
	}

	@Override
	public DcVideo queryDcVideoByVideoId(String videoId) {
		return dcVideoMapper.selectByPrimaryKey(videoId);
	}

	@Override
	public String saveDcVideo(DcVideo dcVideo, DcFrontUser loginUser) {
		
		try {
			String videoId=dcVideo.getVideoId();
			String userId=loginUser.getUserId();
			
			Map<String, Object> map = new HashMap<String, Object>();
			map.put("videoGuide", dcVideo.getVideoGuide());
			map.put("videoActivityCenter", dcVideo.getVideoActivityCenter());
			map.put("videoType", dcVideo.getVideoType());
			
			if(StringUtils.isNotBlank(videoId)){
				map.put("videoId", videoId);
			}
				
			int count=dcVideoMapper.checkDcVideo(map);
			
			if(count>0){
				return Constant.RESULT_STR_REPEAT;
			}
			
			dcVideo.setVideoStatus(1);
			
			if(StringUtils.isBlank(videoId)){
				
				dcVideo.setVideoId(UUIDUtils.createUUId());
				dcVideo.setUserId(userId);
				dcVideo.setCreateUser(userId);
				dcVideo.setCreateTime(new Date());
				
				dcVideoMapper.insert(dcVideo);
			}
			else
			{
				DcVideo video=dcVideoMapper.selectByPrimaryKey(videoId);
				
				if(video.getVideoStatus()!=null&&video.getVideoStatus()>2)
				{
					return "cantUpdate";
				}
				else
					dcVideoMapper.update(dcVideo);
				
			}
			
		} catch (Exception e) {
			return Constant.RESULT_STR_FAILURE;
		}
		
		return Constant.RESULT_STR_SUCCESS;
	}

	@Override
	public String deleteDcVideo(String videoId) {
		int result=dcVideoMapper.deleteByPrimaryKey(videoId);
		
		if(result>0)
			
			return Constant.RESULT_STR_SUCCESS;
		else
			return Constant.RESULT_STR_FAILURE;
	}

	@Override
	public Map<String, Object> queryStatisticsIndex() {
		Map<String, Object> statisticsMap = new HashMap<String, Object>();
		Map<String, Object> map = new HashMap<String, Object>();
		int total = dcVideoMapper.queryDcVideoByCount(map);
		map.put("isYesterday",1);
		int yesterdayTotal = dcVideoMapper.queryDcVideoByCount(map);
		
		String [] time = new String[]{"10-21","10-22","10-23","10-24","10-25","10-26","10-27",
                "10-28","10-29","10-30","10-31"};
		String [] area = new String[]{"46,黄浦区","48,徐汇区","49,长宁区","50,静安区","51,普陀区","53,虹口区","54,杨浦区",
                "55,闵行区","56,宝山区","57,嘉定区","58,浦东新区","59,金山区","60,松江区","61,青浦区",
                "63,奉贤区","64,崇明县"};
		List<List<String>> statisticsList = new ArrayList<List<String>>();
		
		//各区县
		for(int i=-1;i<area.length;i++){
			List<String> list = new ArrayList<String>();
			List<String> newList = new ArrayList<String>();
			if(i==-1){
				list =  dcVideoMapper.queryStatistics(null);
				newList.add("合计");
			}else{
				list =  dcVideoMapper.queryStatistics(area[i]);
				newList.add(area[i].split(",")[1]);
			}
			int num = 0;	//累计
			for(int j=0;j<time.length;j++){
				newList.add("-");
				for(int k=0;k<list.size();k++){
					if(time[j].equals(list.get(k).split(":")[0])){
						num += Integer.parseInt(list.get(k).split(":")[1]);
						newList.remove(j+1);
						newList.add(list.get(k).split(":")[1]);
					}
				}
			}
			newList.add(String.valueOf(num));
			statisticsList.add(newList);
		}
		
		statisticsMap.put("total", total);
		statisticsMap.put("yesterdayTotal", yesterdayTotal);
		statisticsMap.put("statisticsList", statisticsList);
		return statisticsMap;
	}

	@Override
	public List<DcVideo> queryWcDcVideoByCondition(DcVideo dcVideo) {
		return dcVideoMapper.queryWcDcVideoByContent(dcVideo);
	}

	/**
	 * 投票
	 */
	@Override
	/*@Transactional(isolation=Isolation.SERIALIZABLE)*/
	public String saveDcVote(DcVote vo) {
		int todayVoteCount = dcVoteMapper.queryTodayVoteCount(vo);
		if(todayVoteCount>0){
			return "repeat";
		}
		
		//添加积分
		UserIntegral userIntegral=userIntegralService.selectUserIntegralByUserId(vo.getUserId());
		if(userIntegral==null){
			return "500";
		}
		Map<String,Object> data = new HashMap<String,Object>();
		data.put("integralType", IntegralTypeEnum.DC_VIDEO.getIndex());
		data.put("integralFrom", "春华秋实市民通道首次投票获积分");
		data.put("integralId", userIntegral.getIntegralId());
		List<UserIntegralDetail> detailList=userIntegralDetailMapper.queryUserIntegralDetail(data);
		if(detailList.size()==0){	//第一次投票
			int result = this.updateUserNowIntegral(userIntegral, 100);
			if(result>0){
				UserIntegralDetail userIntegralDetail = new UserIntegralDetail();
				userIntegralDetail.setIntegralDetailId(UUIDUtils.createUUId());
				userIntegralDetail.setCreateTime(new Date());
				userIntegralDetail.setIntegralId(userIntegral.getIntegralId());
				userIntegralDetail.setIntegralChange(100);
				userIntegralDetail.setChangeType(0);
				userIntegralDetail.setIntegralFrom("春华秋实市民通道首次投票获积分");
				userIntegralDetail.setIntegralType(IntegralTypeEnum.DC_VIDEO.getIndex());
				userIntegralDetailMapper.insertSelective(userIntegralDetail);
			}
		}else{
			int result = this.updateUserNowIntegral(userIntegral, 1);
			if(result>0){
				UserIntegralDetail userIntegralDetail = new UserIntegralDetail();
				userIntegralDetail.setIntegralDetailId(UUIDUtils.createUUId());
				userIntegralDetail.setCreateTime(new Date());
				userIntegralDetail.setIntegralId(userIntegral.getIntegralId());
				userIntegralDetail.setIntegralChange(1);
				userIntegralDetail.setChangeType(0);
				userIntegralDetail.setIntegralFrom("春华秋实市民通道投票获积分");
				userIntegralDetail.setIntegralType(IntegralTypeEnum.DC_VOTE.getIndex());
				userIntegralDetailMapper.insertSelective(userIntegralDetail);
			}
		}
		
		vo.setVoteId(UUIDUtils.createUUId());
		vo.setCreateTime(new Date());
		int count = dcVoteMapper.insert(vo);
		if (count > 0) {
			if(detailList.size()==0){	//第一次投票
				return "100";
			}else{
				return "200";
			}
		}else{
			return "500";
		}
	}
	
	private int updateUserNowIntegral(UserIntegral userIntegral,int integralChange){
		Integer integralNow=userIntegral.getIntegralNow();
		Integer integralHis=userIntegral.getIntegralHis();
		integralNow+=integralChange;
		userIntegral.setIntegralNow(integralNow);
		if(integralChange>0){
			integralHis+=integralChange;
			userIntegral.setIntegralHis(integralHis);
		}
		return userIntegralMapper.updateByPrimaryKeySelective(userIntegral);
	}

	@Override
	public String scoreDcVideo() {
		DcVideo vo = new DcVideo();
		try {
			List<DcVideo> list = dcVideoMapper.queryWcDcVideoByContent(vo);
			for(int i=0;i<list.size();i++){
				//专家评分
				List <DcScore> sl = dcScoreMapper.queryScoreListByCondition(new DcScore(null,list.get(i).getVideoId()));
				Double score = (double) 0;
				for(int j=0;j<sl.size();j++){
					score += sl.get(j).getVideoScore();
				}
				
				//大众投票
				Double maxVoteCount = (double) dcVideoMapper.queryWcDcVideoByContent(new DcVideo(null,7)).get(0).getVoteCount();
				Double voteCount = (double) dcVideoMapper.queryWcDcVideoByContent(new DcVideo(list.get(i).getVideoId(),null)).get(0).getVoteCount();
				
				DcVideo dto = new DcVideo();
				dto.setVideoId(list.get(i).getVideoId());
				BigDecimal expertScore = new BigDecimal(score/3);
				dto.setVideoExpertScore(Double.toString(expertScore.setScale(2,BigDecimal.ROUND_HALF_UP).doubleValue()));
				BigDecimal publicScore = new BigDecimal(voteCount/maxVoteCount*100);
				dto.setVideoPublicScore(Double.toString(publicScore.setScale(2,BigDecimal.ROUND_HALF_UP).doubleValue()));
				BigDecimal totalScore = new BigDecimal(score/3*80/100+voteCount/maxVoteCount*20);
				dto.setVideoTotalScore(Double.toString(totalScore.setScale(2,BigDecimal.ROUND_HALF_UP).doubleValue()));
				dcVideoMapper.update(dto);
			}
		} catch (Exception e) {
			e.printStackTrace();
			return "500";
		}
		return "200";
	}

}
