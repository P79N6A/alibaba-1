package com.sun3d.why.webservice.api.service;

public interface CmsApiService {
	public String queryVenueBySysId(String sysId,String sysNo);
	public String queryActivitRoomyBySysId(String sysId,String sysNo);
	public String queryAntiqueBySysId(String sysId,String sysNo);
	public String queryActivityBySysId(String sysId,String sysNo);
	public String queryTags(String tagsId, String dictCode);
	public boolean checkTags(String venueCrowd, String string);
	public String getTag(String tagsId, String dictCode);
	public String getTags(String tagsId, String dictCode);
	public String getAreaLocation(String venueMood, String venueArea);
	public String checkSysDictByChildName(String dictCode,String dictName);
	public String getAPITags(String tagName,String dictName);
}
