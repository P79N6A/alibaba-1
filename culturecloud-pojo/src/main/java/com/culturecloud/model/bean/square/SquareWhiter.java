package com.culturecloud.model.bean.square;

import javax.persistence.Column;

import com.culturecloud.annotations.Table;
import com.culturecloud.bean.BaseEntity;

@Table(value="square_whiter")
public class SquareWhiter implements BaseEntity{

	private static final long serialVersionUID = 7183160431350847199L;

	@Column(name="white_user_id")
	private String whiteUserId;
	
	@Column(name="type")
	private String type;

	public String getWhiteUserId() {
		return whiteUserId;
	}

	public void setWhiteUserId(String whiteUserId) {
		this.whiteUserId = whiteUserId;
	}

	public String getType() {
		return type;
	}

	public void setType(String type) {
		this.type = type;
	}
	
	
}
