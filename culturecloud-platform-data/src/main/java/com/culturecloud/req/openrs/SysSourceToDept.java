package com.culturecloud.req.openrs;


public class SysSourceToDept {

	public static String toDept(String sysSource)
	{
		if(sysSource==null||sysSource.trim().equals(""))
		{
			return null;
		}
		else if(sysSource.trim().equals("fsdl"))
		{
			return SysSourceEnum.FSDL.getSource();
		}
		
		return null;
	}
}
