package com.culturecloud.service.local.impl.association;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Service;

import com.culturecloud.dao.activity.CmsActivityMapper;
import com.culturecloud.dao.association.CcpAssociationFlowerMapper;
import com.culturecloud.dao.association.CcpAssociationMapper;
import com.culturecloud.dao.common.CmsTagMapper;
import com.culturecloud.dao.common.CmsTagSubMapper;
import com.culturecloud.dao.dto.activity.CmsActivityDto;
import com.culturecloud.dao.dto.assonciation.CcpAssociationDto;
import com.culturecloud.dao.dto.common.CmsTagSubDto;
import com.culturecloud.model.bean.association.CcpAssociationFlower;
import com.culturecloud.model.request.association.AssociationByRecruitListVO;
import com.culturecloud.model.response.activity.CmsActivityVO;
import com.culturecloud.model.response.association.CcpAssociationDetailVO;
import com.culturecloud.model.response.association.CcpAssociationVO;
import com.culturecloud.model.response.common.CmsTagSubVO;
import com.culturecloud.service.local.association.CcpAssociationService;

@Service
public class CcpAssociationServiceImpl implements CcpAssociationService{

	@Resource
	private CcpAssociationMapper ccpAssociationMapper;

	@Resource
	private CcpAssociationFlowerMapper ccpAssociationFlowerMapper;

	@Resource
	private CmsActivityMapper cmsActivityMapper;

	@Resource
	private CmsTagMapper cmsTagMapper;

	@Resource
	private CmsTagSubMapper cmsTagSubMapper;

	/* (non-Javadoc)
	 * @see com.culturecloud.service.local.association.CcpAssociationService#getAllAssociation()
	 */
	@Override
	public List<CcpAssociationVO> getAllAssociation(Map<String,Object> map) {
		List<CcpAssociationDto> dtoList=ccpAssociationMapper.getAllAssociation(map);
		List<CcpAssociationVO> resultList=new ArrayList<CcpAssociationVO>();

		for (CcpAssociationDto dto : dtoList) {
			CcpAssociationVO vo=new CcpAssociationVO(dto);

			vo.setFlowerCount(dto.getFlowerCount());
			vo.setActivityCount(dto.getActivityCount());
			resultList.add(vo);
		}
		return resultList;
	}

	@Override
	public List<CcpAssociationVO> getAllAssociationPc(Map<String,Object> map) {
		List<CcpAssociationDto> dtoList=ccpAssociationMapper.getAllAssociationPc(map);
		List<CcpAssociationVO> resultList=new ArrayList<CcpAssociationVO>();

		for (CcpAssociationDto dto : dtoList) {
			CcpAssociationVO vo=new CcpAssociationVO(dto);

			vo.setFlowerCount(dto.getFlowerCount());
			vo.setActivityCount(dto.getActivityCount());
			vo.setRecruitStatus(dto.getRecruitStatus());
			resultList.add(vo);
		}
		return resultList;
	}

	/* (non-Javadoc)
	 * @see com.culturecloud.service.local.association.CcpAssociationService#getAssociationDetail(java.lang.String, java.lang.String)
	 */
	@Override
	public CcpAssociationDetailVO getAssociationDetail(String associationId, String userId) {

		CcpAssociationDto dto=ccpAssociationMapper.getAssociationDetail(associationId);

		CcpAssociationDetailVO vo=new CcpAssociationDetailVO(dto);
		vo.setFlowerCount(dto.getFlowerCount());

		// 粉丝数
		Integer countFan=ccpAssociationMapper.countAssociationFans(associationId);
		vo.setFansCount(countFan);

		if(StringUtils.isNotBlank(userId))
		{
			CcpAssociationFlower ccpAssociationFlower=new CcpAssociationFlower();
			ccpAssociationFlower.setAssnId(associationId);
			ccpAssociationFlower.setUserId(userId);

			// 今天浇花次数
			Integer countTodayFlower=ccpAssociationFlowerMapper.countUserAssociationTodayFlower(ccpAssociationFlower);

			if(countTodayFlower>0)
				vo.setTodayIsFlower(1);
			else
				vo.setTodayIsFlower(0);

			// 用户是否关注该团体
			Integer count = ccpAssociationMapper.queryUserFollowAssociation(associationId, userId);

			if(count>0)
				vo.setIsFollow(1);
			else
				vo.setIsFollow(0);
		}

		return vo;
	}

	/* (non-Javadoc)
	 * @see com.culturecloud.service.local.association.CcpAssociationService#getAssociationActivity(java.lang.String)
	 */
	@Override
	public List<CmsActivityVO> getAssociationActivity(String associationId) {

		String nowDate = null;

		Map<String,Object>map =new HashMap<String,Object>();
		map.put("assnId", associationId);

		List<CmsActivityDto> activityList= cmsActivityMapper.queryAssociationActivity(map);

		List<CmsActivityVO> result=new ArrayList<CmsActivityVO>();

		for (CmsActivityDto cmsActivityDto : activityList) {

			CmsActivityVO vo= new CmsActivityVO(cmsActivityDto);

			List<CmsTagSubDto> cmsTagSubList=cmsTagSubMapper.queryRelateTagSubList(cmsActivityDto.getActivityId());

			List<CmsTagSubVO> subList= new ArrayList<CmsTagSubVO>();

			for (CmsTagSubDto cmsTagSubDto : cmsTagSubList) {

				subList.add(new CmsTagSubVO(cmsTagSubDto));
			}

			vo.setSubList(subList);


			result.add(vo);

		}


		return result;
	}

	/* (non-Javadoc)
	 * @see com.culturecloud.service.local.association.CcpAssociationService#getAssociationHistoryActivity(java.lang.String)
	 */
	@Override
	public List<CmsActivityVO> getAssociationHistoryActivity(String associationId) {

		String nowDate = null;

		SimpleDateFormat sf = new SimpleDateFormat("yyyy-MM-dd");

		Date date = new Date();
		nowDate = sf.format(date);

		Map<String,Object>map =new HashMap<String,Object>();
		map.put("activityEndTime", nowDate);
		map.put("assnId", associationId);

		List<CmsActivityDto> activityList= cmsActivityMapper.queryAssociationHistoryActivity(map);

		List<CmsActivityVO> result=new ArrayList<CmsActivityVO>();

		for (CmsActivityDto cmsActivityDto : activityList) {

			CmsActivityVO vo= new CmsActivityVO(cmsActivityDto);

			List<CmsTagSubDto> cmsTagSubList=cmsTagSubMapper.queryRelateTagSubList(cmsActivityDto.getActivityId());

			List<CmsTagSubVO> subList= new ArrayList<CmsTagSubVO>();

			for (CmsTagSubDto cmsTagSubDto : cmsTagSubList) {

				subList.add(new CmsTagSubVO(cmsTagSubDto));
			}

			vo.setSubList(subList);

			result.add(vo);

		}

		return result;
	}

	@Override
	public List<CmsActivityDto> getAssociationHistoryActivityPC(Map<String, Object> map) {
		String nowDate = null;

		SimpleDateFormat sf = new SimpleDateFormat("yyyy-MM-dd");

		Date date = new Date();
		nowDate = sf.format(date);

		map.put("activityEndTime", nowDate);

		List<CmsActivityDto> activityList= cmsActivityMapper.queryAssociationHistoryActivityPC(map);

		/*List<CmsActivityVO> result=new ArrayList<CmsActivityVO>();

		 for (CmsActivityDto cmsActivityDto : activityList) {

			 CmsActivityVO vo= new CmsActivityVO(cmsActivityDto);

			 List<CmsTagSubDto> cmsTagSubList=cmsTagSubMapper.queryRelateTagSubList(cmsActivityDto.getActivityId());

				List<CmsTagSubVO> subList= new ArrayList<CmsTagSubVO>();

				for (CmsTagSubDto cmsTagSubDto : cmsTagSubList) {

					subList.add(new CmsTagSubVO(cmsTagSubDto));
				}

				vo.setSubList(subList);

			 result.add(vo);

		}*/

		return activityList;
	}

	@Override
	public int getAssociationHistoryActivityCount(Map<String, Object> map) {
		String nowDate = null;

		SimpleDateFormat sf = new SimpleDateFormat("yyyy-MM-dd");

		Date date = new Date();
		nowDate = sf.format(date);

		map.put("activityEndTime", nowDate);
		int count = cmsActivityMapper.queryAssociationHistoryActivityCount(map);
		return count;
	}

}
