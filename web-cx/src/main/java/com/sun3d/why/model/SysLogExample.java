package com.sun3d.why.model;

import com.sun3d.why.util.Pagination;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

public class SysLogExample  extends Pagination implements Serializable {
    protected String orderByClause;

    protected boolean distinct;

    protected List<Criteria> oredCriteria;

    public SysLogExample() {
        oredCriteria = new ArrayList<Criteria>();
    }

    public void setOrderByClause(String orderByClause) {
        this.orderByClause = orderByClause;
    }

    public String getOrderByClause() {
        return orderByClause;
    }

    public void setDistinct(boolean distinct) {
        this.distinct = distinct;
    }

    public boolean isDistinct() {
        return distinct;
    }

    public List<Criteria> getOredCriteria() {
        return oredCriteria;
    }

    public void or(Criteria criteria) {
        oredCriteria.add(criteria);
    }

    public Criteria or() {
        Criteria criteria = createCriteriaInternal();
        oredCriteria.add(criteria);
        return criteria;
    }

    public Criteria createCriteria() {
        Criteria criteria = createCriteriaInternal();
        if (oredCriteria.size() == 0) {
            oredCriteria.add(criteria);
        }
        return criteria;
    }

    protected Criteria createCriteriaInternal() {
        Criteria criteria = new Criteria();
        return criteria;
    }

    public void clear() {
        oredCriteria.clear();
        orderByClause = null;
        distinct = false;
    }

    protected abstract static class GeneratedCriteria {
        protected List<Criterion> criteria;

        protected GeneratedCriteria() {
            super();
            criteria = new ArrayList<Criterion>();
        }

        public boolean isValid() {
            return criteria.size() > 0;
        }

        public List<Criterion> getAllCriteria() {
            return criteria;
        }

        public List<Criterion> getCriteria() {
            return criteria;
        }

        protected void addCriterion(String condition) {
            if (condition == null) {
                throw new RuntimeException("Value for condition cannot be null");
            }
            criteria.add(new Criterion(condition));
        }

        protected void addCriterion(String condition, Object value, String property) {
            if (value == null) {
                throw new RuntimeException("Value for " + property + " cannot be null");
            }
            criteria.add(new Criterion(condition, value));
        }

        protected void addCriterion(String condition, Object value1, Object value2, String property) {
            if (value1 == null || value2 == null) {
                throw new RuntimeException("Between values for " + property + " cannot be null");
            }
            criteria.add(new Criterion(condition, value1, value2));
        }

        public Criteria andLogIdIsNull() {
            addCriterion("LOG_ID is null");
            return (Criteria) this;
        }

        public Criteria andLogIdIsNotNull() {
            addCriterion("LOG_ID is not null");
            return (Criteria) this;
        }

        public Criteria andLogIdEqualTo(String value) {
            addCriterion("LOG_ID =", value, "logId");
            return (Criteria) this;
        }

        public Criteria andLogIdNotEqualTo(String value) {
            addCriterion("LOG_ID <>", value, "logId");
            return (Criteria) this;
        }

        public Criteria andLogIdGreaterThan(String value) {
            addCriterion("LOG_ID >", value, "logId");
            return (Criteria) this;
        }

        public Criteria andLogIdGreaterThanOrEqualTo(String value) {
            addCriterion("LOG_ID >=", value, "logId");
            return (Criteria) this;
        }

        public Criteria andLogIdLessThan(String value) {
            addCriterion("LOG_ID <", value, "logId");
            return (Criteria) this;
        }

        public Criteria andLogIdLessThanOrEqualTo(String value) {
            addCriterion("LOG_ID <=", value, "logId");
            return (Criteria) this;
        }

        public Criteria andLogIdLike(String value) {
            addCriterion("LOG_ID like", value, "logId");
            return (Criteria) this;
        }

        public Criteria andLogIdNotLike(String value) {
            addCriterion("LOG_ID not like", value, "logId");
            return (Criteria) this;
        }

        public Criteria andLogIdIn(List<String> values) {
            addCriterion("LOG_ID in", values, "logId");
            return (Criteria) this;
        }

        public Criteria andLogIdNotIn(List<String> values) {
            addCriterion("LOG_ID not in", values, "logId");
            return (Criteria) this;
        }

        public Criteria andLogIdBetween(String value1, String value2) {
            addCriterion("LOG_ID between", value1, value2, "logId");
            return (Criteria) this;
        }

        public Criteria andLogIdNotBetween(String value1, String value2) {
            addCriterion("LOG_ID not between", value1, value2, "logId");
            return (Criteria) this;
        }

        public Criteria andLogUserIdIsNull() {
            addCriterion("LOG_USER_ID is null");
            return (Criteria) this;
        }

        public Criteria andLogUserIdIsNotNull() {
            addCriterion("LOG_USER_ID is not null");
            return (Criteria) this;
        }

        public Criteria andLogUserIdEqualTo(String value) {
            addCriterion("LOG_USER_ID =", value, "logUserId");
            return (Criteria) this;
        }

        public Criteria andLogUserIdNotEqualTo(String value) {
            addCriterion("LOG_USER_ID <>", value, "logUserId");
            return (Criteria) this;
        }

        public Criteria andLogUserIdGreaterThan(String value) {
            addCriterion("LOG_USER_ID >", value, "logUserId");
            return (Criteria) this;
        }

        public Criteria andLogUserIdGreaterThanOrEqualTo(String value) {
            addCriterion("LOG_USER_ID >=", value, "logUserId");
            return (Criteria) this;
        }

        public Criteria andLogUserIdLessThan(String value) {
            addCriterion("LOG_USER_ID <", value, "logUserId");
            return (Criteria) this;
        }

        public Criteria andLogUserIdLessThanOrEqualTo(String value) {
            addCriterion("LOG_USER_ID <=", value, "logUserId");
            return (Criteria) this;
        }

        public Criteria andLogUserIdLike(String value) {
            addCriterion("LOG_USER_ID like", value, "logUserId");
            return (Criteria) this;
        }

        public Criteria andLogUserIdNotLike(String value) {
            addCriterion("LOG_USER_ID not like", value, "logUserId");
            return (Criteria) this;
        }

        public Criteria andLogUserIdIn(List<String> values) {
            addCriterion("LOG_USER_ID in", values, "logUserId");
            return (Criteria) this;
        }

        public Criteria andLogUserIdNotIn(List<String> values) {
            addCriterion("LOG_USER_ID not in", values, "logUserId");
            return (Criteria) this;
        }

        public Criteria andLogUserIdBetween(String value1, String value2) {
            addCriterion("LOG_USER_ID between", value1, value2, "logUserId");
            return (Criteria) this;
        }

        public Criteria andLogUserIdNotBetween(String value1, String value2) {
            addCriterion("LOG_USER_ID not between", value1, value2, "logUserId");
            return (Criteria) this;
        }

        public Criteria andLogNickNameIsNull() {
            addCriterion("LOG_NICK_NAME is null");
            return (Criteria) this;
        }

        public Criteria andLogNickNameIsNotNull() {
            addCriterion("LOG_NICK_NAME is not null");
            return (Criteria) this;
        }

        public Criteria andLogNickNameEqualTo(String value) {
            addCriterion("LOG_NICK_NAME =", value, "logNickName");
            return (Criteria) this;
        }

        public Criteria andLogNickNameNotEqualTo(String value) {
            addCriterion("LOG_NICK_NAME <>", value, "logNickName");
            return (Criteria) this;
        }

        public Criteria andLogNickNameGreaterThan(String value) {
            addCriterion("LOG_NICK_NAME >", value, "logNickName");
            return (Criteria) this;
        }

        public Criteria andLogNickNameGreaterThanOrEqualTo(String value) {
            addCriterion("LOG_NICK_NAME >=", value, "logNickName");
            return (Criteria) this;
        }

        public Criteria andLogNickNameLessThan(String value) {
            addCriterion("LOG_NICK_NAME <", value, "logNickName");
            return (Criteria) this;
        }

        public Criteria andLogNickNameLessThanOrEqualTo(String value) {
            addCriterion("LOG_NICK_NAME <=", value, "logNickName");
            return (Criteria) this;
        }

        public Criteria andLogNickNameLike(String value) {
            addCriterion("LOG_NICK_NAME like", value, "logNickName");
            return (Criteria) this;
        }

        public Criteria andLogNickNameNotLike(String value) {
            addCriterion("LOG_NICK_NAME not like", value, "logNickName");
            return (Criteria) this;
        }

        public Criteria andLogNickNameIn(List<String> values) {
            addCriterion("LOG_NICK_NAME in", values, "logNickName");
            return (Criteria) this;
        }

        public Criteria andLogNickNameNotIn(List<String> values) {
            addCriterion("LOG_NICK_NAME not in", values, "logNickName");
            return (Criteria) this;
        }

        public Criteria andLogNickNameBetween(String value1, String value2) {
            addCriterion("LOG_NICK_NAME between", value1, value2, "logNickName");
            return (Criteria) this;
        }

        public Criteria andLogNickNameNotBetween(String value1, String value2) {
            addCriterion("LOG_NICK_NAME not between", value1, value2, "logNickName");
            return (Criteria) this;
        }

        public Criteria andLogIpIsNull() {
            addCriterion("LOG_IP is null");
            return (Criteria) this;
        }

        public Criteria andLogIpIsNotNull() {
            addCriterion("LOG_IP is not null");
            return (Criteria) this;
        }

        public Criteria andLogIpEqualTo(String value) {
            addCriterion("LOG_IP =", value, "logIp");
            return (Criteria) this;
        }

        public Criteria andLogIpNotEqualTo(String value) {
            addCriterion("LOG_IP <>", value, "logIp");
            return (Criteria) this;
        }

        public Criteria andLogIpGreaterThan(String value) {
            addCriterion("LOG_IP >", value, "logIp");
            return (Criteria) this;
        }

        public Criteria andLogIpGreaterThanOrEqualTo(String value) {
            addCriterion("LOG_IP >=", value, "logIp");
            return (Criteria) this;
        }

        public Criteria andLogIpLessThan(String value) {
            addCriterion("LOG_IP <", value, "logIp");
            return (Criteria) this;
        }

        public Criteria andLogIpLessThanOrEqualTo(String value) {
            addCriterion("LOG_IP <=", value, "logIp");
            return (Criteria) this;
        }

        public Criteria andLogIpLike(String value) {
            addCriterion("LOG_IP like", value, "logIp");
            return (Criteria) this;
        }

        public Criteria andLogIpNotLike(String value) {
            addCriterion("LOG_IP not like", value, "logIp");
            return (Criteria) this;
        }

        public Criteria andLogIpIn(List<String> values) {
            addCriterion("LOG_IP in", values, "logIp");
            return (Criteria) this;
        }

        public Criteria andLogIpNotIn(List<String> values) {
            addCriterion("LOG_IP not in", values, "logIp");
            return (Criteria) this;
        }

        public Criteria andLogIpBetween(String value1, String value2) {
            addCriterion("LOG_IP between", value1, value2, "logIp");
            return (Criteria) this;
        }

        public Criteria andLogIpNotBetween(String value1, String value2) {
            addCriterion("LOG_IP not between", value1, value2, "logIp");
            return (Criteria) this;
        }

        public Criteria andLogModuleNameIsNull() {
            addCriterion("LOG_MODULE_NAME is null");
            return (Criteria) this;
        }

        public Criteria andLogModuleNameIsNotNull() {
            addCriterion("LOG_MODULE_NAME is not null");
            return (Criteria) this;
        }

        public Criteria andLogModuleNameEqualTo(String value) {
            addCriterion("LOG_MODULE_NAME =", value, "logModuleName");
            return (Criteria) this;
        }

        public Criteria andLogModuleNameNotEqualTo(String value) {
            addCriterion("LOG_MODULE_NAME <>", value, "logModuleName");
            return (Criteria) this;
        }

        public Criteria andLogModuleNameGreaterThan(String value) {
            addCriterion("LOG_MODULE_NAME >", value, "logModuleName");
            return (Criteria) this;
        }

        public Criteria andLogModuleNameGreaterThanOrEqualTo(String value) {
            addCriterion("LOG_MODULE_NAME >=", value, "logModuleName");
            return (Criteria) this;
        }

        public Criteria andLogModuleNameLessThan(String value) {
            addCriterion("LOG_MODULE_NAME <", value, "logModuleName");
            return (Criteria) this;
        }

        public Criteria andLogModuleNameLessThanOrEqualTo(String value) {
            addCriterion("LOG_MODULE_NAME <=", value, "logModuleName");
            return (Criteria) this;
        }

        public Criteria andLogModuleNameLike(String value) {
            addCriterion("LOG_MODULE_NAME like", value, "logModuleName");
            return (Criteria) this;
        }

        public Criteria andLogModuleNameNotLike(String value) {
            addCriterion("LOG_MODULE_NAME not like", value, "logModuleName");
            return (Criteria) this;
        }

        public Criteria andLogModuleNameIn(List<String> values) {
            addCriterion("LOG_MODULE_NAME in", values, "logModuleName");
            return (Criteria) this;
        }

        public Criteria andLogModuleNameNotIn(List<String> values) {
            addCriterion("LOG_MODULE_NAME not in", values, "logModuleName");
            return (Criteria) this;
        }

        public Criteria andLogModuleNameBetween(String value1, String value2) {
            addCriterion("LOG_MODULE_NAME between", value1, value2, "logModuleName");
            return (Criteria) this;
        }

        public Criteria andLogModuleNameNotBetween(String value1, String value2) {
            addCriterion("LOG_MODULE_NAME not between", value1, value2, "logModuleName");
            return (Criteria) this;
        }

        public Criteria andLogRemarkIsNull() {
            addCriterion("LOG_REMARK is null");
            return (Criteria) this;
        }

        public Criteria andLogRemarkIsNotNull() {
            addCriterion("LOG_REMARK is not null");
            return (Criteria) this;
        }

        public Criteria andLogRemarkEqualTo(String value) {
            addCriterion("LOG_REMARK =", value, "logRemark");
            return (Criteria) this;
        }

        public Criteria andLogRemarkNotEqualTo(String value) {
            addCriterion("LOG_REMARK <>", value, "logRemark");
            return (Criteria) this;
        }

        public Criteria andLogRemarkGreaterThan(String value) {
            addCriterion("LOG_REMARK >", value, "logRemark");
            return (Criteria) this;
        }

        public Criteria andLogRemarkGreaterThanOrEqualTo(String value) {
            addCriterion("LOG_REMARK >=", value, "logRemark");
            return (Criteria) this;
        }

        public Criteria andLogRemarkLessThan(String value) {
            addCriterion("LOG_REMARK <", value, "logRemark");
            return (Criteria) this;
        }

        public Criteria andLogRemarkLessThanOrEqualTo(String value) {
            addCriterion("LOG_REMARK <=", value, "logRemark");
            return (Criteria) this;
        }

        public Criteria andLogRemarkLike(String value) {
            addCriterion("LOG_REMARK like", value, "logRemark");
            return (Criteria) this;
        }

        public Criteria andLogRemarkNotLike(String value) {
            addCriterion("LOG_REMARK not like", value, "logRemark");
            return (Criteria) this;
        }

        public Criteria andLogRemarkIn(List<String> values) {
            addCriterion("LOG_REMARK in", values, "logRemark");
            return (Criteria) this;
        }

        public Criteria andLogRemarkNotIn(List<String> values) {
            addCriterion("LOG_REMARK not in", values, "logRemark");
            return (Criteria) this;
        }

        public Criteria andLogRemarkBetween(String value1, String value2) {
            addCriterion("LOG_REMARK between", value1, value2, "logRemark");
            return (Criteria) this;
        }

        public Criteria andLogRemarkNotBetween(String value1, String value2) {
            addCriterion("LOG_REMARK not between", value1, value2, "logRemark");
            return (Criteria) this;
        }

        public Criteria andLogOperTimeIsNull() {
            addCriterion("LOG_OPER_TIME is null");
            return (Criteria) this;
        }

        public Criteria andLogOperTimeIsNotNull() {
            addCriterion("LOG_OPER_TIME is not null");
            return (Criteria) this;
        }

        public Criteria andLogOperTimeEqualTo(Date value) {
            addCriterion("LOG_OPER_TIME =", value, "logOperTime");
            return (Criteria) this;
        }

        public Criteria andLogOperTimeNotEqualTo(Date value) {
            addCriterion("LOG_OPER_TIME <>", value, "logOperTime");
            return (Criteria) this;
        }

        public Criteria andLogOperTimeGreaterThan(Date value) {
            addCriterion("LOG_OPER_TIME >", value, "logOperTime");
            return (Criteria) this;
        }

        public Criteria andLogOperTimeGreaterThanOrEqualTo(Date value) {
            addCriterion("LOG_OPER_TIME >=", value, "logOperTime");
            return (Criteria) this;
        }

        public Criteria andLogOperTimeLessThan(Date value) {
            addCriterion("LOG_OPER_TIME <", value, "logOperTime");
            return (Criteria) this;
        }

        public Criteria andLogOperTimeLessThanOrEqualTo(Date value) {
            addCriterion("LOG_OPER_TIME <=", value, "logOperTime");
            return (Criteria) this;
        }

        public Criteria andLogOperTimeIn(List<Date> values) {
            addCriterion("LOG_OPER_TIME in", values, "logOperTime");
            return (Criteria) this;
        }

        public Criteria andLogOperTimeNotIn(List<Date> values) {
            addCriterion("LOG_OPER_TIME not in", values, "logOperTime");
            return (Criteria) this;
        }

        public Criteria andLogOperTimeBetween(Date value1, Date value2) {
            addCriterion("LOG_OPER_TIME between", value1, value2, "logOperTime");
            return (Criteria) this;
        }

        public Criteria andLogOperTimeNotBetween(Date value1, Date value2) {
            addCriterion("LOG_OPER_TIME not between", value1, value2, "logOperTime");
            return (Criteria) this;
        }
    }

    public static class Criteria extends GeneratedCriteria {

        protected Criteria() {
            super();
        }
    }

    public static class Criterion {
        private String condition;

        private Object value;

        private Object secondValue;

        private boolean noValue;

        private boolean singleValue;

        private boolean betweenValue;

        private boolean listValue;

        private String typeHandler;

        public String getCondition() {
            return condition;
        }

        public Object getValue() {
            return value;
        }

        public Object getSecondValue() {
            return secondValue;
        }

        public boolean isNoValue() {
            return noValue;
        }

        public boolean isSingleValue() {
            return singleValue;
        }

        public boolean isBetweenValue() {
            return betweenValue;
        }

        public boolean isListValue() {
            return listValue;
        }

        public String getTypeHandler() {
            return typeHandler;
        }

        protected Criterion(String condition) {
            super();
            this.condition = condition;
            this.typeHandler = null;
            this.noValue = true;
        }

        protected Criterion(String condition, Object value, String typeHandler) {
            super();
            this.condition = condition;
            this.value = value;
            this.typeHandler = typeHandler;
            if (value instanceof List<?>) {
                this.listValue = true;
            } else {
                this.singleValue = true;
            }
        }

        protected Criterion(String condition, Object value) {
            this(condition, value, null);
        }

        protected Criterion(String condition, Object value, Object secondValue, String typeHandler) {
            super();
            this.condition = condition;
            this.value = value;
            this.secondValue = secondValue;
            this.typeHandler = typeHandler;
            this.betweenValue = true;
        }

        protected Criterion(String condition, Object value, Object secondValue) {
            this(condition, value, secondValue, null);
        }
    }
}