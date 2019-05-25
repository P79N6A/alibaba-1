package com.culturecloud.bean;

import javax.validation.constraints.NotNull;
import javax.validation.constraints.Size;

/**
 * ����ֻ��id
 * @author caoj
 *
 */
public class IdRequest extends BaseRequest{
	@NotNull
	@Size(min=1)
	private String id;  

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}
}
