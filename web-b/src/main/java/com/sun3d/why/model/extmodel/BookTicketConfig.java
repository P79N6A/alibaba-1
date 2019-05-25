package com.sun3d.why.model.extmodel;

/**
 * Created by yujinbing on 2015/7/20.
 */
public class BookTicketConfig {

    /**
     * 最大购票数
     */
    private Integer maxBookTicketCount;

    /**
     * 验证方式  1:通过userId   2:通过电话号码
     */
    private Integer checkConfig;

    public Integer getMaxBookTicketCount() {
        return maxBookTicketCount;
    }

    public void setMaxBookTicketCount(Integer maxBookTicketCount) {
        this.maxBookTicketCount = maxBookTicketCount;
    }

    public Integer getCheckConfig() {
        return checkConfig;
    }

    public void setCheckConfig(Integer checkConfig) {
        this.checkConfig = checkConfig;
    }
}
