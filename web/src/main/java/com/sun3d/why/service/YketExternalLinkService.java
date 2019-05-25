package com.sun3d.why.service;

import java.util.List;

import com.sun3d.why.common.Result;
import com.sun3d.why.model.bean.yket.YketExternalLink;
import com.sun3d.why.util.Pagination;

public interface YketExternalLinkService {

	List<YketExternalLink> queryYketExternalLink(
			YketExternalLink yketExternalLink, Pagination page);

	Result updateExternalLinkById(YketExternalLink yketExternalLink);

	YketExternalLink queryExternalLinkById(String id);

	List<YketExternalLink> queryExternalLinkList();

}
