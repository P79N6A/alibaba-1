package com.sun3d.why.dao;

import java.util.List;
import java.util.Map;

import com.sun3d.why.model.BpAntique;


public interface WechatBpAntiqueMapper {

	int queryBpAntiqueListCount(Map<String, Object> map);

	List<BpAntique> queryBpAntiqueList(Map<String, Object> map);

	BpAntique queryBpAntiqueById(Map<String,Object> map);

}
