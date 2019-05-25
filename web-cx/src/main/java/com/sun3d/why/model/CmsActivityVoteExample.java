package com.sun3d.why.model;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

public class CmsActivityVoteExample {
    protected String orderByClause;

    protected boolean distinct;

    protected List<Criteria> oredCriteria;

    public CmsActivityVoteExample() {
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

        public Criteria andVoteIdIsNull() {
            addCriterion("VOTE_ID is null");
            return (Criteria) this;
        }

        public Criteria andVoteIdIsNotNull() {
            addCriterion("VOTE_ID is not null");
            return (Criteria) this;
        }

        public Criteria andVoteIdEqualTo(String value) {
            addCriterion("VOTE_ID =", value, "voteId");
            return (Criteria) this;
        }

        public Criteria andVoteIdNotEqualTo(String value) {
            addCriterion("VOTE_ID <>", value, "voteId");
            return (Criteria) this;
        }

        public Criteria andVoteIdGreaterThan(String value) {
            addCriterion("VOTE_ID >", value, "voteId");
            return (Criteria) this;
        }

        public Criteria andVoteIdGreaterThanOrEqualTo(String value) {
            addCriterion("VOTE_ID >=", value, "voteId");
            return (Criteria) this;
        }

        public Criteria andVoteIdLessThan(String value) {
            addCriterion("VOTE_ID <", value, "voteId");
            return (Criteria) this;
        }

        public Criteria andVoteIdLessThanOrEqualTo(String value) {
            addCriterion("VOTE_ID <=", value, "voteId");
            return (Criteria) this;
        }

        public Criteria andVoteIdLike(String value) {
            addCriterion("VOTE_ID like", value, "voteId");
            return (Criteria) this;
        }

        public Criteria andVoteIdNotLike(String value) {
            addCriterion("VOTE_ID not like", value, "voteId");
            return (Criteria) this;
        }

        public Criteria andVoteIdIn(List<String> values) {
            addCriterion("VOTE_ID in", values, "voteId");
            return (Criteria) this;
        }

        public Criteria andVoteIdNotIn(List<String> values) {
            addCriterion("VOTE_ID not in", values, "voteId");
            return (Criteria) this;
        }

        public Criteria andVoteIdBetween(String value1, String value2) {
            addCriterion("VOTE_ID between", value1, value2, "voteId");
            return (Criteria) this;
        }

        public Criteria andVoteIdNotBetween(String value1, String value2) {
            addCriterion("VOTE_ID not between", value1, value2, "voteId");
            return (Criteria) this;
        }

        public Criteria andActivityIdIsNull() {
            addCriterion("ACTIVITY_ID is null");
            return (Criteria) this;
        }

        public Criteria andActivityIdIsNotNull() {
            addCriterion("ACTIVITY_ID is not null");
            return (Criteria) this;
        }

        public Criteria andActivityIdEqualTo(String value) {
            addCriterion("ACTIVITY_ID =", value, "activityId");
            return (Criteria) this;
        }

        public Criteria andActivityIdNotEqualTo(String value) {
            addCriterion("ACTIVITY_ID <>", value, "activityId");
            return (Criteria) this;
        }

        public Criteria andActivityIdGreaterThan(String value) {
            addCriterion("ACTIVITY_ID >", value, "activityId");
            return (Criteria) this;
        }

        public Criteria andActivityIdGreaterThanOrEqualTo(String value) {
            addCriterion("ACTIVITY_ID >=", value, "activityId");
            return (Criteria) this;
        }

        public Criteria andActivityIdLessThan(String value) {
            addCriterion("ACTIVITY_ID <", value, "activityId");
            return (Criteria) this;
        }

        public Criteria andActivityIdLessThanOrEqualTo(String value) {
            addCriterion("ACTIVITY_ID <=", value, "activityId");
            return (Criteria) this;
        }

        public Criteria andActivityIdLike(String value) {
            addCriterion("ACTIVITY_ID like", value, "activityId");
            return (Criteria) this;
        }

        public Criteria andActivityIdNotLike(String value) {
            addCriterion("ACTIVITY_ID not like", value, "activityId");
            return (Criteria) this;
        }

        public Criteria andActivityIdIn(List<String> values) {
            addCriterion("ACTIVITY_ID in", values, "activityId");
            return (Criteria) this;
        }

        public Criteria andActivityIdNotIn(List<String> values) {
            addCriterion("ACTIVITY_ID not in", values, "activityId");
            return (Criteria) this;
        }

        public Criteria andActivityIdBetween(String value1, String value2) {
            addCriterion("ACTIVITY_ID between", value1, value2, "activityId");
            return (Criteria) this;
        }

        public Criteria andActivityIdNotBetween(String value1, String value2) {
            addCriterion("ACTIVITY_ID not between", value1, value2, "activityId");
            return (Criteria) this;
        }

        public Criteria andVoteTitelIsNull() {
            addCriterion("VOTE_TITEL is null");
            return (Criteria) this;
        }

        public Criteria andVoteTitelIsNotNull() {
            addCriterion("VOTE_TITEL is not null");
            return (Criteria) this;
        }

        public Criteria andVoteTitelEqualTo(String value) {
            addCriterion("VOTE_TITEL =", value, "voteTitel");
            return (Criteria) this;
        }

        public Criteria andVoteTitelNotEqualTo(String value) {
            addCriterion("VOTE_TITEL <>", value, "voteTitel");
            return (Criteria) this;
        }

        public Criteria andVoteTitelGreaterThan(String value) {
            addCriterion("VOTE_TITEL >", value, "voteTitel");
            return (Criteria) this;
        }

        public Criteria andVoteTitelGreaterThanOrEqualTo(String value) {
            addCriterion("VOTE_TITEL >=", value, "voteTitel");
            return (Criteria) this;
        }

        public Criteria andVoteTitelLessThan(String value) {
            addCriterion("VOTE_TITEL <", value, "voteTitel");
            return (Criteria) this;
        }

        public Criteria andVoteTitelLessThanOrEqualTo(String value) {
            addCriterion("VOTE_TITEL <=", value, "voteTitel");
            return (Criteria) this;
        }

        public Criteria andVoteTitelLike(String value) {
            addCriterion("VOTE_TITEL like", value, "voteTitel");
            return (Criteria) this;
        }

        public Criteria andVoteTitelNotLike(String value) {
            addCriterion("VOTE_TITEL not like", value, "voteTitel");
            return (Criteria) this;
        }

        public Criteria andVoteTitelIn(List<String> values) {
            addCriterion("VOTE_TITEL in", values, "voteTitel");
            return (Criteria) this;
        }

        public Criteria andVoteTitelNotIn(List<String> values) {
            addCriterion("VOTE_TITEL not in", values, "voteTitel");
            return (Criteria) this;
        }

        public Criteria andVoteTitelBetween(String value1, String value2) {
            addCriterion("VOTE_TITEL between", value1, value2, "voteTitel");
            return (Criteria) this;
        }

        public Criteria andVoteTitelNotBetween(String value1, String value2) {
            addCriterion("VOTE_TITEL not between", value1, value2, "voteTitel");
            return (Criteria) this;
        }

        public Criteria andVoteIsDelIsNull() {
            addCriterion("VOTE_IS_DEL is null");
            return (Criteria) this;
        }

        public Criteria andVoteIsDelIsNotNull() {
            addCriterion("VOTE_IS_DEL is not null");
            return (Criteria) this;
        }

        public Criteria andVoteIsDelEqualTo(Integer value) {
            addCriterion("VOTE_IS_DEL =", value, "voteIsDel");
            return (Criteria) this;
        }

        public Criteria andVoteIsDelNotEqualTo(Integer value) {
            addCriterion("VOTE_IS_DEL <>", value, "voteIsDel");
            return (Criteria) this;
        }

        public Criteria andVoteIsDelGreaterThan(Integer value) {
            addCriterion("VOTE_IS_DEL >", value, "voteIsDel");
            return (Criteria) this;
        }

        public Criteria andVoteIsDelGreaterThanOrEqualTo(Integer value) {
            addCriterion("VOTE_IS_DEL >=", value, "voteIsDel");
            return (Criteria) this;
        }

        public Criteria andVoteIsDelLessThan(Integer value) {
            addCriterion("VOTE_IS_DEL <", value, "voteIsDel");
            return (Criteria) this;
        }

        public Criteria andVoteIsDelLessThanOrEqualTo(Integer value) {
            addCriterion("VOTE_IS_DEL <=", value, "voteIsDel");
            return (Criteria) this;
        }

        public Criteria andVoteIsDelIn(List<Integer> values) {
            addCriterion("VOTE_IS_DEL in", values, "voteIsDel");
            return (Criteria) this;
        }

        public Criteria andVoteIsDelNotIn(List<Integer> values) {
            addCriterion("VOTE_IS_DEL not in", values, "voteIsDel");
            return (Criteria) this;
        }

        public Criteria andVoteIsDelBetween(Integer value1, Integer value2) {
            addCriterion("VOTE_IS_DEL between", value1, value2, "voteIsDel");
            return (Criteria) this;
        }

        public Criteria andVoteIsDelNotBetween(Integer value1, Integer value2) {
            addCriterion("VOTE_IS_DEL not between", value1, value2, "voteIsDel");
            return (Criteria) this;
        }

        public Criteria andVoteDateIsNull() {
            addCriterion("VOTE_DATE is null");
            return (Criteria) this;
        }

        public Criteria andVoteDateIsNotNull() {
            addCriterion("VOTE_DATE is not null");
            return (Criteria) this;
        }

        public Criteria andVoteDateEqualTo(Date value) {
            addCriterion("VOTE_DATE =", value, "voteDate");
            return (Criteria) this;
        }

        public Criteria andVoteDateNotEqualTo(Date value) {
            addCriterion("VOTE_DATE <>", value, "voteDate");
            return (Criteria) this;
        }

        public Criteria andVoteDateGreaterThan(Date value) {
            addCriterion("VOTE_DATE >", value, "voteDate");
            return (Criteria) this;
        }

        public Criteria andVoteDateGreaterThanOrEqualTo(Date value) {
            addCriterion("VOTE_DATE >=", value, "voteDate");
            return (Criteria) this;
        }

        public Criteria andVoteDateLessThan(Date value) {
            addCriterion("VOTE_DATE <", value, "voteDate");
            return (Criteria) this;
        }

        public Criteria andVoteDateLessThanOrEqualTo(Date value) {
            addCriterion("VOTE_DATE <=", value, "voteDate");
            return (Criteria) this;
        }

        public Criteria andVoteDateIn(List<Date> values) {
            addCriterion("VOTE_DATE in", values, "voteDate");
            return (Criteria) this;
        }

        public Criteria andVoteDateNotIn(List<Date> values) {
            addCriterion("VOTE_DATE not in", values, "voteDate");
            return (Criteria) this;
        }

        public Criteria andVoteDateBetween(Date value1, Date value2) {
            addCriterion("VOTE_DATE between", value1, value2, "voteDate");
            return (Criteria) this;
        }

        public Criteria andVoteDateNotBetween(Date value1, Date value2) {
            addCriterion("VOTE_DATE not between", value1, value2, "voteDate");
            return (Criteria) this;
        }

        public Criteria andUpdateDateIsNull() {
            addCriterion("UPDATE_DATE is null");
            return (Criteria) this;
        }

        public Criteria andUpdateDateIsNotNull() {
            addCriterion("UPDATE_DATE is not null");
            return (Criteria) this;
        }

        public Criteria andUpdateDateEqualTo(Date value) {
            addCriterion("UPDATE_DATE =", value, "updateDate");
            return (Criteria) this;
        }

        public Criteria andUpdateDateNotEqualTo(Date value) {
            addCriterion("UPDATE_DATE <>", value, "updateDate");
            return (Criteria) this;
        }

        public Criteria andUpdateDateGreaterThan(Date value) {
            addCriterion("UPDATE_DATE >", value, "updateDate");
            return (Criteria) this;
        }

        public Criteria andUpdateDateGreaterThanOrEqualTo(Date value) {
            addCriterion("UPDATE_DATE >=", value, "updateDate");
            return (Criteria) this;
        }

        public Criteria andUpdateDateLessThan(Date value) {
            addCriterion("UPDATE_DATE <", value, "updateDate");
            return (Criteria) this;
        }

        public Criteria andUpdateDateLessThanOrEqualTo(Date value) {
            addCriterion("UPDATE_DATE <=", value, "updateDate");
            return (Criteria) this;
        }

        public Criteria andUpdateDateIn(List<Date> values) {
            addCriterion("UPDATE_DATE in", values, "updateDate");
            return (Criteria) this;
        }

        public Criteria andUpdateDateNotIn(List<Date> values) {
            addCriterion("UPDATE_DATE not in", values, "updateDate");
            return (Criteria) this;
        }

        public Criteria andUpdateDateBetween(Date value1, Date value2) {
            addCriterion("UPDATE_DATE between", value1, value2, "updateDate");
            return (Criteria) this;
        }

        public Criteria andUpdateDateNotBetween(Date value1, Date value2) {
            addCriterion("UPDATE_DATE not between", value1, value2, "updateDate");
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