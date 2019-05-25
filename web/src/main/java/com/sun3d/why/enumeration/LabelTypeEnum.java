package com.sun3d.why.enumeration;

public enum LabelTypeEnum {
	COURSE("课程级别", 1), COURSE_TYPE("课程类别", 2), COURSE_FORM("课程标签",3);
	private String name;
	private Integer index;

	private LabelTypeEnum(String name, Integer index) {
		this.index = index;
		this.name = name;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public Integer getIndex() {
		return index;
	}

	public void setIndex(Integer index) {
		this.index = index;
	}

}
