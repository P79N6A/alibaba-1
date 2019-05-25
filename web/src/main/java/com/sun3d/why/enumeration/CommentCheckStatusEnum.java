package com.sun3d.why.enumeration;

public enum CommentCheckStatusEnum {
	PASS("通过", 0), NO_PASS("不通过", 1),;
	private String name;
	private Integer index;

	private CommentCheckStatusEnum(String name, Integer index) {
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
