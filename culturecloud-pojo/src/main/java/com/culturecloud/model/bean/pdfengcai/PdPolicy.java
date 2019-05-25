package com.culturecloud.model.bean.pdfengcai;

import java.util.Date;

public class PdPolicy {
    private String policyId;

    private String policyTitle;

    private String policyImg;

    private Integer policyIndex;

    private Integer isTop;

    private Date createTime;

    private Date updateTime;

    private String policyMemo;

	private String timeStr;

    public String getPolicyId() {
        return policyId;
    }

    public void setPolicyId(String policyId) {
        this.policyId = policyId == null ? null : policyId.trim();
    }

    public String getPolicyTitle() {
        return policyTitle;
    }

    public void setPolicyTitle(String policyTitle) {
        this.policyTitle = policyTitle == null ? null : policyTitle.trim();
    }

    public String getPolicyImg() {
        return policyImg;
    }

    public void setPolicyImg(String policyImg) {
        this.policyImg = policyImg == null ? null : policyImg.trim();
    }

    public Integer getPolicyIndex() {
        return policyIndex;
    }

    public void setPolicyIndex(Integer policyIndex) {
        this.policyIndex = policyIndex;
    }

    public Integer getIsTop() {
		return isTop;
	}

	public void setIsTop(Integer isTop) {
		this.isTop = isTop;
	}

	public Date getCreateTime() {
        return createTime;
    }

    public void setCreateTime(Date createTime) {
        this.createTime = createTime;
    }

    public Date getUpdateTime() {
        return updateTime;
    }

    public void setUpdateTime(Date updateTime) {
        this.updateTime = updateTime;
    }

    public String getPolicyMemo() {
        return policyMemo;
    }

    public void setPolicyMemo(String policyMemo) {
        this.policyMemo = policyMemo == null ? null : policyMemo.trim();
    }

	public String getTimeStr() {
		return timeStr;
	}

	public void setTimeStr(String timeStr) {
		this.timeStr = timeStr;
	}
    
}