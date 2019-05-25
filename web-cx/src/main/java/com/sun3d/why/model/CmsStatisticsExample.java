package com.sun3d.why.model;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

public class CmsStatisticsExample {
    protected String orderByClause;

    protected boolean distinct;

    protected List<Criteria> oredCriteria;

    public CmsStatisticsExample() {
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

        public Criteria andSIdIsNull() {
            addCriterion("S_ID is null");
            return (Criteria) this;
        }

        public Criteria andSIdIsNotNull() {
            addCriterion("S_ID is not null");
            return (Criteria) this;
        }

        public Criteria andSIdEqualTo(String value) {
            addCriterion("S_ID =", value, "sId");
            return (Criteria) this;
        }

        public Criteria andSIdNotEqualTo(String value) {
            addCriterion("S_ID <>", value, "sId");
            return (Criteria) this;
        }

        public Criteria andSIdGreaterThan(String value) {
            addCriterion("S_ID >", value, "sId");
            return (Criteria) this;
        }

        public Criteria andSIdGreaterThanOrEqualTo(String value) {
            addCriterion("S_ID >=", value, "sId");
            return (Criteria) this;
        }

        public Criteria andSIdLessThan(String value) {
            addCriterion("S_ID <", value, "sId");
            return (Criteria) this;
        }

        public Criteria andSIdLessThanOrEqualTo(String value) {
            addCriterion("S_ID <=", value, "sId");
            return (Criteria) this;
        }

        public Criteria andSIdLike(String value) {
            addCriterion("S_ID like", value, "sId");
            return (Criteria) this;
        }

        public Criteria andSIdNotLike(String value) {
            addCriterion("S_ID not like", value, "sId");
            return (Criteria) this;
        }

        public Criteria andSIdIn(List<String> values) {
            addCriterion("S_ID in", values, "sId");
            return (Criteria) this;
        }

        public Criteria andSIdNotIn(List<String> values) {
            addCriterion("S_ID not in", values, "sId");
            return (Criteria) this;
        }

        public Criteria andSIdBetween(String value1, String value2) {
            addCriterion("S_ID between", value1, value2, "sId");
            return (Criteria) this;
        }

        public Criteria andSIdNotBetween(String value1, String value2) {
            addCriterion("S_ID not between", value1, value2, "sId");
            return (Criteria) this;
        }

        public Criteria andSTypeIsNull() {
            addCriterion("S_TYPE is null");
            return (Criteria) this;
        }

        public Criteria andSTypeIsNotNull() {
            addCriterion("S_TYPE is not null");
            return (Criteria) this;
        }

        public Criteria andSTypeEqualTo(Integer value) {
            addCriterion("S_TYPE =", value, "sType");
            return (Criteria) this;
        }

        public Criteria andSTypeNotEqualTo(Integer value) {
            addCriterion("S_TYPE <>", value, "sType");
            return (Criteria) this;
        }

        public Criteria andSTypeGreaterThan(Integer value) {
            addCriterion("S_TYPE >", value, "sType");
            return (Criteria) this;
        }

        public Criteria andSTypeGreaterThanOrEqualTo(Integer value) {
            addCriterion("S_TYPE >=", value, "sType");
            return (Criteria) this;
        }

        public Criteria andSTypeLessThan(Integer value) {
            addCriterion("S_TYPE <", value, "sType");
            return (Criteria) this;
        }

        public Criteria andSTypeLessThanOrEqualTo(Integer value) {
            addCriterion("S_TYPE <=", value, "sType");
            return (Criteria) this;
        }

        public Criteria andSTypeIn(List<Integer> values) {
            addCriterion("S_TYPE in", values, "sType");
            return (Criteria) this;
        }

        public Criteria andSTypeNotIn(List<Integer> values) {
            addCriterion("S_TYPE not in", values, "sType");
            return (Criteria) this;
        }

        public Criteria andSTypeBetween(Integer value1, Integer value2) {
            addCriterion("S_TYPE between", value1, value2, "sType");
            return (Criteria) this;
        }

        public Criteria andSTypeNotBetween(Integer value1, Integer value2) {
            addCriterion("S_TYPE not between", value1, value2, "sType");
            return (Criteria) this;
        }

        public Criteria andWeekBrowseCountIsNull() {
            addCriterion("WEEK_BROWSE_COUNT is null");
            return (Criteria) this;
        }

        public Criteria andWeekBrowseCountIsNotNull() {
            addCriterion("WEEK_BROWSE_COUNT is not null");
            return (Criteria) this;
        }

        public Criteria andWeekBrowseCountEqualTo(Integer value) {
            addCriterion("WEEK_BROWSE_COUNT =", value, "weekBrowseCount");
            return (Criteria) this;
        }

        public Criteria andWeekBrowseCountNotEqualTo(Integer value) {
            addCriterion("WEEK_BROWSE_COUNT <>", value, "weekBrowseCount");
            return (Criteria) this;
        }

        public Criteria andWeekBrowseCountGreaterThan(Integer value) {
            addCriterion("WEEK_BROWSE_COUNT >", value, "weekBrowseCount");
            return (Criteria) this;
        }

        public Criteria andWeekBrowseCountGreaterThanOrEqualTo(Integer value) {
            addCriterion("WEEK_BROWSE_COUNT >=", value, "weekBrowseCount");
            return (Criteria) this;
        }

        public Criteria andWeekBrowseCountLessThan(Integer value) {
            addCriterion("WEEK_BROWSE_COUNT <", value, "weekBrowseCount");
            return (Criteria) this;
        }

        public Criteria andWeekBrowseCountLessThanOrEqualTo(Integer value) {
            addCriterion("WEEK_BROWSE_COUNT <=", value, "weekBrowseCount");
            return (Criteria) this;
        }

        public Criteria andWeekBrowseCountIn(List<Integer> values) {
            addCriterion("WEEK_BROWSE_COUNT in", values, "weekBrowseCount");
            return (Criteria) this;
        }

        public Criteria andWeekBrowseCountNotIn(List<Integer> values) {
            addCriterion("WEEK_BROWSE_COUNT not in", values, "weekBrowseCount");
            return (Criteria) this;
        }

        public Criteria andWeekBrowseCountBetween(Integer value1, Integer value2) {
            addCriterion("WEEK_BROWSE_COUNT between", value1, value2, "weekBrowseCount");
            return (Criteria) this;
        }

        public Criteria andWeekBrowseCountNotBetween(Integer value1, Integer value2) {
            addCriterion("WEEK_BROWSE_COUNT not between", value1, value2, "weekBrowseCount");
            return (Criteria) this;
        }

        public Criteria andWeekPraiseCountIsNull() {
            addCriterion("WEEK_PRAISE_COUNT is null");
            return (Criteria) this;
        }

        public Criteria andWeekPraiseCountIsNotNull() {
            addCriterion("WEEK_PRAISE_COUNT is not null");
            return (Criteria) this;
        }

        public Criteria andWeekPraiseCountEqualTo(Integer value) {
            addCriterion("WEEK_PRAISE_COUNT =", value, "weekPraiseCount");
            return (Criteria) this;
        }

        public Criteria andWeekPraiseCountNotEqualTo(Integer value) {
            addCriterion("WEEK_PRAISE_COUNT <>", value, "weekPraiseCount");
            return (Criteria) this;
        }

        public Criteria andWeekPraiseCountGreaterThan(Integer value) {
            addCriterion("WEEK_PRAISE_COUNT >", value, "weekPraiseCount");
            return (Criteria) this;
        }

        public Criteria andWeekPraiseCountGreaterThanOrEqualTo(Integer value) {
            addCriterion("WEEK_PRAISE_COUNT >=", value, "weekPraiseCount");
            return (Criteria) this;
        }

        public Criteria andWeekPraiseCountLessThan(Integer value) {
            addCriterion("WEEK_PRAISE_COUNT <", value, "weekPraiseCount");
            return (Criteria) this;
        }

        public Criteria andWeekPraiseCountLessThanOrEqualTo(Integer value) {
            addCriterion("WEEK_PRAISE_COUNT <=", value, "weekPraiseCount");
            return (Criteria) this;
        }

        public Criteria andWeekPraiseCountIn(List<Integer> values) {
            addCriterion("WEEK_PRAISE_COUNT in", values, "weekPraiseCount");
            return (Criteria) this;
        }

        public Criteria andWeekPraiseCountNotIn(List<Integer> values) {
            addCriterion("WEEK_PRAISE_COUNT not in", values, "weekPraiseCount");
            return (Criteria) this;
        }

        public Criteria andWeekPraiseCountBetween(Integer value1, Integer value2) {
            addCriterion("WEEK_PRAISE_COUNT between", value1, value2, "weekPraiseCount");
            return (Criteria) this;
        }

        public Criteria andWeekPraiseCountNotBetween(Integer value1, Integer value2) {
            addCriterion("WEEK_PRAISE_COUNT not between", value1, value2, "weekPraiseCount");
            return (Criteria) this;
        }

        public Criteria andWeekCollectCountIsNull() {
            addCriterion("WEEK_COLLECT_COUNT is null");
            return (Criteria) this;
        }

        public Criteria andWeekCollectCountIsNotNull() {
            addCriterion("WEEK_COLLECT_COUNT is not null");
            return (Criteria) this;
        }

        public Criteria andWeekCollectCountEqualTo(Integer value) {
            addCriterion("WEEK_COLLECT_COUNT =", value, "weekCollectCount");
            return (Criteria) this;
        }

        public Criteria andWeekCollectCountNotEqualTo(Integer value) {
            addCriterion("WEEK_COLLECT_COUNT <>", value, "weekCollectCount");
            return (Criteria) this;
        }

        public Criteria andWeekCollectCountGreaterThan(Integer value) {
            addCriterion("WEEK_COLLECT_COUNT >", value, "weekCollectCount");
            return (Criteria) this;
        }

        public Criteria andWeekCollectCountGreaterThanOrEqualTo(Integer value) {
            addCriterion("WEEK_COLLECT_COUNT >=", value, "weekCollectCount");
            return (Criteria) this;
        }

        public Criteria andWeekCollectCountLessThan(Integer value) {
            addCriterion("WEEK_COLLECT_COUNT <", value, "weekCollectCount");
            return (Criteria) this;
        }

        public Criteria andWeekCollectCountLessThanOrEqualTo(Integer value) {
            addCriterion("WEEK_COLLECT_COUNT <=", value, "weekCollectCount");
            return (Criteria) this;
        }

        public Criteria andWeekCollectCountIn(List<Integer> values) {
            addCriterion("WEEK_COLLECT_COUNT in", values, "weekCollectCount");
            return (Criteria) this;
        }

        public Criteria andWeekCollectCountNotIn(List<Integer> values) {
            addCriterion("WEEK_COLLECT_COUNT not in", values, "weekCollectCount");
            return (Criteria) this;
        }

        public Criteria andWeekCollectCountBetween(Integer value1, Integer value2) {
            addCriterion("WEEK_COLLECT_COUNT between", value1, value2, "weekCollectCount");
            return (Criteria) this;
        }

        public Criteria andWeekCollectCountNotBetween(Integer value1, Integer value2) {
            addCriterion("WEEK_COLLECT_COUNT not between", value1, value2, "weekCollectCount");
            return (Criteria) this;
        }

        public Criteria andWeekShareCountIsNull() {
            addCriterion("WEEK_SHARE_COUNT is null");
            return (Criteria) this;
        }

        public Criteria andWeekShareCountIsNotNull() {
            addCriterion("WEEK_SHARE_COUNT is not null");
            return (Criteria) this;
        }

        public Criteria andWeekShareCountEqualTo(Integer value) {
            addCriterion("WEEK_SHARE_COUNT =", value, "weekShareCount");
            return (Criteria) this;
        }

        public Criteria andWeekShareCountNotEqualTo(Integer value) {
            addCriterion("WEEK_SHARE_COUNT <>", value, "weekShareCount");
            return (Criteria) this;
        }

        public Criteria andWeekShareCountGreaterThan(Integer value) {
            addCriterion("WEEK_SHARE_COUNT >", value, "weekShareCount");
            return (Criteria) this;
        }

        public Criteria andWeekShareCountGreaterThanOrEqualTo(Integer value) {
            addCriterion("WEEK_SHARE_COUNT >=", value, "weekShareCount");
            return (Criteria) this;
        }

        public Criteria andWeekShareCountLessThan(Integer value) {
            addCriterion("WEEK_SHARE_COUNT <", value, "weekShareCount");
            return (Criteria) this;
        }

        public Criteria andWeekShareCountLessThanOrEqualTo(Integer value) {
            addCriterion("WEEK_SHARE_COUNT <=", value, "weekShareCount");
            return (Criteria) this;
        }

        public Criteria andWeekShareCountIn(List<Integer> values) {
            addCriterion("WEEK_SHARE_COUNT in", values, "weekShareCount");
            return (Criteria) this;
        }

        public Criteria andWeekShareCountNotIn(List<Integer> values) {
            addCriterion("WEEK_SHARE_COUNT not in", values, "weekShareCount");
            return (Criteria) this;
        }

        public Criteria andWeekShareCountBetween(Integer value1, Integer value2) {
            addCriterion("WEEK_SHARE_COUNT between", value1, value2, "weekShareCount");
            return (Criteria) this;
        }

        public Criteria andWeekShareCountNotBetween(Integer value1, Integer value2) {
            addCriterion("WEEK_SHARE_COUNT not between", value1, value2, "weekShareCount");
            return (Criteria) this;
        }

        public Criteria andMonthBrowseCountIsNull() {
            addCriterion("MONTH_BROWSE_COUNT is null");
            return (Criteria) this;
        }

        public Criteria andMonthBrowseCountIsNotNull() {
            addCriterion("MONTH_BROWSE_COUNT is not null");
            return (Criteria) this;
        }

        public Criteria andMonthBrowseCountEqualTo(Integer value) {
            addCriterion("MONTH_BROWSE_COUNT =", value, "monthBrowseCount");
            return (Criteria) this;
        }

        public Criteria andMonthBrowseCountNotEqualTo(Integer value) {
            addCriterion("MONTH_BROWSE_COUNT <>", value, "monthBrowseCount");
            return (Criteria) this;
        }

        public Criteria andMonthBrowseCountGreaterThan(Integer value) {
            addCriterion("MONTH_BROWSE_COUNT >", value, "monthBrowseCount");
            return (Criteria) this;
        }

        public Criteria andMonthBrowseCountGreaterThanOrEqualTo(Integer value) {
            addCriterion("MONTH_BROWSE_COUNT >=", value, "monthBrowseCount");
            return (Criteria) this;
        }

        public Criteria andMonthBrowseCountLessThan(Integer value) {
            addCriterion("MONTH_BROWSE_COUNT <", value, "monthBrowseCount");
            return (Criteria) this;
        }

        public Criteria andMonthBrowseCountLessThanOrEqualTo(Integer value) {
            addCriterion("MONTH_BROWSE_COUNT <=", value, "monthBrowseCount");
            return (Criteria) this;
        }

        public Criteria andMonthBrowseCountIn(List<Integer> values) {
            addCriterion("MONTH_BROWSE_COUNT in", values, "monthBrowseCount");
            return (Criteria) this;
        }

        public Criteria andMonthBrowseCountNotIn(List<Integer> values) {
            addCriterion("MONTH_BROWSE_COUNT not in", values, "monthBrowseCount");
            return (Criteria) this;
        }

        public Criteria andMonthBrowseCountBetween(Integer value1, Integer value2) {
            addCriterion("MONTH_BROWSE_COUNT between", value1, value2, "monthBrowseCount");
            return (Criteria) this;
        }

        public Criteria andMonthBrowseCountNotBetween(Integer value1, Integer value2) {
            addCriterion("MONTH_BROWSE_COUNT not between", value1, value2, "monthBrowseCount");
            return (Criteria) this;
        }

        public Criteria andMonthPraiseCountIsNull() {
            addCriterion("MONTH_PRAISE_COUNT is null");
            return (Criteria) this;
        }

        public Criteria andMonthPraiseCountIsNotNull() {
            addCriterion("MONTH_PRAISE_COUNT is not null");
            return (Criteria) this;
        }

        public Criteria andMonthPraiseCountEqualTo(Integer value) {
            addCriterion("MONTH_PRAISE_COUNT =", value, "monthPraiseCount");
            return (Criteria) this;
        }

        public Criteria andMonthPraiseCountNotEqualTo(Integer value) {
            addCriterion("MONTH_PRAISE_COUNT <>", value, "monthPraiseCount");
            return (Criteria) this;
        }

        public Criteria andMonthPraiseCountGreaterThan(Integer value) {
            addCriterion("MONTH_PRAISE_COUNT >", value, "monthPraiseCount");
            return (Criteria) this;
        }

        public Criteria andMonthPraiseCountGreaterThanOrEqualTo(Integer value) {
            addCriterion("MONTH_PRAISE_COUNT >=", value, "monthPraiseCount");
            return (Criteria) this;
        }

        public Criteria andMonthPraiseCountLessThan(Integer value) {
            addCriterion("MONTH_PRAISE_COUNT <", value, "monthPraiseCount");
            return (Criteria) this;
        }

        public Criteria andMonthPraiseCountLessThanOrEqualTo(Integer value) {
            addCriterion("MONTH_PRAISE_COUNT <=", value, "monthPraiseCount");
            return (Criteria) this;
        }

        public Criteria andMonthPraiseCountIn(List<Integer> values) {
            addCriterion("MONTH_PRAISE_COUNT in", values, "monthPraiseCount");
            return (Criteria) this;
        }

        public Criteria andMonthPraiseCountNotIn(List<Integer> values) {
            addCriterion("MONTH_PRAISE_COUNT not in", values, "monthPraiseCount");
            return (Criteria) this;
        }

        public Criteria andMonthPraiseCountBetween(Integer value1, Integer value2) {
            addCriterion("MONTH_PRAISE_COUNT between", value1, value2, "monthPraiseCount");
            return (Criteria) this;
        }

        public Criteria andMonthPraiseCountNotBetween(Integer value1, Integer value2) {
            addCriterion("MONTH_PRAISE_COUNT not between", value1, value2, "monthPraiseCount");
            return (Criteria) this;
        }

        public Criteria andMonthCollectCountIsNull() {
            addCriterion("MONTH_COLLECT_COUNT is null");
            return (Criteria) this;
        }

        public Criteria andMonthCollectCountIsNotNull() {
            addCriterion("MONTH_COLLECT_COUNT is not null");
            return (Criteria) this;
        }

        public Criteria andMonthCollectCountEqualTo(Integer value) {
            addCriterion("MONTH_COLLECT_COUNT =", value, "monthCollectCount");
            return (Criteria) this;
        }

        public Criteria andMonthCollectCountNotEqualTo(Integer value) {
            addCriterion("MONTH_COLLECT_COUNT <>", value, "monthCollectCount");
            return (Criteria) this;
        }

        public Criteria andMonthCollectCountGreaterThan(Integer value) {
            addCriterion("MONTH_COLLECT_COUNT >", value, "monthCollectCount");
            return (Criteria) this;
        }

        public Criteria andMonthCollectCountGreaterThanOrEqualTo(Integer value) {
            addCriterion("MONTH_COLLECT_COUNT >=", value, "monthCollectCount");
            return (Criteria) this;
        }

        public Criteria andMonthCollectCountLessThan(Integer value) {
            addCriterion("MONTH_COLLECT_COUNT <", value, "monthCollectCount");
            return (Criteria) this;
        }

        public Criteria andMonthCollectCountLessThanOrEqualTo(Integer value) {
            addCriterion("MONTH_COLLECT_COUNT <=", value, "monthCollectCount");
            return (Criteria) this;
        }

        public Criteria andMonthCollectCountIn(List<Integer> values) {
            addCriterion("MONTH_COLLECT_COUNT in", values, "monthCollectCount");
            return (Criteria) this;
        }

        public Criteria andMonthCollectCountNotIn(List<Integer> values) {
            addCriterion("MONTH_COLLECT_COUNT not in", values, "monthCollectCount");
            return (Criteria) this;
        }

        public Criteria andMonthCollectCountBetween(Integer value1, Integer value2) {
            addCriterion("MONTH_COLLECT_COUNT between", value1, value2, "monthCollectCount");
            return (Criteria) this;
        }

        public Criteria andMonthCollectCountNotBetween(Integer value1, Integer value2) {
            addCriterion("MONTH_COLLECT_COUNT not between", value1, value2, "monthCollectCount");
            return (Criteria) this;
        }

        public Criteria andMonthShareCountIsNull() {
            addCriterion("MONTH_SHARE_COUNT is null");
            return (Criteria) this;
        }

        public Criteria andMonthShareCountIsNotNull() {
            addCriterion("MONTH_SHARE_COUNT is not null");
            return (Criteria) this;
        }

        public Criteria andMonthShareCountEqualTo(Integer value) {
            addCriterion("MONTH_SHARE_COUNT =", value, "monthShareCount");
            return (Criteria) this;
        }

        public Criteria andMonthShareCountNotEqualTo(Integer value) {
            addCriterion("MONTH_SHARE_COUNT <>", value, "monthShareCount");
            return (Criteria) this;
        }

        public Criteria andMonthShareCountGreaterThan(Integer value) {
            addCriterion("MONTH_SHARE_COUNT >", value, "monthShareCount");
            return (Criteria) this;
        }

        public Criteria andMonthShareCountGreaterThanOrEqualTo(Integer value) {
            addCriterion("MONTH_SHARE_COUNT >=", value, "monthShareCount");
            return (Criteria) this;
        }

        public Criteria andMonthShareCountLessThan(Integer value) {
            addCriterion("MONTH_SHARE_COUNT <", value, "monthShareCount");
            return (Criteria) this;
        }

        public Criteria andMonthShareCountLessThanOrEqualTo(Integer value) {
            addCriterion("MONTH_SHARE_COUNT <=", value, "monthShareCount");
            return (Criteria) this;
        }

        public Criteria andMonthShareCountIn(List<Integer> values) {
            addCriterion("MONTH_SHARE_COUNT in", values, "monthShareCount");
            return (Criteria) this;
        }

        public Criteria andMonthShareCountNotIn(List<Integer> values) {
            addCriterion("MONTH_SHARE_COUNT not in", values, "monthShareCount");
            return (Criteria) this;
        }

        public Criteria andMonthShareCountBetween(Integer value1, Integer value2) {
            addCriterion("MONTH_SHARE_COUNT between", value1, value2, "monthShareCount");
            return (Criteria) this;
        }

        public Criteria andMonthShareCountNotBetween(Integer value1, Integer value2) {
            addCriterion("MONTH_SHARE_COUNT not between", value1, value2, "monthShareCount");
            return (Criteria) this;
        }

        public Criteria andOquarterBrowseCountIsNull() {
            addCriterion("OQUARTER_BROWSE_COUNT is null");
            return (Criteria) this;
        }

        public Criteria andOquarterBrowseCountIsNotNull() {
            addCriterion("OQUARTER_BROWSE_COUNT is not null");
            return (Criteria) this;
        }

        public Criteria andOquarterBrowseCountEqualTo(Integer value) {
            addCriterion("OQUARTER_BROWSE_COUNT =", value, "oquarterBrowseCount");
            return (Criteria) this;
        }

        public Criteria andOquarterBrowseCountNotEqualTo(Integer value) {
            addCriterion("OQUARTER_BROWSE_COUNT <>", value, "oquarterBrowseCount");
            return (Criteria) this;
        }

        public Criteria andOquarterBrowseCountGreaterThan(Integer value) {
            addCriterion("OQUARTER_BROWSE_COUNT >", value, "oquarterBrowseCount");
            return (Criteria) this;
        }

        public Criteria andOquarterBrowseCountGreaterThanOrEqualTo(Integer value) {
            addCriterion("OQUARTER_BROWSE_COUNT >=", value, "oquarterBrowseCount");
            return (Criteria) this;
        }

        public Criteria andOquarterBrowseCountLessThan(Integer value) {
            addCriterion("OQUARTER_BROWSE_COUNT <", value, "oquarterBrowseCount");
            return (Criteria) this;
        }

        public Criteria andOquarterBrowseCountLessThanOrEqualTo(Integer value) {
            addCriterion("OQUARTER_BROWSE_COUNT <=", value, "oquarterBrowseCount");
            return (Criteria) this;
        }

        public Criteria andOquarterBrowseCountIn(List<Integer> values) {
            addCriterion("OQUARTER_BROWSE_COUNT in", values, "oquarterBrowseCount");
            return (Criteria) this;
        }

        public Criteria andOquarterBrowseCountNotIn(List<Integer> values) {
            addCriterion("OQUARTER_BROWSE_COUNT not in", values, "oquarterBrowseCount");
            return (Criteria) this;
        }

        public Criteria andOquarterBrowseCountBetween(Integer value1, Integer value2) {
            addCriterion("OQUARTER_BROWSE_COUNT between", value1, value2, "oquarterBrowseCount");
            return (Criteria) this;
        }

        public Criteria andOquarterBrowseCountNotBetween(Integer value1, Integer value2) {
            addCriterion("OQUARTER_BROWSE_COUNT not between", value1, value2, "oquarterBrowseCount");
            return (Criteria) this;
        }

        public Criteria andOquarterPraiseCountIsNull() {
            addCriterion("OQUARTER_PRAISE_COUNT is null");
            return (Criteria) this;
        }

        public Criteria andOquarterPraiseCountIsNotNull() {
            addCriterion("OQUARTER_PRAISE_COUNT is not null");
            return (Criteria) this;
        }

        public Criteria andOquarterPraiseCountEqualTo(Integer value) {
            addCriterion("OQUARTER_PRAISE_COUNT =", value, "oquarterPraiseCount");
            return (Criteria) this;
        }

        public Criteria andOquarterPraiseCountNotEqualTo(Integer value) {
            addCriterion("OQUARTER_PRAISE_COUNT <>", value, "oquarterPraiseCount");
            return (Criteria) this;
        }

        public Criteria andOquarterPraiseCountGreaterThan(Integer value) {
            addCriterion("OQUARTER_PRAISE_COUNT >", value, "oquarterPraiseCount");
            return (Criteria) this;
        }

        public Criteria andOquarterPraiseCountGreaterThanOrEqualTo(Integer value) {
            addCriterion("OQUARTER_PRAISE_COUNT >=", value, "oquarterPraiseCount");
            return (Criteria) this;
        }

        public Criteria andOquarterPraiseCountLessThan(Integer value) {
            addCriterion("OQUARTER_PRAISE_COUNT <", value, "oquarterPraiseCount");
            return (Criteria) this;
        }

        public Criteria andOquarterPraiseCountLessThanOrEqualTo(Integer value) {
            addCriterion("OQUARTER_PRAISE_COUNT <=", value, "oquarterPraiseCount");
            return (Criteria) this;
        }

        public Criteria andOquarterPraiseCountIn(List<Integer> values) {
            addCriterion("OQUARTER_PRAISE_COUNT in", values, "oquarterPraiseCount");
            return (Criteria) this;
        }

        public Criteria andOquarterPraiseCountNotIn(List<Integer> values) {
            addCriterion("OQUARTER_PRAISE_COUNT not in", values, "oquarterPraiseCount");
            return (Criteria) this;
        }

        public Criteria andOquarterPraiseCountBetween(Integer value1, Integer value2) {
            addCriterion("OQUARTER_PRAISE_COUNT between", value1, value2, "oquarterPraiseCount");
            return (Criteria) this;
        }

        public Criteria andOquarterPraiseCountNotBetween(Integer value1, Integer value2) {
            addCriterion("OQUARTER_PRAISE_COUNT not between", value1, value2, "oquarterPraiseCount");
            return (Criteria) this;
        }

        public Criteria andOquarterCollectCountIsNull() {
            addCriterion("OQUARTER_COLLECT_COUNT is null");
            return (Criteria) this;
        }

        public Criteria andOquarterCollectCountIsNotNull() {
            addCriterion("OQUARTER_COLLECT_COUNT is not null");
            return (Criteria) this;
        }

        public Criteria andOquarterCollectCountEqualTo(Integer value) {
            addCriterion("OQUARTER_COLLECT_COUNT =", value, "oquarterCollectCount");
            return (Criteria) this;
        }

        public Criteria andOquarterCollectCountNotEqualTo(Integer value) {
            addCriterion("OQUARTER_COLLECT_COUNT <>", value, "oquarterCollectCount");
            return (Criteria) this;
        }

        public Criteria andOquarterCollectCountGreaterThan(Integer value) {
            addCriterion("OQUARTER_COLLECT_COUNT >", value, "oquarterCollectCount");
            return (Criteria) this;
        }

        public Criteria andOquarterCollectCountGreaterThanOrEqualTo(Integer value) {
            addCriterion("OQUARTER_COLLECT_COUNT >=", value, "oquarterCollectCount");
            return (Criteria) this;
        }

        public Criteria andOquarterCollectCountLessThan(Integer value) {
            addCriterion("OQUARTER_COLLECT_COUNT <", value, "oquarterCollectCount");
            return (Criteria) this;
        }

        public Criteria andOquarterCollectCountLessThanOrEqualTo(Integer value) {
            addCriterion("OQUARTER_COLLECT_COUNT <=", value, "oquarterCollectCount");
            return (Criteria) this;
        }

        public Criteria andOquarterCollectCountIn(List<Integer> values) {
            addCriterion("OQUARTER_COLLECT_COUNT in", values, "oquarterCollectCount");
            return (Criteria) this;
        }

        public Criteria andOquarterCollectCountNotIn(List<Integer> values) {
            addCriterion("OQUARTER_COLLECT_COUNT not in", values, "oquarterCollectCount");
            return (Criteria) this;
        }

        public Criteria andOquarterCollectCountBetween(Integer value1, Integer value2) {
            addCriterion("OQUARTER_COLLECT_COUNT between", value1, value2, "oquarterCollectCount");
            return (Criteria) this;
        }

        public Criteria andOquarterCollectCountNotBetween(Integer value1, Integer value2) {
            addCriterion("OQUARTER_COLLECT_COUNT not between", value1, value2, "oquarterCollectCount");
            return (Criteria) this;
        }

        public Criteria andOquarterShareCountIsNull() {
            addCriterion("OQUARTER_SHARE_COUNT is null");
            return (Criteria) this;
        }

        public Criteria andOquarterShareCountIsNotNull() {
            addCriterion("OQUARTER_SHARE_COUNT is not null");
            return (Criteria) this;
        }

        public Criteria andOquarterShareCountEqualTo(Integer value) {
            addCriterion("OQUARTER_SHARE_COUNT =", value, "oquarterShareCount");
            return (Criteria) this;
        }

        public Criteria andOquarterShareCountNotEqualTo(Integer value) {
            addCriterion("OQUARTER_SHARE_COUNT <>", value, "oquarterShareCount");
            return (Criteria) this;
        }

        public Criteria andOquarterShareCountGreaterThan(Integer value) {
            addCriterion("OQUARTER_SHARE_COUNT >", value, "oquarterShareCount");
            return (Criteria) this;
        }

        public Criteria andOquarterShareCountGreaterThanOrEqualTo(Integer value) {
            addCriterion("OQUARTER_SHARE_COUNT >=", value, "oquarterShareCount");
            return (Criteria) this;
        }

        public Criteria andOquarterShareCountLessThan(Integer value) {
            addCriterion("OQUARTER_SHARE_COUNT <", value, "oquarterShareCount");
            return (Criteria) this;
        }

        public Criteria andOquarterShareCountLessThanOrEqualTo(Integer value) {
            addCriterion("OQUARTER_SHARE_COUNT <=", value, "oquarterShareCount");
            return (Criteria) this;
        }

        public Criteria andOquarterShareCountIn(List<Integer> values) {
            addCriterion("OQUARTER_SHARE_COUNT in", values, "oquarterShareCount");
            return (Criteria) this;
        }

        public Criteria andOquarterShareCountNotIn(List<Integer> values) {
            addCriterion("OQUARTER_SHARE_COUNT not in", values, "oquarterShareCount");
            return (Criteria) this;
        }

        public Criteria andOquarterShareCountBetween(Integer value1, Integer value2) {
            addCriterion("OQUARTER_SHARE_COUNT between", value1, value2, "oquarterShareCount");
            return (Criteria) this;
        }

        public Criteria andOquarterShareCountNotBetween(Integer value1, Integer value2) {
            addCriterion("OQUARTER_SHARE_COUNT not between", value1, value2, "oquarterShareCount");
            return (Criteria) this;
        }

        public Criteria andSquarterBrowseCountIsNull() {
            addCriterion("SQUARTER_BROWSE_COUNT is null");
            return (Criteria) this;
        }

        public Criteria andSquarterBrowseCountIsNotNull() {
            addCriterion("SQUARTER_BROWSE_COUNT is not null");
            return (Criteria) this;
        }

        public Criteria andSquarterBrowseCountEqualTo(Integer value) {
            addCriterion("SQUARTER_BROWSE_COUNT =", value, "squarterBrowseCount");
            return (Criteria) this;
        }

        public Criteria andSquarterBrowseCountNotEqualTo(Integer value) {
            addCriterion("SQUARTER_BROWSE_COUNT <>", value, "squarterBrowseCount");
            return (Criteria) this;
        }

        public Criteria andSquarterBrowseCountGreaterThan(Integer value) {
            addCriterion("SQUARTER_BROWSE_COUNT >", value, "squarterBrowseCount");
            return (Criteria) this;
        }

        public Criteria andSquarterBrowseCountGreaterThanOrEqualTo(Integer value) {
            addCriterion("SQUARTER_BROWSE_COUNT >=", value, "squarterBrowseCount");
            return (Criteria) this;
        }

        public Criteria andSquarterBrowseCountLessThan(Integer value) {
            addCriterion("SQUARTER_BROWSE_COUNT <", value, "squarterBrowseCount");
            return (Criteria) this;
        }

        public Criteria andSquarterBrowseCountLessThanOrEqualTo(Integer value) {
            addCriterion("SQUARTER_BROWSE_COUNT <=", value, "squarterBrowseCount");
            return (Criteria) this;
        }

        public Criteria andSquarterBrowseCountIn(List<Integer> values) {
            addCriterion("SQUARTER_BROWSE_COUNT in", values, "squarterBrowseCount");
            return (Criteria) this;
        }

        public Criteria andSquarterBrowseCountNotIn(List<Integer> values) {
            addCriterion("SQUARTER_BROWSE_COUNT not in", values, "squarterBrowseCount");
            return (Criteria) this;
        }

        public Criteria andSquarterBrowseCountBetween(Integer value1, Integer value2) {
            addCriterion("SQUARTER_BROWSE_COUNT between", value1, value2, "squarterBrowseCount");
            return (Criteria) this;
        }

        public Criteria andSquarterBrowseCountNotBetween(Integer value1, Integer value2) {
            addCriterion("SQUARTER_BROWSE_COUNT not between", value1, value2, "squarterBrowseCount");
            return (Criteria) this;
        }

        public Criteria andSquarterPraiseCountIsNull() {
            addCriterion("SQUARTER_PRAISE_COUNT is null");
            return (Criteria) this;
        }

        public Criteria andSquarterPraiseCountIsNotNull() {
            addCriterion("SQUARTER_PRAISE_COUNT is not null");
            return (Criteria) this;
        }

        public Criteria andSquarterPraiseCountEqualTo(Integer value) {
            addCriterion("SQUARTER_PRAISE_COUNT =", value, "squarterPraiseCount");
            return (Criteria) this;
        }

        public Criteria andSquarterPraiseCountNotEqualTo(Integer value) {
            addCriterion("SQUARTER_PRAISE_COUNT <>", value, "squarterPraiseCount");
            return (Criteria) this;
        }

        public Criteria andSquarterPraiseCountGreaterThan(Integer value) {
            addCriterion("SQUARTER_PRAISE_COUNT >", value, "squarterPraiseCount");
            return (Criteria) this;
        }

        public Criteria andSquarterPraiseCountGreaterThanOrEqualTo(Integer value) {
            addCriterion("SQUARTER_PRAISE_COUNT >=", value, "squarterPraiseCount");
            return (Criteria) this;
        }

        public Criteria andSquarterPraiseCountLessThan(Integer value) {
            addCriterion("SQUARTER_PRAISE_COUNT <", value, "squarterPraiseCount");
            return (Criteria) this;
        }

        public Criteria andSquarterPraiseCountLessThanOrEqualTo(Integer value) {
            addCriterion("SQUARTER_PRAISE_COUNT <=", value, "squarterPraiseCount");
            return (Criteria) this;
        }

        public Criteria andSquarterPraiseCountIn(List<Integer> values) {
            addCriterion("SQUARTER_PRAISE_COUNT in", values, "squarterPraiseCount");
            return (Criteria) this;
        }

        public Criteria andSquarterPraiseCountNotIn(List<Integer> values) {
            addCriterion("SQUARTER_PRAISE_COUNT not in", values, "squarterPraiseCount");
            return (Criteria) this;
        }

        public Criteria andSquarterPraiseCountBetween(Integer value1, Integer value2) {
            addCriterion("SQUARTER_PRAISE_COUNT between", value1, value2, "squarterPraiseCount");
            return (Criteria) this;
        }

        public Criteria andSquarterPraiseCountNotBetween(Integer value1, Integer value2) {
            addCriterion("SQUARTER_PRAISE_COUNT not between", value1, value2, "squarterPraiseCount");
            return (Criteria) this;
        }

        public Criteria andSquarterCollectCountIsNull() {
            addCriterion("SQUARTER_COLLECT_COUNT is null");
            return (Criteria) this;
        }

        public Criteria andSquarterCollectCountIsNotNull() {
            addCriterion("SQUARTER_COLLECT_COUNT is not null");
            return (Criteria) this;
        }

        public Criteria andSquarterCollectCountEqualTo(Integer value) {
            addCriterion("SQUARTER_COLLECT_COUNT =", value, "squarterCollectCount");
            return (Criteria) this;
        }

        public Criteria andSquarterCollectCountNotEqualTo(Integer value) {
            addCriterion("SQUARTER_COLLECT_COUNT <>", value, "squarterCollectCount");
            return (Criteria) this;
        }

        public Criteria andSquarterCollectCountGreaterThan(Integer value) {
            addCriterion("SQUARTER_COLLECT_COUNT >", value, "squarterCollectCount");
            return (Criteria) this;
        }

        public Criteria andSquarterCollectCountGreaterThanOrEqualTo(Integer value) {
            addCriterion("SQUARTER_COLLECT_COUNT >=", value, "squarterCollectCount");
            return (Criteria) this;
        }

        public Criteria andSquarterCollectCountLessThan(Integer value) {
            addCriterion("SQUARTER_COLLECT_COUNT <", value, "squarterCollectCount");
            return (Criteria) this;
        }

        public Criteria andSquarterCollectCountLessThanOrEqualTo(Integer value) {
            addCriterion("SQUARTER_COLLECT_COUNT <=", value, "squarterCollectCount");
            return (Criteria) this;
        }

        public Criteria andSquarterCollectCountIn(List<Integer> values) {
            addCriterion("SQUARTER_COLLECT_COUNT in", values, "squarterCollectCount");
            return (Criteria) this;
        }

        public Criteria andSquarterCollectCountNotIn(List<Integer> values) {
            addCriterion("SQUARTER_COLLECT_COUNT not in", values, "squarterCollectCount");
            return (Criteria) this;
        }

        public Criteria andSquarterCollectCountBetween(Integer value1, Integer value2) {
            addCriterion("SQUARTER_COLLECT_COUNT between", value1, value2, "squarterCollectCount");
            return (Criteria) this;
        }

        public Criteria andSquarterCollectCountNotBetween(Integer value1, Integer value2) {
            addCriterion("SQUARTER_COLLECT_COUNT not between", value1, value2, "squarterCollectCount");
            return (Criteria) this;
        }

        public Criteria andSquarterShareCountIsNull() {
            addCriterion("SQUARTER_SHARE_COUNT is null");
            return (Criteria) this;
        }

        public Criteria andSquarterShareCountIsNotNull() {
            addCriterion("SQUARTER_SHARE_COUNT is not null");
            return (Criteria) this;
        }

        public Criteria andSquarterShareCountEqualTo(Integer value) {
            addCriterion("SQUARTER_SHARE_COUNT =", value, "squarterShareCount");
            return (Criteria) this;
        }

        public Criteria andSquarterShareCountNotEqualTo(Integer value) {
            addCriterion("SQUARTER_SHARE_COUNT <>", value, "squarterShareCount");
            return (Criteria) this;
        }

        public Criteria andSquarterShareCountGreaterThan(Integer value) {
            addCriterion("SQUARTER_SHARE_COUNT >", value, "squarterShareCount");
            return (Criteria) this;
        }

        public Criteria andSquarterShareCountGreaterThanOrEqualTo(Integer value) {
            addCriterion("SQUARTER_SHARE_COUNT >=", value, "squarterShareCount");
            return (Criteria) this;
        }

        public Criteria andSquarterShareCountLessThan(Integer value) {
            addCriterion("SQUARTER_SHARE_COUNT <", value, "squarterShareCount");
            return (Criteria) this;
        }

        public Criteria andSquarterShareCountLessThanOrEqualTo(Integer value) {
            addCriterion("SQUARTER_SHARE_COUNT <=", value, "squarterShareCount");
            return (Criteria) this;
        }

        public Criteria andSquarterShareCountIn(List<Integer> values) {
            addCriterion("SQUARTER_SHARE_COUNT in", values, "squarterShareCount");
            return (Criteria) this;
        }

        public Criteria andSquarterShareCountNotIn(List<Integer> values) {
            addCriterion("SQUARTER_SHARE_COUNT not in", values, "squarterShareCount");
            return (Criteria) this;
        }

        public Criteria andSquarterShareCountBetween(Integer value1, Integer value2) {
            addCriterion("SQUARTER_SHARE_COUNT between", value1, value2, "squarterShareCount");
            return (Criteria) this;
        }

        public Criteria andSquarterShareCountNotBetween(Integer value1, Integer value2) {
            addCriterion("SQUARTER_SHARE_COUNT not between", value1, value2, "squarterShareCount");
            return (Criteria) this;
        }

        public Criteria andTquarterBrowseCountIsNull() {
            addCriterion("TQUARTER_BROWSE_COUNT is null");
            return (Criteria) this;
        }

        public Criteria andTquarterBrowseCountIsNotNull() {
            addCriterion("TQUARTER_BROWSE_COUNT is not null");
            return (Criteria) this;
        }

        public Criteria andTquarterBrowseCountEqualTo(Integer value) {
            addCriterion("TQUARTER_BROWSE_COUNT =", value, "tquarterBrowseCount");
            return (Criteria) this;
        }

        public Criteria andTquarterBrowseCountNotEqualTo(Integer value) {
            addCriterion("TQUARTER_BROWSE_COUNT <>", value, "tquarterBrowseCount");
            return (Criteria) this;
        }

        public Criteria andTquarterBrowseCountGreaterThan(Integer value) {
            addCriterion("TQUARTER_BROWSE_COUNT >", value, "tquarterBrowseCount");
            return (Criteria) this;
        }

        public Criteria andTquarterBrowseCountGreaterThanOrEqualTo(Integer value) {
            addCriterion("TQUARTER_BROWSE_COUNT >=", value, "tquarterBrowseCount");
            return (Criteria) this;
        }

        public Criteria andTquarterBrowseCountLessThan(Integer value) {
            addCriterion("TQUARTER_BROWSE_COUNT <", value, "tquarterBrowseCount");
            return (Criteria) this;
        }

        public Criteria andTquarterBrowseCountLessThanOrEqualTo(Integer value) {
            addCriterion("TQUARTER_BROWSE_COUNT <=", value, "tquarterBrowseCount");
            return (Criteria) this;
        }

        public Criteria andTquarterBrowseCountIn(List<Integer> values) {
            addCriterion("TQUARTER_BROWSE_COUNT in", values, "tquarterBrowseCount");
            return (Criteria) this;
        }

        public Criteria andTquarterBrowseCountNotIn(List<Integer> values) {
            addCriterion("TQUARTER_BROWSE_COUNT not in", values, "tquarterBrowseCount");
            return (Criteria) this;
        }

        public Criteria andTquarterBrowseCountBetween(Integer value1, Integer value2) {
            addCriterion("TQUARTER_BROWSE_COUNT between", value1, value2, "tquarterBrowseCount");
            return (Criteria) this;
        }

        public Criteria andTquarterBrowseCountNotBetween(Integer value1, Integer value2) {
            addCriterion("TQUARTER_BROWSE_COUNT not between", value1, value2, "tquarterBrowseCount");
            return (Criteria) this;
        }

        public Criteria andTquarterPraiseCountIsNull() {
            addCriterion("TQUARTER_PRAISE_COUNT is null");
            return (Criteria) this;
        }

        public Criteria andTquarterPraiseCountIsNotNull() {
            addCriterion("TQUARTER_PRAISE_COUNT is not null");
            return (Criteria) this;
        }

        public Criteria andTquarterPraiseCountEqualTo(Integer value) {
            addCriterion("TQUARTER_PRAISE_COUNT =", value, "tquarterPraiseCount");
            return (Criteria) this;
        }

        public Criteria andTquarterPraiseCountNotEqualTo(Integer value) {
            addCriterion("TQUARTER_PRAISE_COUNT <>", value, "tquarterPraiseCount");
            return (Criteria) this;
        }

        public Criteria andTquarterPraiseCountGreaterThan(Integer value) {
            addCriterion("TQUARTER_PRAISE_COUNT >", value, "tquarterPraiseCount");
            return (Criteria) this;
        }

        public Criteria andTquarterPraiseCountGreaterThanOrEqualTo(Integer value) {
            addCriterion("TQUARTER_PRAISE_COUNT >=", value, "tquarterPraiseCount");
            return (Criteria) this;
        }

        public Criteria andTquarterPraiseCountLessThan(Integer value) {
            addCriterion("TQUARTER_PRAISE_COUNT <", value, "tquarterPraiseCount");
            return (Criteria) this;
        }

        public Criteria andTquarterPraiseCountLessThanOrEqualTo(Integer value) {
            addCriterion("TQUARTER_PRAISE_COUNT <=", value, "tquarterPraiseCount");
            return (Criteria) this;
        }

        public Criteria andTquarterPraiseCountIn(List<Integer> values) {
            addCriterion("TQUARTER_PRAISE_COUNT in", values, "tquarterPraiseCount");
            return (Criteria) this;
        }

        public Criteria andTquarterPraiseCountNotIn(List<Integer> values) {
            addCriterion("TQUARTER_PRAISE_COUNT not in", values, "tquarterPraiseCount");
            return (Criteria) this;
        }

        public Criteria andTquarterPraiseCountBetween(Integer value1, Integer value2) {
            addCriterion("TQUARTER_PRAISE_COUNT between", value1, value2, "tquarterPraiseCount");
            return (Criteria) this;
        }

        public Criteria andTquarterPraiseCountNotBetween(Integer value1, Integer value2) {
            addCriterion("TQUARTER_PRAISE_COUNT not between", value1, value2, "tquarterPraiseCount");
            return (Criteria) this;
        }

        public Criteria andTquarterCollectCountIsNull() {
            addCriterion("TQUARTER_COLLECT_COUNT is null");
            return (Criteria) this;
        }

        public Criteria andTquarterCollectCountIsNotNull() {
            addCriterion("TQUARTER_COLLECT_COUNT is not null");
            return (Criteria) this;
        }

        public Criteria andTquarterCollectCountEqualTo(Integer value) {
            addCriterion("TQUARTER_COLLECT_COUNT =", value, "tquarterCollectCount");
            return (Criteria) this;
        }

        public Criteria andTquarterCollectCountNotEqualTo(Integer value) {
            addCriterion("TQUARTER_COLLECT_COUNT <>", value, "tquarterCollectCount");
            return (Criteria) this;
        }

        public Criteria andTquarterCollectCountGreaterThan(Integer value) {
            addCriterion("TQUARTER_COLLECT_COUNT >", value, "tquarterCollectCount");
            return (Criteria) this;
        }

        public Criteria andTquarterCollectCountGreaterThanOrEqualTo(Integer value) {
            addCriterion("TQUARTER_COLLECT_COUNT >=", value, "tquarterCollectCount");
            return (Criteria) this;
        }

        public Criteria andTquarterCollectCountLessThan(Integer value) {
            addCriterion("TQUARTER_COLLECT_COUNT <", value, "tquarterCollectCount");
            return (Criteria) this;
        }

        public Criteria andTquarterCollectCountLessThanOrEqualTo(Integer value) {
            addCriterion("TQUARTER_COLLECT_COUNT <=", value, "tquarterCollectCount");
            return (Criteria) this;
        }

        public Criteria andTquarterCollectCountIn(List<Integer> values) {
            addCriterion("TQUARTER_COLLECT_COUNT in", values, "tquarterCollectCount");
            return (Criteria) this;
        }

        public Criteria andTquarterCollectCountNotIn(List<Integer> values) {
            addCriterion("TQUARTER_COLLECT_COUNT not in", values, "tquarterCollectCount");
            return (Criteria) this;
        }

        public Criteria andTquarterCollectCountBetween(Integer value1, Integer value2) {
            addCriterion("TQUARTER_COLLECT_COUNT between", value1, value2, "tquarterCollectCount");
            return (Criteria) this;
        }

        public Criteria andTquarterCollectCountNotBetween(Integer value1, Integer value2) {
            addCriterion("TQUARTER_COLLECT_COUNT not between", value1, value2, "tquarterCollectCount");
            return (Criteria) this;
        }

        public Criteria andTquarterShareCountIsNull() {
            addCriterion("TQUARTER_SHARE_COUNT is null");
            return (Criteria) this;
        }

        public Criteria andTquarterShareCountIsNotNull() {
            addCriterion("TQUARTER_SHARE_COUNT is not null");
            return (Criteria) this;
        }

        public Criteria andTquarterShareCountEqualTo(Integer value) {
            addCriterion("TQUARTER_SHARE_COUNT =", value, "tquarterShareCount");
            return (Criteria) this;
        }

        public Criteria andTquarterShareCountNotEqualTo(Integer value) {
            addCriterion("TQUARTER_SHARE_COUNT <>", value, "tquarterShareCount");
            return (Criteria) this;
        }

        public Criteria andTquarterShareCountGreaterThan(Integer value) {
            addCriterion("TQUARTER_SHARE_COUNT >", value, "tquarterShareCount");
            return (Criteria) this;
        }

        public Criteria andTquarterShareCountGreaterThanOrEqualTo(Integer value) {
            addCriterion("TQUARTER_SHARE_COUNT >=", value, "tquarterShareCount");
            return (Criteria) this;
        }

        public Criteria andTquarterShareCountLessThan(Integer value) {
            addCriterion("TQUARTER_SHARE_COUNT <", value, "tquarterShareCount");
            return (Criteria) this;
        }

        public Criteria andTquarterShareCountLessThanOrEqualTo(Integer value) {
            addCriterion("TQUARTER_SHARE_COUNT <=", value, "tquarterShareCount");
            return (Criteria) this;
        }

        public Criteria andTquarterShareCountIn(List<Integer> values) {
            addCriterion("TQUARTER_SHARE_COUNT in", values, "tquarterShareCount");
            return (Criteria) this;
        }

        public Criteria andTquarterShareCountNotIn(List<Integer> values) {
            addCriterion("TQUARTER_SHARE_COUNT not in", values, "tquarterShareCount");
            return (Criteria) this;
        }

        public Criteria andTquarterShareCountBetween(Integer value1, Integer value2) {
            addCriterion("TQUARTER_SHARE_COUNT between", value1, value2, "tquarterShareCount");
            return (Criteria) this;
        }

        public Criteria andTquarterShareCountNotBetween(Integer value1, Integer value2) {
            addCriterion("TQUARTER_SHARE_COUNT not between", value1, value2, "tquarterShareCount");
            return (Criteria) this;
        }

        public Criteria andFquarterBrowseCountIsNull() {
            addCriterion("FQUARTER_BROWSE_COUNT is null");
            return (Criteria) this;
        }

        public Criteria andFquarterBrowseCountIsNotNull() {
            addCriterion("FQUARTER_BROWSE_COUNT is not null");
            return (Criteria) this;
        }

        public Criteria andFquarterBrowseCountEqualTo(Integer value) {
            addCriterion("FQUARTER_BROWSE_COUNT =", value, "fquarterBrowseCount");
            return (Criteria) this;
        }

        public Criteria andFquarterBrowseCountNotEqualTo(Integer value) {
            addCriterion("FQUARTER_BROWSE_COUNT <>", value, "fquarterBrowseCount");
            return (Criteria) this;
        }

        public Criteria andFquarterBrowseCountGreaterThan(Integer value) {
            addCriterion("FQUARTER_BROWSE_COUNT >", value, "fquarterBrowseCount");
            return (Criteria) this;
        }

        public Criteria andFquarterBrowseCountGreaterThanOrEqualTo(Integer value) {
            addCriterion("FQUARTER_BROWSE_COUNT >=", value, "fquarterBrowseCount");
            return (Criteria) this;
        }

        public Criteria andFquarterBrowseCountLessThan(Integer value) {
            addCriterion("FQUARTER_BROWSE_COUNT <", value, "fquarterBrowseCount");
            return (Criteria) this;
        }

        public Criteria andFquarterBrowseCountLessThanOrEqualTo(Integer value) {
            addCriterion("FQUARTER_BROWSE_COUNT <=", value, "fquarterBrowseCount");
            return (Criteria) this;
        }

        public Criteria andFquarterBrowseCountIn(List<Integer> values) {
            addCriterion("FQUARTER_BROWSE_COUNT in", values, "fquarterBrowseCount");
            return (Criteria) this;
        }

        public Criteria andFquarterBrowseCountNotIn(List<Integer> values) {
            addCriterion("FQUARTER_BROWSE_COUNT not in", values, "fquarterBrowseCount");
            return (Criteria) this;
        }

        public Criteria andFquarterBrowseCountBetween(Integer value1, Integer value2) {
            addCriterion("FQUARTER_BROWSE_COUNT between", value1, value2, "fquarterBrowseCount");
            return (Criteria) this;
        }

        public Criteria andFquarterBrowseCountNotBetween(Integer value1, Integer value2) {
            addCriterion("FQUARTER_BROWSE_COUNT not between", value1, value2, "fquarterBrowseCount");
            return (Criteria) this;
        }

        public Criteria andFquarterPraiseCountIsNull() {
            addCriterion("FQUARTER_PRAISE_COUNT is null");
            return (Criteria) this;
        }

        public Criteria andFquarterPraiseCountIsNotNull() {
            addCriterion("FQUARTER_PRAISE_COUNT is not null");
            return (Criteria) this;
        }

        public Criteria andFquarterPraiseCountEqualTo(Integer value) {
            addCriterion("FQUARTER_PRAISE_COUNT =", value, "fquarterPraiseCount");
            return (Criteria) this;
        }

        public Criteria andFquarterPraiseCountNotEqualTo(Integer value) {
            addCriterion("FQUARTER_PRAISE_COUNT <>", value, "fquarterPraiseCount");
            return (Criteria) this;
        }

        public Criteria andFquarterPraiseCountGreaterThan(Integer value) {
            addCriterion("FQUARTER_PRAISE_COUNT >", value, "fquarterPraiseCount");
            return (Criteria) this;
        }

        public Criteria andFquarterPraiseCountGreaterThanOrEqualTo(Integer value) {
            addCriterion("FQUARTER_PRAISE_COUNT >=", value, "fquarterPraiseCount");
            return (Criteria) this;
        }

        public Criteria andFquarterPraiseCountLessThan(Integer value) {
            addCriterion("FQUARTER_PRAISE_COUNT <", value, "fquarterPraiseCount");
            return (Criteria) this;
        }

        public Criteria andFquarterPraiseCountLessThanOrEqualTo(Integer value) {
            addCriterion("FQUARTER_PRAISE_COUNT <=", value, "fquarterPraiseCount");
            return (Criteria) this;
        }

        public Criteria andFquarterPraiseCountIn(List<Integer> values) {
            addCriterion("FQUARTER_PRAISE_COUNT in", values, "fquarterPraiseCount");
            return (Criteria) this;
        }

        public Criteria andFquarterPraiseCountNotIn(List<Integer> values) {
            addCriterion("FQUARTER_PRAISE_COUNT not in", values, "fquarterPraiseCount");
            return (Criteria) this;
        }

        public Criteria andFquarterPraiseCountBetween(Integer value1, Integer value2) {
            addCriterion("FQUARTER_PRAISE_COUNT between", value1, value2, "fquarterPraiseCount");
            return (Criteria) this;
        }

        public Criteria andFquarterPraiseCountNotBetween(Integer value1, Integer value2) {
            addCriterion("FQUARTER_PRAISE_COUNT not between", value1, value2, "fquarterPraiseCount");
            return (Criteria) this;
        }

        public Criteria andFquarterCollectCountIsNull() {
            addCriterion("FQUARTER_COLLECT_COUNT is null");
            return (Criteria) this;
        }

        public Criteria andFquarterCollectCountIsNotNull() {
            addCriterion("FQUARTER_COLLECT_COUNT is not null");
            return (Criteria) this;
        }

        public Criteria andFquarterCollectCountEqualTo(Integer value) {
            addCriterion("FQUARTER_COLLECT_COUNT =", value, "fquarterCollectCount");
            return (Criteria) this;
        }

        public Criteria andFquarterCollectCountNotEqualTo(Integer value) {
            addCriterion("FQUARTER_COLLECT_COUNT <>", value, "fquarterCollectCount");
            return (Criteria) this;
        }

        public Criteria andFquarterCollectCountGreaterThan(Integer value) {
            addCriterion("FQUARTER_COLLECT_COUNT >", value, "fquarterCollectCount");
            return (Criteria) this;
        }

        public Criteria andFquarterCollectCountGreaterThanOrEqualTo(Integer value) {
            addCriterion("FQUARTER_COLLECT_COUNT >=", value, "fquarterCollectCount");
            return (Criteria) this;
        }

        public Criteria andFquarterCollectCountLessThan(Integer value) {
            addCriterion("FQUARTER_COLLECT_COUNT <", value, "fquarterCollectCount");
            return (Criteria) this;
        }

        public Criteria andFquarterCollectCountLessThanOrEqualTo(Integer value) {
            addCriterion("FQUARTER_COLLECT_COUNT <=", value, "fquarterCollectCount");
            return (Criteria) this;
        }

        public Criteria andFquarterCollectCountIn(List<Integer> values) {
            addCriterion("FQUARTER_COLLECT_COUNT in", values, "fquarterCollectCount");
            return (Criteria) this;
        }

        public Criteria andFquarterCollectCountNotIn(List<Integer> values) {
            addCriterion("FQUARTER_COLLECT_COUNT not in", values, "fquarterCollectCount");
            return (Criteria) this;
        }

        public Criteria andFquarterCollectCountBetween(Integer value1, Integer value2) {
            addCriterion("FQUARTER_COLLECT_COUNT between", value1, value2, "fquarterCollectCount");
            return (Criteria) this;
        }

        public Criteria andFquarterCollectCountNotBetween(Integer value1, Integer value2) {
            addCriterion("FQUARTER_COLLECT_COUNT not between", value1, value2, "fquarterCollectCount");
            return (Criteria) this;
        }

        public Criteria andFquarterShareCountIsNull() {
            addCriterion("FQUARTER_SHARE_COUNT is null");
            return (Criteria) this;
        }

        public Criteria andFquarterShareCountIsNotNull() {
            addCriterion("FQUARTER_SHARE_COUNT is not null");
            return (Criteria) this;
        }

        public Criteria andFquarterShareCountEqualTo(Integer value) {
            addCriterion("FQUARTER_SHARE_COUNT =", value, "fquarterShareCount");
            return (Criteria) this;
        }

        public Criteria andFquarterShareCountNotEqualTo(Integer value) {
            addCriterion("FQUARTER_SHARE_COUNT <>", value, "fquarterShareCount");
            return (Criteria) this;
        }

        public Criteria andFquarterShareCountGreaterThan(Integer value) {
            addCriterion("FQUARTER_SHARE_COUNT >", value, "fquarterShareCount");
            return (Criteria) this;
        }

        public Criteria andFquarterShareCountGreaterThanOrEqualTo(Integer value) {
            addCriterion("FQUARTER_SHARE_COUNT >=", value, "fquarterShareCount");
            return (Criteria) this;
        }

        public Criteria andFquarterShareCountLessThan(Integer value) {
            addCriterion("FQUARTER_SHARE_COUNT <", value, "fquarterShareCount");
            return (Criteria) this;
        }

        public Criteria andFquarterShareCountLessThanOrEqualTo(Integer value) {
            addCriterion("FQUARTER_SHARE_COUNT <=", value, "fquarterShareCount");
            return (Criteria) this;
        }

        public Criteria andFquarterShareCountIn(List<Integer> values) {
            addCriterion("FQUARTER_SHARE_COUNT in", values, "fquarterShareCount");
            return (Criteria) this;
        }

        public Criteria andFquarterShareCountNotIn(List<Integer> values) {
            addCriterion("FQUARTER_SHARE_COUNT not in", values, "fquarterShareCount");
            return (Criteria) this;
        }

        public Criteria andFquarterShareCountBetween(Integer value1, Integer value2) {
            addCriterion("FQUARTER_SHARE_COUNT between", value1, value2, "fquarterShareCount");
            return (Criteria) this;
        }

        public Criteria andFquarterShareCountNotBetween(Integer value1, Integer value2) {
            addCriterion("FQUARTER_SHARE_COUNT not between", value1, value2, "fquarterShareCount");
            return (Criteria) this;
        }

        public Criteria andYearBrowseCountIsNull() {
            addCriterion("YEAR_BROWSE_COUNT is null");
            return (Criteria) this;
        }

        public Criteria andYearBrowseCountIsNotNull() {
            addCriterion("YEAR_BROWSE_COUNT is not null");
            return (Criteria) this;
        }

        public Criteria andYearBrowseCountEqualTo(Integer value) {
            addCriterion("YEAR_BROWSE_COUNT =", value, "yearBrowseCount");
            return (Criteria) this;
        }

        public Criteria andYearBrowseCountNotEqualTo(Integer value) {
            addCriterion("YEAR_BROWSE_COUNT <>", value, "yearBrowseCount");
            return (Criteria) this;
        }

        public Criteria andYearBrowseCountGreaterThan(Integer value) {
            addCriterion("YEAR_BROWSE_COUNT >", value, "yearBrowseCount");
            return (Criteria) this;
        }

        public Criteria andYearBrowseCountGreaterThanOrEqualTo(Integer value) {
            addCriterion("YEAR_BROWSE_COUNT >=", value, "yearBrowseCount");
            return (Criteria) this;
        }

        public Criteria andYearBrowseCountLessThan(Integer value) {
            addCriterion("YEAR_BROWSE_COUNT <", value, "yearBrowseCount");
            return (Criteria) this;
        }

        public Criteria andYearBrowseCountLessThanOrEqualTo(Integer value) {
            addCriterion("YEAR_BROWSE_COUNT <=", value, "yearBrowseCount");
            return (Criteria) this;
        }

        public Criteria andYearBrowseCountIn(List<Integer> values) {
            addCriterion("YEAR_BROWSE_COUNT in", values, "yearBrowseCount");
            return (Criteria) this;
        }

        public Criteria andYearBrowseCountNotIn(List<Integer> values) {
            addCriterion("YEAR_BROWSE_COUNT not in", values, "yearBrowseCount");
            return (Criteria) this;
        }

        public Criteria andYearBrowseCountBetween(Integer value1, Integer value2) {
            addCriterion("YEAR_BROWSE_COUNT between", value1, value2, "yearBrowseCount");
            return (Criteria) this;
        }

        public Criteria andYearBrowseCountNotBetween(Integer value1, Integer value2) {
            addCriterion("YEAR_BROWSE_COUNT not between", value1, value2, "yearBrowseCount");
            return (Criteria) this;
        }

        public Criteria andYearPraiseCountIsNull() {
            addCriterion("YEAR_PRAISE_COUNT is null");
            return (Criteria) this;
        }

        public Criteria andYearPraiseCountIsNotNull() {
            addCriterion("YEAR_PRAISE_COUNT is not null");
            return (Criteria) this;
        }

        public Criteria andYearPraiseCountEqualTo(Integer value) {
            addCriterion("YEAR_PRAISE_COUNT =", value, "yearPraiseCount");
            return (Criteria) this;
        }

        public Criteria andYearPraiseCountNotEqualTo(Integer value) {
            addCriterion("YEAR_PRAISE_COUNT <>", value, "yearPraiseCount");
            return (Criteria) this;
        }

        public Criteria andYearPraiseCountGreaterThan(Integer value) {
            addCriterion("YEAR_PRAISE_COUNT >", value, "yearPraiseCount");
            return (Criteria) this;
        }

        public Criteria andYearPraiseCountGreaterThanOrEqualTo(Integer value) {
            addCriterion("YEAR_PRAISE_COUNT >=", value, "yearPraiseCount");
            return (Criteria) this;
        }

        public Criteria andYearPraiseCountLessThan(Integer value) {
            addCriterion("YEAR_PRAISE_COUNT <", value, "yearPraiseCount");
            return (Criteria) this;
        }

        public Criteria andYearPraiseCountLessThanOrEqualTo(Integer value) {
            addCriterion("YEAR_PRAISE_COUNT <=", value, "yearPraiseCount");
            return (Criteria) this;
        }

        public Criteria andYearPraiseCountIn(List<Integer> values) {
            addCriterion("YEAR_PRAISE_COUNT in", values, "yearPraiseCount");
            return (Criteria) this;
        }

        public Criteria andYearPraiseCountNotIn(List<Integer> values) {
            addCriterion("YEAR_PRAISE_COUNT not in", values, "yearPraiseCount");
            return (Criteria) this;
        }

        public Criteria andYearPraiseCountBetween(Integer value1, Integer value2) {
            addCriterion("YEAR_PRAISE_COUNT between", value1, value2, "yearPraiseCount");
            return (Criteria) this;
        }

        public Criteria andYearPraiseCountNotBetween(Integer value1, Integer value2) {
            addCriterion("YEAR_PRAISE_COUNT not between", value1, value2, "yearPraiseCount");
            return (Criteria) this;
        }

        public Criteria andYearCollectCountIsNull() {
            addCriterion("YEAR_COLLECT_COUNT is null");
            return (Criteria) this;
        }

        public Criteria andYearCollectCountIsNotNull() {
            addCriterion("YEAR_COLLECT_COUNT is not null");
            return (Criteria) this;
        }

        public Criteria andYearCollectCountEqualTo(Integer value) {
            addCriterion("YEAR_COLLECT_COUNT =", value, "yearCollectCount");
            return (Criteria) this;
        }

        public Criteria andYearCollectCountNotEqualTo(Integer value) {
            addCriterion("YEAR_COLLECT_COUNT <>", value, "yearCollectCount");
            return (Criteria) this;
        }

        public Criteria andYearCollectCountGreaterThan(Integer value) {
            addCriterion("YEAR_COLLECT_COUNT >", value, "yearCollectCount");
            return (Criteria) this;
        }

        public Criteria andYearCollectCountGreaterThanOrEqualTo(Integer value) {
            addCriterion("YEAR_COLLECT_COUNT >=", value, "yearCollectCount");
            return (Criteria) this;
        }

        public Criteria andYearCollectCountLessThan(Integer value) {
            addCriterion("YEAR_COLLECT_COUNT <", value, "yearCollectCount");
            return (Criteria) this;
        }

        public Criteria andYearCollectCountLessThanOrEqualTo(Integer value) {
            addCriterion("YEAR_COLLECT_COUNT <=", value, "yearCollectCount");
            return (Criteria) this;
        }

        public Criteria andYearCollectCountIn(List<Integer> values) {
            addCriterion("YEAR_COLLECT_COUNT in", values, "yearCollectCount");
            return (Criteria) this;
        }

        public Criteria andYearCollectCountNotIn(List<Integer> values) {
            addCriterion("YEAR_COLLECT_COUNT not in", values, "yearCollectCount");
            return (Criteria) this;
        }

        public Criteria andYearCollectCountBetween(Integer value1, Integer value2) {
            addCriterion("YEAR_COLLECT_COUNT between", value1, value2, "yearCollectCount");
            return (Criteria) this;
        }

        public Criteria andYearCollectCountNotBetween(Integer value1, Integer value2) {
            addCriterion("YEAR_COLLECT_COUNT not between", value1, value2, "yearCollectCount");
            return (Criteria) this;
        }

        public Criteria andYearShareCountIsNull() {
            addCriterion("YEAR_SHARE_COUNT is null");
            return (Criteria) this;
        }

        public Criteria andYearShareCountIsNotNull() {
            addCriterion("YEAR_SHARE_COUNT is not null");
            return (Criteria) this;
        }

        public Criteria andYearShareCountEqualTo(Integer value) {
            addCriterion("YEAR_SHARE_COUNT =", value, "yearShareCount");
            return (Criteria) this;
        }

        public Criteria andYearShareCountNotEqualTo(Integer value) {
            addCriterion("YEAR_SHARE_COUNT <>", value, "yearShareCount");
            return (Criteria) this;
        }

        public Criteria andYearShareCountGreaterThan(Integer value) {
            addCriterion("YEAR_SHARE_COUNT >", value, "yearShareCount");
            return (Criteria) this;
        }

        public Criteria andYearShareCountGreaterThanOrEqualTo(Integer value) {
            addCriterion("YEAR_SHARE_COUNT >=", value, "yearShareCount");
            return (Criteria) this;
        }

        public Criteria andYearShareCountLessThan(Integer value) {
            addCriterion("YEAR_SHARE_COUNT <", value, "yearShareCount");
            return (Criteria) this;
        }

        public Criteria andYearShareCountLessThanOrEqualTo(Integer value) {
            addCriterion("YEAR_SHARE_COUNT <=", value, "yearShareCount");
            return (Criteria) this;
        }

        public Criteria andYearShareCountIn(List<Integer> values) {
            addCriterion("YEAR_SHARE_COUNT in", values, "yearShareCount");
            return (Criteria) this;
        }

        public Criteria andYearShareCountNotIn(List<Integer> values) {
            addCriterion("YEAR_SHARE_COUNT not in", values, "yearShareCount");
            return (Criteria) this;
        }

        public Criteria andYearShareCountBetween(Integer value1, Integer value2) {
            addCriterion("YEAR_SHARE_COUNT between", value1, value2, "yearShareCount");
            return (Criteria) this;
        }

        public Criteria andYearShareCountNotBetween(Integer value1, Integer value2) {
            addCriterion("YEAR_SHARE_COUNT not between", value1, value2, "yearShareCount");
            return (Criteria) this;
        }

        public Criteria andCreateTimeIsNull() {
            addCriterion("CREATE_TIME is null");
            return (Criteria) this;
        }

        public Criteria andCreateTimeIsNotNull() {
            addCriterion("CREATE_TIME is not null");
            return (Criteria) this;
        }

        public Criteria andCreateTimeEqualTo(Date value) {
            addCriterion("CREATE_TIME =", value, "createTime");
            return (Criteria) this;
        }

        public Criteria andCreateTimeNotEqualTo(Date value) {
            addCriterion("CREATE_TIME <>", value, "createTime");
            return (Criteria) this;
        }

        public Criteria andCreateTimeGreaterThan(Date value) {
            addCriterion("CREATE_TIME >", value, "createTime");
            return (Criteria) this;
        }

        public Criteria andCreateTimeGreaterThanOrEqualTo(Date value) {
            addCriterion("CREATE_TIME >=", value, "createTime");
            return (Criteria) this;
        }

        public Criteria andCreateTimeLessThan(Date value) {
            addCriterion("CREATE_TIME <", value, "createTime");
            return (Criteria) this;
        }

        public Criteria andCreateTimeLessThanOrEqualTo(Date value) {
            addCriterion("CREATE_TIME <=", value, "createTime");
            return (Criteria) this;
        }

        public Criteria andCreateTimeIn(List<Date> values) {
            addCriterion("CREATE_TIME in", values, "createTime");
            return (Criteria) this;
        }

        public Criteria andCreateTimeNotIn(List<Date> values) {
            addCriterion("CREATE_TIME not in", values, "createTime");
            return (Criteria) this;
        }

        public Criteria andCreateTimeBetween(Date value1, Date value2) {
            addCriterion("CREATE_TIME between", value1, value2, "createTime");
            return (Criteria) this;
        }

        public Criteria andCreateTimeNotBetween(Date value1, Date value2) {
            addCriterion("CREATE_TIME not between", value1, value2, "createTime");
            return (Criteria) this;
        }

        public Criteria andUpdateTimeIsNull() {
            addCriterion("UPDATE_TIME is null");
            return (Criteria) this;
        }

        public Criteria andUpdateTimeIsNotNull() {
            addCriterion("UPDATE_TIME is not null");
            return (Criteria) this;
        }

        public Criteria andUpdateTimeEqualTo(Date value) {
            addCriterion("UPDATE_TIME =", value, "updateTime");
            return (Criteria) this;
        }

        public Criteria andUpdateTimeNotEqualTo(Date value) {
            addCriterion("UPDATE_TIME <>", value, "updateTime");
            return (Criteria) this;
        }

        public Criteria andUpdateTimeGreaterThan(Date value) {
            addCriterion("UPDATE_TIME >", value, "updateTime");
            return (Criteria) this;
        }

        public Criteria andUpdateTimeGreaterThanOrEqualTo(Date value) {
            addCriterion("UPDATE_TIME >=", value, "updateTime");
            return (Criteria) this;
        }

        public Criteria andUpdateTimeLessThan(Date value) {
            addCriterion("UPDATE_TIME <", value, "updateTime");
            return (Criteria) this;
        }

        public Criteria andUpdateTimeLessThanOrEqualTo(Date value) {
            addCriterion("UPDATE_TIME <=", value, "updateTime");
            return (Criteria) this;
        }

        public Criteria andUpdateTimeIn(List<Date> values) {
            addCriterion("UPDATE_TIME in", values, "updateTime");
            return (Criteria) this;
        }

        public Criteria andUpdateTimeNotIn(List<Date> values) {
            addCriterion("UPDATE_TIME not in", values, "updateTime");
            return (Criteria) this;
        }

        public Criteria andUpdateTimeBetween(Date value1, Date value2) {
            addCriterion("UPDATE_TIME between", value1, value2, "updateTime");
            return (Criteria) this;
        }

        public Criteria andUpdateTimeNotBetween(Date value1, Date value2) {
            addCriterion("UPDATE_TIME not between", value1, value2, "updateTime");
            return (Criteria) this;
        }

        public Criteria andCreateUserIsNull() {
            addCriterion("CREATE_USER is null");
            return (Criteria) this;
        }

        public Criteria andCreateUserIsNotNull() {
            addCriterion("CREATE_USER is not null");
            return (Criteria) this;
        }

        public Criteria andCreateUserEqualTo(String value) {
            addCriterion("CREATE_USER =", value, "createUser");
            return (Criteria) this;
        }

        public Criteria andCreateUserNotEqualTo(String value) {
            addCriterion("CREATE_USER <>", value, "createUser");
            return (Criteria) this;
        }

        public Criteria andCreateUserGreaterThan(String value) {
            addCriterion("CREATE_USER >", value, "createUser");
            return (Criteria) this;
        }

        public Criteria andCreateUserGreaterThanOrEqualTo(String value) {
            addCriterion("CREATE_USER >=", value, "createUser");
            return (Criteria) this;
        }

        public Criteria andCreateUserLessThan(String value) {
            addCriterion("CREATE_USER <", value, "createUser");
            return (Criteria) this;
        }

        public Criteria andCreateUserLessThanOrEqualTo(String value) {
            addCriterion("CREATE_USER <=", value, "createUser");
            return (Criteria) this;
        }

        public Criteria andCreateUserLike(String value) {
            addCriterion("CREATE_USER like", value, "createUser");
            return (Criteria) this;
        }

        public Criteria andCreateUserNotLike(String value) {
            addCriterion("CREATE_USER not like", value, "createUser");
            return (Criteria) this;
        }

        public Criteria andCreateUserIn(List<String> values) {
            addCriterion("CREATE_USER in", values, "createUser");
            return (Criteria) this;
        }

        public Criteria andCreateUserNotIn(List<String> values) {
            addCriterion("CREATE_USER not in", values, "createUser");
            return (Criteria) this;
        }

        public Criteria andCreateUserBetween(String value1, String value2) {
            addCriterion("CREATE_USER between", value1, value2, "createUser");
            return (Criteria) this;
        }

        public Criteria andCreateUserNotBetween(String value1, String value2) {
            addCriterion("CREATE_USER not between", value1, value2, "createUser");
            return (Criteria) this;
        }

        public Criteria andUpdateUserIsNull() {
            addCriterion("UPDATE_USER is null");
            return (Criteria) this;
        }

        public Criteria andUpdateUserIsNotNull() {
            addCriterion("UPDATE_USER is not null");
            return (Criteria) this;
        }

        public Criteria andUpdateUserEqualTo(String value) {
            addCriterion("UPDATE_USER =", value, "updateUser");
            return (Criteria) this;
        }

        public Criteria andUpdateUserNotEqualTo(String value) {
            addCriterion("UPDATE_USER <>", value, "updateUser");
            return (Criteria) this;
        }

        public Criteria andUpdateUserGreaterThan(String value) {
            addCriterion("UPDATE_USER >", value, "updateUser");
            return (Criteria) this;
        }

        public Criteria andUpdateUserGreaterThanOrEqualTo(String value) {
            addCriterion("UPDATE_USER >=", value, "updateUser");
            return (Criteria) this;
        }

        public Criteria andUpdateUserLessThan(String value) {
            addCriterion("UPDATE_USER <", value, "updateUser");
            return (Criteria) this;
        }

        public Criteria andUpdateUserLessThanOrEqualTo(String value) {
            addCriterion("UPDATE_USER <=", value, "updateUser");
            return (Criteria) this;
        }

        public Criteria andUpdateUserLike(String value) {
            addCriterion("UPDATE_USER like", value, "updateUser");
            return (Criteria) this;
        }

        public Criteria andUpdateUserNotLike(String value) {
            addCriterion("UPDATE_USER not like", value, "updateUser");
            return (Criteria) this;
        }

        public Criteria andUpdateUserIn(List<String> values) {
            addCriterion("UPDATE_USER in", values, "updateUser");
            return (Criteria) this;
        }

        public Criteria andUpdateUserNotIn(List<String> values) {
            addCriterion("UPDATE_USER not in", values, "updateUser");
            return (Criteria) this;
        }

        public Criteria andUpdateUserBetween(String value1, String value2) {
            addCriterion("UPDATE_USER between", value1, value2, "updateUser");
            return (Criteria) this;
        }

        public Criteria andUpdateUserNotBetween(String value1, String value2) {
            addCriterion("UPDATE_USER not between", value1, value2, "updateUser");
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