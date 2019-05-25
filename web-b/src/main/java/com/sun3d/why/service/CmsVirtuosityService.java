package com.sun3d.why.service;

import java.util.List;

import com.sun3d.why.model.CmsAntique;
import com.sun3d.why.model.SysUser;
import com.sun3d.why.util.Pagination;

public interface CmsVirtuosityService {

	List<CmsAntique> queryAntiqueByCondition(CmsAntique antique, Pagination page);

	CmsAntique queryVirtuosityById(String antiqueId);

	int deleteVirtuosity(CmsAntique antique, SysUser user);

	int saveVirtuosity(CmsAntique antique, SysUser user);

	int updateAntique(CmsAntique antique, SysUser user);

	CmsAntique queryAntiqueById(String antiqueId);

}
