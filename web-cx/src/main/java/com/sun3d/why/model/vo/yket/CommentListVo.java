package com.sun3d.why.model.vo.yket;

import com.sun3d.why.model.bean.yket.YketComment;

public class CommentListVo extends YketComment {

	private String userNickName;
	private String userHeadImgUrl;

	public String getUserNickName() {
		return userNickName;
	}

	public void setUserNickName(String userNickName) {
		this.userNickName = userNickName;
	}

	public String getUserHeadImgUrl() {
		return userHeadImgUrl;
	}

	public void setUserHeadImgUrl(String userHeadImgUrl) {
		this.userHeadImgUrl = userHeadImgUrl;
	}

}
