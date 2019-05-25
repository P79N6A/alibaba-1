package com.culturecloud.model.bean.pdfengcai;

public class PdProperty {
	/**
	 * 主键
	 */
	private String propertyId;
	/**
	 * 展位区域
	 */
	private String area;
	/**
	 * 展位编号
	 */
	private Integer number;
	/**
	 * 展位状态 0未分配 1 已分配
	 */
	private Integer propertyStatus;

	public String getPropertyId() {
		return propertyId;
	}

	public void setPropertyId(String propertyId) {
		this.propertyId = propertyId;
	}

	public String getArea() {
		return area;
	}

	public void setArea(String area) {
		this.area = area;
	}

	public Integer getNumber() {
		return number;
	}

	public void setNumber(Integer number) {
		this.number = number;
	}

	public Integer getPropertyStatus() {
		return propertyStatus;
	}

	public void setPropertyStatus(Integer propertyStatus) {
		this.propertyStatus = propertyStatus;
	}

}
