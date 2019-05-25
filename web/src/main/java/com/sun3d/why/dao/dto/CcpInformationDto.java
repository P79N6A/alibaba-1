package com.sun3d.why.dao.dto;

import com.culturecloud.model.bean.common.CcpInformation;
import com.culturecloud.model.bean.common.CcpInformationDetail;
import com.sun3d.why.model.extmodel.StaticServer;
import org.springframework.beans.factory.annotation.Autowired;

import java.util.List;

public class CcpInformationDto extends CcpInformation {

	private Integer wantCount;

	private Integer userIsWant;

	private Integer commentCount;
	
	private Integer userIsCollect;
	
	private List<CcpInformationDetail> detailList;
	
	private String informationTypeName;

	private String toUrl;

	public String getToUrl() {
		if(getInformationSort() != null && getInformationSort() == 5){
              return getToOtherUrl();
		}
		return "/zxInformation/informationDetail.do?informationId="+
				getInformationId()+"&module="+getInformationModuleId();
	}

	public void setToUrl(String toUrl) {
		this.toUrl = toUrl;
	}

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

	public Integer getCommentCount() {
		return commentCount;
	}

	public void setCommentCount(Integer commentCount) {
		this.commentCount = commentCount;
	}

	public List<CcpInformationDetail> getDetailList() {
		return detailList;
	}

	public void setDetailList(List<CcpInformationDetail> detailList) {
		this.detailList = detailList;
	}

	public Integer getUserIsCollect() {
		return userIsCollect;
	}

	public void setUserIsCollect(Integer userIsCollect) {
		this.userIsCollect = userIsCollect;
	}

	public String getInformationTypeName() {
		return informationTypeName;
	}

	public void setInformationTypeName(String informationTypeName) {
		this.informationTypeName = informationTypeName;
	}

	
}
