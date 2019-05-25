package com.culturecloud.model.request.venue;

import java.util.ArrayList;
import java.util.List;

import com.culturecloud.bean.BaseRequest;
import com.culturecloud.model.bean.venue.CmsAntique;

public class CmsAntiqueListVO extends BaseRequest{

	List<CmsAntique> list=new ArrayList<CmsAntique>();
	
	public CmsAntiqueListVO() {
	}

	public List<CmsAntique> getList() {
		return list;
	}

	public void setList(List<CmsAntique> list) {
		this.list = list;
	}
	
	
}
