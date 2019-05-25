package com.culturecloud.service.local.contest;

import com.culturecloud.model.request.contest.SaveContestUserResultVO;

public interface CcpContestUserResultService {

	/**
	 * 保存用户主题结果
	 * @param saveContestUserResultVO
	 * @return
	 */
	public int saveContestUserResult(SaveContestUserResultVO saveContestUserResultVO);
}
 