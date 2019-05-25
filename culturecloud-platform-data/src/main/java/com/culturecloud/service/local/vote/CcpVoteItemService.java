package com.culturecloud.service.local.vote;

import com.culturecloud.bean.BasePageResultListVO;
import com.culturecloud.model.request.vote.QueryVoteItemListVO;
import com.culturecloud.model.response.vote.CcpVoteItemVO;

public interface CcpVoteItemService {

	public BasePageResultListVO<CcpVoteItemVO> queryVoteItemList(QueryVoteItemListVO request);
}
