package com.culturecloud.enumeration.wrpx;

/***
 * 万人培训 标签
 * 
 * @author Administrator
 *
 */
public enum WrpxLabelEnum {
	JOB_TITLE((byte)1, "职级"), JOB_POSITION((byte)2,"职位"),INDUSTRY((byte)3, "从事领域");
	private Byte index;
	private String name;

	private WrpxLabelEnum(Byte index, String name) {
		this.index = index;
		this.name = name;
	}

	public Byte getIndex() {
		return index;
	}

	public void setIndex(Byte index) {
		this.index = index;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}
	
	public static String valueOf(Byte index){
		if(null==index){
			return null;
		}
		for(WrpxLabelEnum label:WrpxLabelEnum.values()){
			if(label.getIndex().equals(index)){
				return label.getName();
			}
		}
		return null;
	}
	
	public static WrpxLabelEnum toWrpxLabelEnum(Byte index){
		if(null==index){
			return null;
		}
		for(WrpxLabelEnum label:WrpxLabelEnum.values()){
			if(label.getIndex().equals(index)){
				return label;
			}
		}
		return null;
	}
	
	public static void main(String[] args) {
		//System.out.println(WrpxLabelEnum.valueOf((byte)3));
		
		WrpxLabelEnum e = WrpxLabelEnum.toWrpxLabelEnum((byte)3);
		
		switch(e){
		case INDUSTRY:System.out.println(INDUSTRY.index);
		break;
		case JOB_POSITION:System.out.println(JOB_POSITION.index);
		break;
		case JOB_TITLE:System.out.println(JOB_TITLE.index);
		break;
		default:System.out.println("--over--");
		}
		
		
		
		
		
		
		
		
	}

}
