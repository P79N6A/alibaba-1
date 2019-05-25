package com.culturecloud.bean;

import java.util.List;

public class BasePageResultListVO<E> {
	
	private List<E> list;

	private Integer sum;
	
	/**
     * 总页数
     */
    private Integer countPage = 0;
	
	private Integer resultIndex;
	
	private Integer resultSize;
	
	private Integer resultFirst;
	
	public BasePageResultListVO() {
	}
	
	public BasePageResultListVO(BasePageRequest request) {
		super();
		resultIndex=request.getResultIndex();
		resultFirst=request.getResultFirst();
		resultSize=request.getResultSize();
	}
	
	public BasePageResultListVO(List<E> list, Integer sum) {
		super();
		this.list = list;
		this.sum = sum;
	}
	
	public BasePageResultListVO(BasePageRequest request,List<E> list, Integer sum) {
		this(request);
		this.list = list;
		this.sum = sum;
	}

	public List<E> getList() {
		return list;
	}

	public void setList(List<E> list) {
		this.list = list;
	}

	public Integer getSum() {
		return sum;
	}

	public void setSum(Integer sum) {
		this.sum = sum;
	}

	public Integer getResultIndex() {
		return resultIndex;
	}

	public void setResultIndex(Integer resultIndex) {
		this.resultIndex = resultIndex;
	}

	public Integer getResultSize() {
		return resultSize;
	}

	public void setResultSize(Integer resultSize) {
		this.resultSize = resultSize;
	}

	public Integer getResultFirst() {
		return resultFirst;
	}

	public void setResultFirst(Integer resultFirst) {
		this.resultFirst = resultFirst;
	}
	
	/**
     * 获取总页数
     *
     * @return Integer
     */
    public Integer getCountPage() {
        Integer countPage = 0;
        if (getSum() == 0) {
            return countPage;
        }
        if (this.sum % this.resultSize == 0) {
            countPage = this.sum / this.resultSize;
        } else {
            countPage = (this.sum / this.resultSize) + 1;
        }
        return countPage;
    }
}
