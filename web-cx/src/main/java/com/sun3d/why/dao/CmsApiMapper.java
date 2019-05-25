package com.sun3d.why.dao;

import java.util.List;
import java.util.Map;

public interface CmsApiMapper {
	public List<String> queryVenueBySysId(Map map);
	public List<String> queryActivitRoomyBySysId(Map map);
	public List<String> queryAntiqueBySysId(Map map);
	public List<String> queryActivityBySysId(Map map);
	public List<String> queryTags(Map map);
	public List<String> queryTag(Map map);
	public List<String> queryDict(Map map);
	public List<String> queryAPITags(Map map);
	
	   
	/**
	 * 查询地点是否存在
	 * @param map
	 * @return
	 */
	List<String> checkSysDictByChildName(Map<String, Object> map);
}
