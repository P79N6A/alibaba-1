package com.culturecloud.enumeration.contest;

public enum ContestSystemTypeEnum {

	YUN_SHU(1),//云叔答题
	RED_STAR(2);//红星耀中国

	private int value;

	ContestSystemTypeEnum(int value) {
		this.value=value;
	}

	public int getValue() {
		return value;
	}
	
	
}
