package com.culturecloud.model.bean.pdfengcai;

import java.util.Date;

public class PdNews {
	/**
	 * 涓婚敭id
	 */
	private String newsId;
	/**
	 * 鏍囬
	 */
	private String title;
	/**
	 * 灏侀潰
	 */
	private String newsImg;
	/**
	 * 鎻忚堪
	 */
	private String newsMemo;
	/**
	 * 鍒涘缓鏃堕棿
	 */
	private Date createDate;
	/**
	 * 鏇存柊鏃堕棿
	 */
	private Date updateDate;
	/**
	 * 缃《鍔熻兘 0鍙栨秷缃《 1缃《
	 */
	private Integer isTop;
	/**
	 * 鎵嬪姩鎺掑簭 鏁板瓧瓒婂ぇ 鎺掑湪鏈�鍓嶉潰
	 */
	private Integer newsIndex;

	private String timeStr;

	public String getNewsId() {
		return newsId;
	}

	public void setNewsId(String newsId) {
		this.newsId = newsId;
	}

	public String getTitle() {
		return title;
	}

	public void setTitle(String title) {
		this.title = title;
	}

	public String getNewsImg() {
		return newsImg;
	}

	public void setNewsImg(String newsImg) {
		this.newsImg = newsImg;
	}

	public Date getCreateDate() {
		return createDate;
	}

	public void setCreateDate(Date createDate) {
		this.createDate = createDate;
	}

	public Date getUpdateDate() {
		return updateDate;
	}

	public void setUpdateDate(Date updateDate) {
		this.updateDate = updateDate;
	}

	public String getNewsMemo() {
		return newsMemo;
	}

	public void setNewsMemo(String newsMemo) {
		this.newsMemo = newsMemo;
	}

	public Integer getIsTop() {
		return isTop;
	}

	public void setIsTop(Integer isTop) {
		this.isTop = isTop;
	}

	public Integer getNewsIndex() {
		return newsIndex;
	}

	public void setNewsIndex(Integer newsIndex) {
		this.newsIndex = newsIndex;
	}

	public String getTimeStr() {
		return timeStr;
	}

	public void setTimeStr(String timeStr) {
		this.timeStr = timeStr;
	}

}
