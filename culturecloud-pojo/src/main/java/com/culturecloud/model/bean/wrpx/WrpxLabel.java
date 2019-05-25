package com.culturecloud.model.bean.wrpx;

import java.io.Serializable;
import java.util.Date;

/**
 * ������ѵ��ǩ
 * 
 * @author Administrator
 *
 */
public class WrpxLabel implements Serializable{
	/**
	 * 
	 */
	private static final long serialVersionUID = 5252262365221763734L;

	private String labelId;

	private Byte labelType;

	private String labelName;

	private String labelDesc;
	
	private String createuser;

	private String updateuser;

	private Date createdate;

	private Date updatedate;

	private Boolean deleted;

	public String getLabelId() {
		return labelId;
	}

	public void setLabelId(String labelId) {
		this.labelId = labelId == null ? null : labelId.trim();
	}

	public Byte getLabelType() {
		return labelType;
	}

	public void setLabelType(Byte labelType) {
		this.labelType = labelType;
	}

	public String getLabelName() {
		return labelName;
	}

	public void setLabelName(String labelName) {
		this.labelName = labelName == null ? null : labelName.trim();
	}

	public String getCreateuser() {
		return createuser;
	}

	public void setCreateuser(String createuser) {
		this.createuser = createuser == null ? null : createuser.trim();
	}

	public String getUpdateuser() {
		return updateuser;
	}

	public void setUpdateuser(String updateuser) {
		this.updateuser = updateuser == null ? null : updateuser.trim();
	}

	public Date getCreatedate() {
		return createdate;
	}

	public void setCreatedate(Date createdate) {
		this.createdate = createdate;
	}

	public Date getUpdatedate() {
		return updatedate;
	}

	public void setUpdatedate(Date updatedate) {
		this.updatedate = updatedate;
	}

	public Boolean getDeleted() {
		return deleted;
	}

	public void setDeleted(Boolean deleted) {
		this.deleted = deleted;
	}

	public String getLabelDesc() {
		return labelDesc;
	}

	public void setLabelDesc(String labelDesc) {
		this.labelDesc = labelDesc;
	}
	
	
}