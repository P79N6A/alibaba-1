package com.culturecloud.service.local.live;


import com.culturecloud.bean.BasePageResultListVO;
import com.culturecloud.model.request.live.CcpLiveUserDetailVO;
import com.culturecloud.model.request.live.CcpLiveUserImgPageVO;
import com.culturecloud.model.request.live.SaveLiveUserVO;
import com.culturecloud.model.response.live.CcpLiveUserVO;

public interface CcpLiveUserService {

	public CcpLiveUserVO createLiveUserInfo(SaveLiveUserVO vo);
	
	public CcpLiveUserVO updateLiveUserInfo(SaveLiveUserVO vo);
	
	public BasePageResultListVO<CcpLiveUserVO> selectLiveUserImgList(CcpLiveUserImgPageVO vo);
	
	public CcpLiveUserVO queryCcpLiveUserDetail(CcpLiveUserDetailVO vo);
	
	public int selectIsLikeSum(String liveActivity);
}
