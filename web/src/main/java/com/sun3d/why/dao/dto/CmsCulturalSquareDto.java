package com.sun3d.why.dao.dto;

import java.util.List;

import com.culturecloud.model.bean.square.CmsCulturalSquare;
import com.sun3d.why.model.CmsComment;

public class CmsCulturalSquareDto extends CmsCulturalSquare{
    //虚拟属性
    private Integer wantCount;
    
    private Integer userIsWant;
    
    List<CmsComment> commentList;
    
    private Integer commentCount;

	public Integer getWantCount() {
		return wantCount;
	}

	public void setWantCount(Integer wantCount) {
		this.wantCount = wantCount;
	}

	public Integer getUserIsWant() {
		return userIsWant;
	}

	public void setUserIsWant(Integer userIsWant) {
		this.userIsWant = userIsWant;
	}

	public List<CmsComment> getCommentList() {
		return commentList;
	}

	public void setCommentList(List<CmsComment> commentList) {
		this.commentList = commentList;
	}

	public Integer getCommentCount() {
		return commentCount;
	}

	public void setCommentCount(Integer commentCount) {
		this.commentCount = commentCount;
	}
}
