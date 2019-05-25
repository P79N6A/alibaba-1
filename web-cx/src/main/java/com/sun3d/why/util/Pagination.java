package com.sun3d.why.util;

/**
 * 分页帮助类
 */
public class Pagination {

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

    private boolean isShowPage = true;




    /**
     * 获得页数
     *
     * @return Integer
     */
    public Integer getPage() {
        if (page == null || page <= 0) {
            page = 1;
        }
        return page;
    }


    /**
     * 获取总页数
     *
     * @return Integer
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
	 */
	public Integer getFirstResult() {
		firstResult = (this.getPage() - 1) * rows;
		return firstResult;
	}

    public void setTotal(Integer total) {
        this.total = total;
    }


    public void setCountPage(Integer countPage) {
        this.countPage = countPage;
    }

    public String getOrderByClause() {
        return orderByClause;
    }

    public void setOrderByClause(String orderByClause) {
        this.orderByClause = orderByClause;
    }

    public boolean isShowPage() {
        return isShowPage;
    }

    public void setShowPage(boolean showPage) {
        isShowPage = showPage;
    }
}
