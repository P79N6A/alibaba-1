package com.sun3d.why.model;

import java.util.Date;

public class BpProduct {
  
    private String productId;

    private String productName;

    private String productIconUrl;
    
    private String productModule;

    private String productContactman;

    private String productContactway;
    
    private Integer productShowtype;

    private String productVideo;

    private Integer productStatus;

    private Integer productSort;

    private Date productCreateTime;

    private Date productUpdateTime;

    private String productCreateUser;

    private String productUpdateUser;

    private String productImages;

    private String productInfo;

    private String productRemark;
    /**后台搜索关键词*/
    private String searchKey;

    public String getProductId() {
        return productId;
    }

    public void setProductId(String productId) {
        this.productId = productId;
    }

    public String getProductName() {
        return productName;
    }

    public void setProductName(String productName) {
        this.productName = productName;
    }

    public String getProductIconUrl() {
        return productIconUrl;
    }

    public void setProductIconUrl(String productIconUrl) {
        this.productIconUrl = productIconUrl;
    }

    public String getProductModule() {
		return productModule;
	}

	public void setProductModule(String productModule) {
		this.productModule = productModule;
	}

	public String getProductContactman() {
        return productContactman;
    }

    public void setProductContactman(String productContactman) {
        this.productContactman = productContactman;
    }

    public String getProductContactway() {
        return productContactway;
    }

    public void setProductContactway(String productContactway) {
        this.productContactway = productContactway;
    }

    public String getProductVideo() {
        return productVideo;
    }

    public void setProductVideo(String productVideo) {
        this.productVideo = productVideo;
    }

    public Integer getProductStatus() {
        return productStatus;
    }

    public void setProductStatus(Integer productStatus) {
        this.productStatus = productStatus;
    }

    public Integer getProductSort() {
        return productSort;
    }

    public void setProductSort(Integer productSort) {
        this.productSort = productSort;
    }

    public Date getProductCreateTime() {
        return productCreateTime;
    }

    public void setProductCreateTime(Date productCreateTime) {
        this.productCreateTime = productCreateTime;
    }
 
    public Date getProductUpdateTime() {
        return productUpdateTime;
    }

    public void setProductUpdateTime(Date productUpdateTime) {
        this.productUpdateTime = productUpdateTime;
    }

    public String getProductCreateUser() {
        return productCreateUser;
    }

    public void setProductCreateUser(String productCreateUser) {
        this.productCreateUser = productCreateUser;
    }

    public String getProductUpdateUser() {
        return productUpdateUser;
    }

    public void setProductUpdateUser(String productUpdateUser) {
        this.productUpdateUser = productUpdateUser;
    }

    public String getProductImages() {
        return productImages;
    }

    public void setProductImages(String productImages) {
        this.productImages = productImages;
    }

    public String getProductInfo() {
        return productInfo;
    }

    public void setProductInfo(String productInfo) {
        this.productInfo = productInfo;
    }

    public String getProductRemark() {
        return productRemark;
    }

    public void setProductRemark(String productRemark) {
        this.productRemark = productRemark;
    }

	public Integer getProductShowtype() {
		return productShowtype;
	}

	public void setProductShowtype(Integer productShowtype) {
		this.productShowtype = productShowtype;
	}
    
    public String getSearchKey() {
		return searchKey;
	}

	public void setSearchKey(String searchKey) {
		this.searchKey = searchKey;
	}
}