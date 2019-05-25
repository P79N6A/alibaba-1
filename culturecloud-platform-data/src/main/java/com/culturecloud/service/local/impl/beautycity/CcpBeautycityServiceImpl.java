package com.culturecloud.service.local.impl.beautycity;

import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Isolation;
import org.springframework.transaction.annotation.Transactional;

import com.culturecloud.bean.BasePageResultListVO;
import com.culturecloud.dao.beautycity.CcpBeautycityImgMapper;
import com.culturecloud.dao.beautycity.CcpBeautycityMapper;
import com.culturecloud.dao.beautycity.CcpBeautycityVenueMapper;
import com.culturecloud.dao.beautycity.CcpBeautycityVoteMapper;
import com.culturecloud.enumeration.common.IntegralTypeEnum;
import com.culturecloud.model.bean.common.SysUserIntegral;
import com.culturecloud.model.bean.common.SysUserIntegralDetail;
import com.culturecloud.model.request.beautycity.CcpBeautycityImgReqVO;
import com.culturecloud.model.request.beautycity.CcpBeautycityReqVO;
import com.culturecloud.model.request.beautycity.CcpBeautycityVenueReqVO;
import com.culturecloud.model.request.beautycity.CcpBeautycityVoteReqVO;
import com.culturecloud.model.response.beautycity.CcpBeautycityImgResVO;
import com.culturecloud.model.response.beautycity.CcpBeautycityResVO;
import com.culturecloud.model.response.beautycity.CcpBeautycityVenueResVO;
import com.culturecloud.service.BaseService;
import com.culturecloud.service.local.beautycity.CcpBeautycityService;
import com.culturecloud.service.local.common.SysUserIntegralService;

@Service
public class CcpBeautycityServiceImpl implements CcpBeautycityService{
	
	@Resource
	private CcpBeautycityMapper ccpBeautycityMapper;
	@Resource
	private CcpBeautycityImgMapper ccpBeautycityImgMapper;
	@Resource
	private CcpBeautycityVoteMapper ccpBeautycityVoteMapper;
	@Resource
	private CcpBeautycityVenueMapper ccpBeautycityVenueMapper;
	@Resource
	private SysUserIntegralService sysUserIntegralService;
	@Resource
	private BaseService baseService;
	
	@Override
	public BasePageResultListVO<CcpBeautycityImgResVO> getBeautycityImgList(CcpBeautycityImgReqVO request) {
		List<CcpBeautycityImgResVO> list = ccpBeautycityImgMapper.selectBeautycityImgList(request);
		//计算自己上传图片的排名
		if(request.getIsMe()==1){
			if(list.size()>0){
				for(CcpBeautycityImgResVO vo:list){
					int ranking = ccpBeautycityImgMapper.selectRankingByVoteCount(vo);
					vo.setRanking(ranking);
				}
			}
		}
		int sum = ccpBeautycityImgMapper.selectBeautycityImgListCount(request);
		BasePageResultListVO<CcpBeautycityImgResVO> basePageResultListVO = new BasePageResultListVO<CcpBeautycityImgResVO>(list, sum);
		basePageResultListVO.setResultSize(request.getResultSize());
		basePageResultListVO.setResultIndex(request.getResultIndex());
		basePageResultListVO.setResultFirst(request.getResultFirst());
		return basePageResultListVO;
	}

	@Override
	public List<CcpBeautycityImgResVO> getBeautycityImgRankingList(CcpBeautycityImgReqVO request) {
		return ccpBeautycityImgMapper.selectBeautycityImgRankingList(request);
	}

	@Override
	public void saveBeautycity(CcpBeautycityReqVO request) {
		ccpBeautycityMapper.insert(request);
	}

	@Override
	@Transactional(isolation=Isolation.SERIALIZABLE)
	public void saveBeautycityImg(CcpBeautycityImgReqVO request) {
		List<CcpBeautycityResVO> listOld = ccpBeautycityMapper.selectBeautycityList(new CcpBeautycityReqVO(request.getUserId()));
		String venueCountOld = listOld.get(0).getVenueCount();
		ccpBeautycityImgMapper.insert(request);
		List<CcpBeautycityResVO> listNew = ccpBeautycityMapper.selectBeautycityList(new CcpBeautycityReqVO(request.getUserId()));
		String venueCountNew = listNew.get(0).getVenueCount();
		if(venueCountOld.equals("9")&&venueCountNew.equals("10")){
			SysUserIntegralDetail sysUserIntegral = new SysUserIntegralDetail();
			sysUserIntegral.setIntegralId(sysUserIntegralService.getUserIntegralByUserId(request.getUserId()).getIntegralId());
			sysUserIntegral.setIntegralChange(500);
			sysUserIntegral.setIntegralType(IntegralTypeEnum.BEAUTYCITY.getIndex());
			if(baseService.findByModel(sysUserIntegral).size()==0){
				sysUserIntegralService.insertUserIntegral(request.getUserId(), 500, 0, "最美城市集满10个不同空间的照片", IntegralTypeEnum.BEAUTYCITY.getIndex());
			}
		}else if(venueCountOld.equals("49")&&venueCountNew.equals("50")){
			SysUserIntegralDetail sysUserIntegral = new SysUserIntegralDetail();
			sysUserIntegral.setIntegralId(sysUserIntegralService.getUserIntegralByUserId(request.getUserId()).getIntegralId());
			sysUserIntegral.setIntegralChange(1000);
			sysUserIntegral.setIntegralType(IntegralTypeEnum.BEAUTYCITY.getIndex());
			if(baseService.findByModel(sysUserIntegral).size()==0){
				sysUserIntegralService.insertUserIntegral(request.getUserId(), 1000, 0, "最美城市集满50个不同空间的照片", IntegralTypeEnum.BEAUTYCITY.getIndex());
			}
		}else if(venueCountOld.equals("99")&&venueCountNew.equals("100")){
			Integer maxFinishVenueRanking = ccpBeautycityMapper.selectMaxFinishVenueRanking();
			CcpBeautycityReqVO ccpBeautycityReqVO = new CcpBeautycityReqVO();
			ccpBeautycityReqVO.setBeautycityId(listOld.get(0).getBeautycityId());
			ccpBeautycityReqVO.setFinishVenueRanking(Integer.toString(maxFinishVenueRanking+1));
			ccpBeautycityMapper.update(ccpBeautycityReqVO);
		}
	}

	@Override
	public void voteBeautycityImg(CcpBeautycityVoteReqVO request) {
		int count = ccpBeautycityVoteMapper.countUserTodayVote(request);
		if(count==0){
			ccpBeautycityVoteMapper.insert(request);
		}
	}

	@Override
	public List<CcpBeautycityVenueResVO> getBeautycityVenueList(CcpBeautycityVenueReqVO request) {
		return ccpBeautycityVenueMapper.selectBeautycityVenueList(request);
	}

	@Override
	public BasePageResultListVO<CcpBeautycityResVO> getBeautycityList(CcpBeautycityReqVO request) {
		List<CcpBeautycityResVO> list = ccpBeautycityMapper.selectBeautycityList(request);
		int sum = ccpBeautycityMapper.selectBeautycityListCount(request);
		BasePageResultListVO<CcpBeautycityResVO> basePageResultListVO = new BasePageResultListVO<CcpBeautycityResVO>(list, sum);
		basePageResultListVO.setResultSize(request.getResultSize());
		basePageResultListVO.setResultIndex(request.getResultIndex());
		basePageResultListVO.setResultFirst(request.getResultFirst());
		return basePageResultListVO;
	}

	@Override
	public void deleteBeautycityImg(CcpBeautycityImgReqVO request) {
		ccpBeautycityImgMapper.deleteByPrimaryKey(request.getBeautycityImgId());
	}
	
}
