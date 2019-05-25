package com.culturecloud.model.bean.analyse;

import javax.persistence.Column;

import com.culturecloud.annotations.Table;
import com.culturecloud.bean.BaseEntity;

@Table(value="sys_params_config")
public class SysParamsConfig implements BaseEntity{

	private static final long serialVersionUID = 9022646891087805247L;
	
	@Column(name="config_name")
	private String configName;
	
	@Column(name="config_value")
	private String configValue;
	
	@Column(name="business_id")
	private String businessId;
	
	@Column(name="config_description")
	private String configDescription;

	public String getConfigName() {
		return configName;
	}

	public void setConfigName(String configName) {
		this.configName = configName;
	}


	public String getConfigValue() {
		return configValue;
	}


	public void setConfigValue(String configValue) {
		this.configValue = configValue;
	}

	public String getBusinessId() {
		return businessId;
	}

	public void setBusinessId(String businessId) {
		this.businessId = businessId;
	}

	public String getConfigDescription() {
		return configDescription;
	}

	public void setConfigDescription(String configDescription) {
		this.configDescription = configDescription;
	}
}