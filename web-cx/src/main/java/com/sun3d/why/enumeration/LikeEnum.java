package com.sun3d.why.enumeration;

public enum LikeEnum {
	COURSE("课程", 1) ;
	private String name;
	private Integer index;

	private LikeEnum(String name, Integer index) {
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
