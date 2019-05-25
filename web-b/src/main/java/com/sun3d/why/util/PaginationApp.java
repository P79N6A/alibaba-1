package com.sun3d.why.util;

import com.sun3d.why.model.CmsActivity;

import java.util.Collection;
import java.util.Map;
import java.util.Set;

/**
 * 分页帮助类
 * 
 * @author wangfan 2014年6月27日 上午10:30:06
 */
public class PaginationApp {

	/**
	 * 页数
	 */
	private Integer page = 1;
	/**
	 * 行数
	 */
	private Integer rows = 10;

	/**
	 * 总页数	
	 */
	private Integer countPage = 0;
	/**
	 * 总行数
	 */
	private Integer total = 0;
	/**
	 * 查询的开始行
	 */
	private Integer firstResult;
	/**
	 * 查询的结束行
	 */
	private Integer lastResult;

	/**
	 * 查询排序字段
	 */
	private String orderByClause;

	//喜欢收藏数量
	private  Integer likeCount;

	//最近收藏的人
	private  String likePerson;


	public String getOrderByClause() {
		return orderByClause;
	}

	public Integer getFirstResult() {
		return firstResult;
	}

	public void setOrderByClause(String orderByClause) {
		this.orderByClause = orderByClause;
	}

	public Integer getLikeCount() {
		return likeCount;
	}

	public void setLikeCount(Integer likeCount) {
		this.likeCount = likeCount;
	}

	public String getLikePerson() {
		return likePerson;
	}

	public void setLikePerson(String likePerson) {
		this.likePerson = likePerson;
	}


	public void setFirstResult(Integer firstResult) {
		this.firstResult = firstResult;
	}

	public void setLastResult(Integer lastResult) {
		this.lastResult = lastResult;
	}

	/**
	 * 获取第一页条数
	 * 
	 * @return Integer

	 * @author wangfan 2014年8月12日

	public Integer getFirstResult() {
		firstResult = (this.getPage() - 1) * rows;
		return firstResult;
	}
	 */
	/**
	 * 获得页数
	 * 
	 * @return Integer
	 * @author wangfan 2014年8月12日
	 */
	public Integer getPage() {
		if (  page == null || page <= 0 ) {
			page = 1;
		}
		return page;
	}

	public void setPage(Integer page) {
		this.page = page;
	}

	public Integer getRows() {
		return rows;
	}

	public void setRows(Integer rows) {
		this.rows = rows;
	}

	public Integer getTotal() {
		return total;
	}

	public void setTotal(Integer total) {
		this.total = total;
	}

	public void setCountPage(Integer countPage) {
		this.countPage = countPage;
	}

	/**
	 * 获取总页数
	 * 
	 * @return Integer
	 * @author wangfan
	 */
	public Integer getCountPage() {
		Integer countPage = 0;
		if (getTotal() == 0) {
			return countPage;
		}
		if (this.total % this.rows == 0) {
			countPage = this.total / this.rows;
		} else {
			countPage = (this.total / this.rows) + 1;
		}
		return countPage;
	}

	/**
	 * 获得最后的结束数
	 * 
	 * @return Integer
	 * @author wangfan 2014年8月12日
	 */
	public Integer getLastResult() {
		lastResult = getFirstResult() + getRows();
		return lastResult;
	}

}
