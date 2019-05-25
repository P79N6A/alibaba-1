package com.sun3d.why.model;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

public class CmsActivityVoteRelevanceExample {
    protected String orderByClause;

    protected boolean distinct;

    protected List<Criteria> oredCriteria;

    public CmsActivityVoteRelevanceExample() {
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

        public Criteria andVoteRelevanceIdIsNull() {
            addCriterion("VOTE_RELEVANCE_ID is null");
            return (Criteria) this;
        }

        public Criteria andVoteRelevanceIdIsNotNull() {
            addCriterion("VOTE_RELEVANCE_ID is not null");
            return (Criteria) this;
        }

        public Criteria andVoteRelevanceIdEqualTo(String value) {
            addCriterion("VOTE_RELEVANCE_ID =", value, "voteRelevanceId");
            return (Criteria) this;
        }

        public Criteria andVoteRelevanceIdNotEqualTo(String value) {
            addCriterion("VOTE_RELEVANCE_ID <>", value, "voteRelevanceId");
            return (Criteria) this;
        }

        public Criteria andVoteRelevanceIdGreaterThan(String value) {
            addCriterion("VOTE_RELEVANCE_ID >", value, "voteRelevanceId");
            return (Criteria) this;
        }

        public Criteria andVoteRelevanceIdGreaterThanOrEqualTo(String value) {
            addCriterion("VOTE_RELEVANCE_ID >=", value, "voteRelevanceId");
            return (Criteria) this;
        }

        public Criteria andVoteRelevanceIdLessThan(String value) {
            addCriterion("VOTE_RELEVANCE_ID <", value, "voteRelevanceId");
            return (Criteria) this;
        }

        public Criteria andVoteRelevanceIdLessThanOrEqualTo(String value) {
            addCriterion("VOTE_RELEVANCE_ID <=", value, "voteRelevanceId");
            return (Criteria) this;
        }

        public Criteria andVoteRelevanceIdLike(String value) {
            addCriterion("VOTE_RELEVANCE_ID like", value, "voteRelevanceId");
            return (Criteria) this;
        }

        public Criteria andVoteRelevanceIdNotLike(String value) {
            addCriterion("VOTE_RELEVANCE_ID not like", value, "voteRelevanceId");
            return (Criteria) this;
        }

        public Criteria andVoteRelevanceIdIn(List<String> values) {
            addCriterion("VOTE_RELEVANCE_ID in", values, "voteRelevanceId");
            return (Criteria) this;
        }

        public Criteria andVoteRelevanceIdNotIn(List<String> values) {
            addCriterion("VOTE_RELEVANCE_ID not in", values, "voteRelevanceId");
            return (Criteria) this;
        }

        public Criteria andVoteRelevanceIdBetween(String value1, String value2) {
            addCriterion("VOTE_RELEVANCE_ID between", value1, value2, "voteRelevanceId");
            return (Criteria) this;
        }

        public Criteria andVoteRelevanceIdNotBetween(String value1, String value2) {
            addCriterion("VOTE_RELEVANCE_ID not between", value1, value2, "voteRelevanceId");
            return (Criteria) this;
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

        public Criteria andVoteContentIsNull() {
            addCriterion("VOTE_CONTENT is null");
            return (Criteria) this;
        }

        public Criteria andVoteContentIsNotNull() {
            addCriterion("VOTE_CONTENT is not null");
            return (Criteria) this;
        }

        public Criteria andVoteContentEqualTo(String value) {
            addCriterion("VOTE_CONTENT =", value, "voteContent");
            return (Criteria) this;
        }

        public Criteria andVoteContentNotEqualTo(String value) {
            addCriterion("VOTE_CONTENT <>", value, "voteContent");
            return (Criteria) this;
        }

        public Criteria andVoteContentGreaterThan(String value) {
            addCriterion("VOTE_CONTENT >", value, "voteContent");
            return (Criteria) this;
        }

        public Criteria andVoteContentGreaterThanOrEqualTo(String value) {
            addCriterion("VOTE_CONTENT >=", value, "voteContent");
            return (Criteria) this;
        }

        public Criteria andVoteContentLessThan(String value) {
            addCriterion("VOTE_CONTENT <", value, "voteContent");
            return (Criteria) this;
        }

        public Criteria andVoteContentLessThanOrEqualTo(String value) {
            addCriterion("VOTE_CONTENT <=", value, "voteContent");
            return (Criteria) this;
        }

        public Criteria andVoteContentLike(String value) {
            addCriterion("VOTE_CONTENT like", value, "voteContent");
            return (Criteria) this;
        }

        public Criteria andVoteContentNotLike(String value) {
            addCriterion("VOTE_CONTENT not like", value, "voteContent");
            return (Criteria) this;
        }

        public Criteria andVoteContentIn(List<String> values) {
            addCriterion("VOTE_CONTENT in", values, "voteContent");
            return (Criteria) this;
        }

        public Criteria andVoteContentNotIn(List<String> values) {
            addCriterion("VOTE_CONTENT not in", values, "voteContent");
            return (Criteria) this;
        }

        public Criteria andVoteContentBetween(String value1, String value2) {
            addCriterion("VOTE_CONTENT between", value1, value2, "voteContent");
            return (Criteria) this;
        }

        public Criteria andVoteContentNotBetween(String value1, String value2) {
            addCriterion("VOTE_CONTENT not between", value1, value2, "voteContent");
            return (Criteria) this;
        }

        public Criteria andVoteImgUrlIsNull() {
            addCriterion("VOTE_IMG_URL is null");
            return (Criteria) this;
        }

        public Criteria andVoteImgUrlIsNotNull() {
            addCriterion("VOTE_IMG_URL is not null");
            return (Criteria) this;
        }

        public Criteria andVoteImgUrlEqualTo(String value) {
            addCriterion("VOTE_IMG_URL =", value, "voteImgUrl");
            return (Criteria) this;
        }

        public Criteria andVoteImgUrlNotEqualTo(String value) {
            addCriterion("VOTE_IMG_URL <>", value, "voteImgUrl");
            return (Criteria) this;
        }

        public Criteria andVoteImgUrlGreaterThan(String value) {
            addCriterion("VOTE_IMG_URL >", value, "voteImgUrl");
            return (Criteria) this;
        }

        public Criteria andVoteImgUrlGreaterThanOrEqualTo(String value) {
            addCriterion("VOTE_IMG_URL >=", value, "voteImgUrl");
            return (Criteria) this;
        }

        public Criteria andVoteImgUrlLessThan(String value) {
            addCriterion("VOTE_IMG_URL <", value, "voteImgUrl");
            return (Criteria) this;
        }

        public Criteria andVoteImgUrlLessThanOrEqualTo(String value) {
            addCriterion("VOTE_IMG_URL <=", value, "voteImgUrl");
            return (Criteria) this;
        }

        public Criteria andVoteImgUrlLike(String value) {
            addCriterion("VOTE_IMG_URL like", value, "voteImgUrl");
            return (Criteria) this;
        }

        public Criteria andVoteImgUrlNotLike(String value) {
            addCriterion("VOTE_IMG_URL not like", value, "voteImgUrl");
            return (Criteria) this;
        }

        public Criteria andVoteImgUrlIn(List<String> values) {
            addCriterion("VOTE_IMG_URL in", values, "voteImgUrl");
            return (Criteria) this;
        }

        public Criteria andVoteImgUrlNotIn(List<String> values) {
            addCriterion("VOTE_IMG_URL not in", values, "voteImgUrl");
            return (Criteria) this;
        }

        public Criteria andVoteImgUrlBetween(String value1, String value2) {
            addCriterion("VOTE_IMG_URL between", value1, value2, "voteImgUrl");
            return (Criteria) this;
        }

        public Criteria andVoteImgUrlNotBetween(String value1, String value2) {
            addCriterion("VOTE_IMG_URL not between", value1, value2, "voteImgUrl");
            return (Criteria) this;
        }

        public Criteria andVoteRelevanceDateIsNull() {
            addCriterion("VOTE_RELEVANCE_DATE is null");
            return (Criteria) this;
        }

        public Criteria andVoteRelevanceDateIsNotNull() {
            addCriterion("VOTE_RELEVANCE_DATE is not null");
            return (Criteria) this;
        }

        public Criteria andVoteRelevanceDateEqualTo(Date value) {
            addCriterion("VOTE_RELEVANCE_DATE =", value, "voteRelevanceDate");
            return (Criteria) this;
        }

        public Criteria andVoteRelevanceDateNotEqualTo(Date value) {
            addCriterion("VOTE_RELEVANCE_DATE <>", value, "voteRelevanceDate");
            return (Criteria) this;
        }

        public Criteria andVoteRelevanceDateGreaterThan(Date value) {
            addCriterion("VOTE_RELEVANCE_DATE >", value, "voteRelevanceDate");
            return (Criteria) this;
        }

        public Criteria andVoteRelevanceDateGreaterThanOrEqualTo(Date value) {
            addCriterion("VOTE_RELEVANCE_DATE >=", value, "voteRelevanceDate");
            return (Criteria) this;
        }

        public Criteria andVoteRelevanceDateLessThan(Date value) {
            addCriterion("VOTE_RELEVANCE_DATE <", value, "voteRelevanceDate");
            return (Criteria) this;
        }

        public Criteria andVoteRelevanceDateLessThanOrEqualTo(Date value) {
            addCriterion("VOTE_RELEVANCE_DATE <=", value, "voteRelevanceDate");
            return (Criteria) this;
        }

        public Criteria andVoteRelevanceDateIn(List<Date> values) {
            addCriterion("VOTE_RELEVANCE_DATE in", values, "voteRelevanceDate");
            return (Criteria) this;
        }

        public Criteria andVoteRelevanceDateNotIn(List<Date> values) {
            addCriterion("VOTE_RELEVANCE_DATE not in", values, "voteRelevanceDate");
            return (Criteria) this;
        }

        public Criteria andVoteRelevanceDateBetween(Date value1, Date value2) {
            addCriterion("VOTE_RELEVANCE_DATE between", value1, value2, "voteRelevanceDate");
            return (Criteria) this;
        }

        public Criteria andVoteRelevanceDateNotBetween(Date value1, Date value2) {
            addCriterion("VOTE_RELEVANCE_DATE not between", value1, value2, "voteRelevanceDate");
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