package com.culturecloud.service.local.impl.live;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Isolation;
import org.springframework.transaction.annotation.Transactional;

import com.culturecloud.bean.BasePageResultListVO;
import com.culturecloud.coreutils.UUIDUtils;
import com.culturecloud.dao.dto.live.CcpLiveUserDto;
import com.culturecloud.dao.live.CcpLiveUserMapper;
import com.culturecloud.model.bean.live.CcpLiveUser;
import com.culturecloud.model.request.live.CcpLiveUserDetailVO;
import com.culturecloud.model.request.live.CcpLiveUserImgPageVO;
import com.culturecloud.model.request.live.SaveLiveUserVO;
import com.culturecloud.model.response.live.CcpLiveUserVO;
import com.culturecloud.service.local.live.CcpLiveUserService;

@Service
@Transactional
public class CcpLiveUserServiceImp implements CcpLiveUserService {

	@Resource
	private CcpLiveUserMapper ccpLiveUserMapper;

	@Override
	@Transactional(isolation = Isolation.SERIALIZABLE)
	public CcpLiveUserVO createLiveUserInfo(SaveLiveUserVO vo) {

		String userId = vo.getUserId();

		String liveActivity = vo.getLiveActivity();

		CcpLiveUser model = new CcpLiveUser();

		model.setUserId(userId);
		model.setLiveActivity(liveActivity);

		CcpLiveUser user = ccpLiveUserMapper.selectByUserId(model);

		String liveUserId = null;

		if (user == null) {

			liveUserId = UUIDUtils.createUUId();

			user = new CcpLiveUser();
			user.setLiveUserId(liveUserId);
			user.setLiveActivity(vo.getLiveActivity());
			user.setUserCreateTime(new Date());
			user.setUserId(userId);
			user.setUserIsLike(0);

			ccpLiveUserMapper.insertSelective(user);

		} else
			liveUserId = user.getLiveUserId();

		CcpLiveUserDto liveUser = ccpLiveUserMapper.queryCcpLiveUserById(liveUserId);

		return new CcpLiveUserVO(liveUser);
	}

	@Override
	public CcpLiveUserVO updateLiveUserInfo(SaveLiveUserVO vo) {

		CcpLiveUser user = new CcpLiveUser();

		user.setLiveUserId(vo.getLiveUserId());
		user.setLiveActivity(vo.getLiveActivity());
		user.setUserId(vo.getUserId());
		user.setUserIsLike(vo.getUserIsLike());
		user.setUserRealName(vo.getUserRealName());
		user.setUserTelephone(vo.getUserTelephone());
		user.setUserUpdateTime(new Date());
		user.setUserUploadImg(vo.getUserUploadImg());

		ccpLiveUserMapper.updateByPrimaryKeySelective(user);

		CcpLiveUserDto liveUser = ccpLiveUserMapper.queryCcpLiveUserById(vo.getLiveUserId());

		return new CcpLiveUserVO(liveUser);
	}

	@Override
	public BasePageResultListVO<CcpLiveUserVO> selectLiveUserImgList(CcpLiveUserImgPageVO vo) {

		int sum = ccpLiveUserMapper.selectLiveUserImgListCount(vo);

		List<CcpLiveUserVO> list = new ArrayList<CcpLiveUserVO>();

		if (sum > 0) {

			List<CcpLiveUserDto> ccpLiveUserList = ccpLiveUserMapper.selectLiveUserImgList(vo);

			for (CcpLiveUserDto ccpLiveUserDto : ccpLiveUserList) {

				CcpLiveUserVO liveUser = new CcpLiveUserVO(ccpLiveUserDto);

				list.add(liveUser);
			}
		}

		BasePageResultListVO<CcpLiveUserVO> basePageResultListVO = new BasePageResultListVO<CcpLiveUserVO>(list, sum);
		basePageResultListVO.setResultSize(vo.getResultSize());
		basePageResultListVO.setResultIndex(vo.getResultIndex());
		basePageResultListVO.setResultFirst(vo.getResultFirst());

		return basePageResultListVO;

	}

	@Override
	public CcpLiveUserVO queryCcpLiveUserDetail(CcpLiveUserDetailVO vo) {

		CcpLiveUserDto liveUser = ccpLiveUserMapper.queryCcpLiveUserById(vo.getLiveUserId());

		CcpLiveUserVO ccpLiveUserVO = new CcpLiveUserVO(liveUser);

		String liveActivity = vo.getLiveActivity();

		int isLikeCount = ccpLiveUserMapper.selectIsLikeCount(liveActivity);

		ccpLiveUserVO.setIsLikeSum(isLikeCount);

		return ccpLiveUserVO;
	}

	@Override
	public int selectIsLikeSum(String liveActivity) {

		int isLikeCount = ccpLiveUserMapper.selectIsLikeCount(liveActivity);

		return isLikeCount;
	}

}
