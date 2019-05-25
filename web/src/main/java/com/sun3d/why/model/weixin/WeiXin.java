package com.sun3d.why.model.weixin;

import java.util.Date;

public class WeiXin {
	  /**
     * 主键
     */
    private String weiXinId;
    /**
     * 自动回复内容
     */
    private String autoContent;
    /**
     * 创建时间
     */
    private Date createTime;
    /**
     * 修改时间
     */
    private Date updateTime;


	public String getWeiXinId() {
		return weiXinId;
	}



	public void setWeiXinId(String weiXinId) {
		this.weiXinId = weiXinId;
	}



	public String getAutoContent() {
		return autoContent;
	}



	public void setAutoContent(String autoContent) {
		this.autoContent = autoContent;
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
    
}
