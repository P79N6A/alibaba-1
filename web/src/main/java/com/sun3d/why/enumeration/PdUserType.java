package com.sun3d.why.enumeration;

public enum PdUserType {
	OFFER(1, "供方"), DEMAND(2, "需方");
	private int index;
	private String name;

	private PdUserType(int index, String name) {
		this.index = index;
		this.name = name;
	}

	public static String getName(int index) {
		for (PdUserType pdUserType : PdUserType.values()) {
			if (pdUserType.getIndex() == index) {
				return pdUserType.name;
			}
		}
		return null;
	}

	public int getIndex() {
		return index;
	}

	public void setIndex(int index) {
		this.index = index;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public static void main(String[] args) {
		PdUserType type=PdUserType.valueOf("DENIND");
		System.out.println(type.getIndex());
		
		
		
	}
}
