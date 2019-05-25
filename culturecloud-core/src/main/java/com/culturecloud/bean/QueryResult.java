/**
 * 
 */
package com.culturecloud.bean;

import java.io.Serializable;
import java.util.List;

/**************************************
 * @Description：基础分页返回包装
 * @author Zhangchenxi
 * @since 2015年6月8日
 * @version 1.0
 * @param <E>
 **************************************/

public class QueryResult<E> implements Serializable{

	private List<E> list;
	private long totalrecord;
	private Integer resultIndex;
	
	public List<E> getList() {
		return list;
	}
	public void setList(List<E> list) {
		this.list = list;
	}
	public long getTotalrecord() {
		return totalrecord;
	}
	public void setTotalrecord(long totalrecord) {
		this.totalrecord = totalrecord;
	}
	public Integer getResultIndex() {
		return resultIndex;
	}
	public void setResultIndex(Integer resultIndex) {
		this.resultIndex = resultIndex;
	}
	
}
