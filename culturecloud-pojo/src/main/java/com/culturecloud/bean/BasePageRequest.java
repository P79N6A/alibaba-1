package com.culturecloud.bean;

import javax.validation.constraints.NotNull;

/**
 * ��ҳ����
 * zhangchenxi
 * */
public class BasePageRequest extends BaseRequest implements ValidatorBean{

	/** ��ʼҳ��*/
	private Integer resultIndex=1;

	/** ��ѯ����*/
	private Integer resultSize=10;

	/** ��ʼ��*/
	private Integer resultFirst;

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
		if(resultFirst!=null){
			return resultFirst;
		}else{
			return (resultIndex-1)*resultSize;
		}
	}

	public void setResultFirst(Integer resultFirst) {
		this.resultFirst = resultFirst;
	}



}
