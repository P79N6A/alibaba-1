package com.culturecloud.model.bean.wrpx;

import java.io.Serializable;
import java.util.Date;

public class WrpxTrainningMethod implements Serializable{
    /**
	 * 
	 */
	private static final long serialVersionUID = -5298417486683605198L;

	private String tranningMethodId;

    private String batchId;

    private String trainingMethodName;

    private Integer maxNum;

    private Date createDate;

    private String createUser;

    private Date updateDate;

    private String updateUser;

    private Integer trainingMethodSort;

    public String getTranningMethodId() {
        return tranningMethodId;
    }

    public void setTranningMethodId(String tranningMethodId) {
        this.tranningMethodId = tranningMethodId == null ? null : tranningMethodId.trim();
    }

    public String getBatchId() {
        return batchId;
    }

    public void setBatchId(String batchId) {
        this.batchId = batchId == null ? null : batchId.trim();
    }

    public String getTrainingMethodName() {
        return trainingMethodName;
    }

    public void setTrainingMethodName(String trainingMethodName) {
        this.trainingMethodName = trainingMethodName == null ? null : trainingMethodName.trim();
    }

    public Integer getMaxNum() {
        return maxNum;
    }

    public void setMaxNum(Integer maxNum) {
        this.maxNum = maxNum;
    }

    public Date getCreateDate() {
        return createDate;
    }

    public void setCreateDate(Date createDate) {
        this.createDate = createDate;
    }

    public String getCreateUser() {
        return createUser;
    }

    public void setCreateUser(String createUser) {
        this.createUser = createUser == null ? null : createUser.trim();
    }

    public Date getUpdateDate() {
        return updateDate;
    }

    public void setUpdateDate(Date updateDate) {
        this.updateDate = updateDate;
    }

    public String getUpdateUser() {
        return updateUser;
    }

    public void setUpdateUser(String updateUser) {
        this.updateUser = updateUser == null ? null : updateUser.trim();
    }

    public Integer getTrainingMethodSort() {
        return trainingMethodSort;
    }

    public void setTrainingMethodSort(Integer trainingMethodSort) {
        this.trainingMethodSort = trainingMethodSort;
    }
}