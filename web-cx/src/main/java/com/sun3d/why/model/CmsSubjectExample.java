package com.sun3d.why.model;

import com.sun3d.why.util.Pagination;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

public class CmsSubjectExample  extends Pagination{
    protected String orderByClause;

    protected boolean distinct;

    protected List<Criteria> oredCriteria;

    public CmsSubjectExample() {
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

        public Criteria andSubjectIdIsNull() {
            addCriterion("SUBJECT_ID is null");
            return (Criteria) this;
        }

        public Criteria andSubjectIdIsNotNull() {
            addCriterion("SUBJECT_ID is not null");
            return (Criteria) this;
        }

        public Criteria andSubjectIdEqualTo(String value) {
            addCriterion("SUBJECT_ID =", value, "subjectId");
            return (Criteria) this;
        }

        public Criteria andSubjectIdNotEqualTo(String value) {
            addCriterion("SUBJECT_ID <>", value, "subjectId");
            return (Criteria) this;
        }

        public Criteria andSubjectIdGreaterThan(String value) {
            addCriterion("SUBJECT_ID >", value, "subjectId");
            return (Criteria) this;
        }

        public Criteria andSubjectIdGreaterThanOrEqualTo(String value) {
            addCriterion("SUBJECT_ID >=", value, "subjectId");
            return (Criteria) this;
        }

        public Criteria andSubjectIdLessThan(String value) {
            addCriterion("SUBJECT_ID <", value, "subjectId");
            return (Criteria) this;
        }

        public Criteria andSubjectIdLessThanOrEqualTo(String value) {
            addCriterion("SUBJECT_ID <=", value, "subjectId");
            return (Criteria) this;
        }

        public Criteria andSubjectIdLike(String value) {
            addCriterion("SUBJECT_ID like", value, "subjectId");
            return (Criteria) this;
        }

        public Criteria andSubjectIdNotLike(String value) {
            addCriterion("SUBJECT_ID not like", value, "subjectId");
            return (Criteria) this;
        }

        public Criteria andSubjectIdIn(List<String> values) {
            addCriterion("SUBJECT_ID in", values, "subjectId");
            return (Criteria) this;
        }

        public Criteria andSubjectIdNotIn(List<String> values) {
            addCriterion("SUBJECT_ID not in", values, "subjectId");
            return (Criteria) this;
        }

        public Criteria andSubjectIdBetween(String value1, String value2) {
            addCriterion("SUBJECT_ID between", value1, value2, "subjectId");
            return (Criteria) this;
        }

        public Criteria andSubjectIdNotBetween(String value1, String value2) {
            addCriterion("SUBJECT_ID not between", value1, value2, "subjectId");
            return (Criteria) this;
        }

        public Criteria andSubjectNameIsNull() {
            addCriterion("SUBJECT_NAME is null");
            return (Criteria) this;
        }

        public Criteria andSubjectNameIsNotNull() {
            addCriterion("SUBJECT_NAME is not null");
            return (Criteria) this;
        }

        public Criteria andSubjectNameEqualTo(String value) {
            addCriterion("SUBJECT_NAME =", value, "subjectName");
            return (Criteria) this;
        }

        public Criteria andSubjectNameNotEqualTo(String value) {
            addCriterion("SUBJECT_NAME <>", value, "subjectName");
            return (Criteria) this;
        }

        public Criteria andSubjectNameGreaterThan(String value) {
            addCriterion("SUBJECT_NAME >", value, "subjectName");
            return (Criteria) this;
        }

        public Criteria andSubjectNameGreaterThanOrEqualTo(String value) {
            addCriterion("SUBJECT_NAME >=", value, "subjectName");
            return (Criteria) this;
        }

        public Criteria andSubjectNameLessThan(String value) {
            addCriterion("SUBJECT_NAME <", value, "subjectName");
            return (Criteria) this;
        }

        public Criteria andSubjectNameLessThanOrEqualTo(String value) {
            addCriterion("SUBJECT_NAME <=", value, "subjectName");
            return (Criteria) this;
        }

        public Criteria andSubjectNameLike(String value) {
            addCriterion("SUBJECT_NAME like", value, "subjectName");
            return (Criteria) this;
        }

        public Criteria andSubjectNameNotLike(String value) {
            addCriterion("SUBJECT_NAME not like", value, "subjectName");
            return (Criteria) this;
        }

        public Criteria andSubjectNameIn(List<String> values) {
            addCriterion("SUBJECT_NAME in", values, "subjectName");
            return (Criteria) this;
        }

        public Criteria andSubjectNameNotIn(List<String> values) {
            addCriterion("SUBJECT_NAME not in", values, "subjectName");
            return (Criteria) this;
        }

        public Criteria andSubjectNameBetween(String value1, String value2) {
            addCriterion("SUBJECT_NAME between", value1, value2, "subjectName");
            return (Criteria) this;
        }

        public Criteria andSubjectNameNotBetween(String value1, String value2) {
            addCriterion("SUBJECT_NAME not between", value1, value2, "subjectName");
            return (Criteria) this;
        }

        public Criteria andSubjectSubtitleIsNull() {
            addCriterion("SUBJECT_SUBTITLE is null");
            return (Criteria) this;
        }

        public Criteria andSubjectSubtitleIsNotNull() {
            addCriterion("SUBJECT_SUBTITLE is not null");
            return (Criteria) this;
        }

        public Criteria andSubjectSubtitleEqualTo(String value) {
            addCriterion("SUBJECT_SUBTITLE =", value, "subjectSubtitle");
            return (Criteria) this;
        }

        public Criteria andSubjectSubtitleNotEqualTo(String value) {
            addCriterion("SUBJECT_SUBTITLE <>", value, "subjectSubtitle");
            return (Criteria) this;
        }

        public Criteria andSubjectSubtitleGreaterThan(String value) {
            addCriterion("SUBJECT_SUBTITLE >", value, "subjectSubtitle");
            return (Criteria) this;
        }

        public Criteria andSubjectSubtitleGreaterThanOrEqualTo(String value) {
            addCriterion("SUBJECT_SUBTITLE >=", value, "subjectSubtitle");
            return (Criteria) this;
        }

        public Criteria andSubjectSubtitleLessThan(String value) {
            addCriterion("SUBJECT_SUBTITLE <", value, "subjectSubtitle");
            return (Criteria) this;
        }

        public Criteria andSubjectSubtitleLessThanOrEqualTo(String value) {
            addCriterion("SUBJECT_SUBTITLE <=", value, "subjectSubtitle");
            return (Criteria) this;
        }

        public Criteria andSubjectSubtitleLike(String value) {
            addCriterion("SUBJECT_SUBTITLE like", value, "subjectSubtitle");
            return (Criteria) this;
        }

        public Criteria andSubjectSubtitleNotLike(String value) {
            addCriterion("SUBJECT_SUBTITLE not like", value, "subjectSubtitle");
            return (Criteria) this;
        }

        public Criteria andSubjectSubtitleIn(List<String> values) {
            addCriterion("SUBJECT_SUBTITLE in", values, "subjectSubtitle");
            return (Criteria) this;
        }

        public Criteria andSubjectSubtitleNotIn(List<String> values) {
            addCriterion("SUBJECT_SUBTITLE not in", values, "subjectSubtitle");
            return (Criteria) this;
        }

        public Criteria andSubjectSubtitleBetween(String value1, String value2) {
            addCriterion("SUBJECT_SUBTITLE between", value1, value2, "subjectSubtitle");
            return (Criteria) this;
        }

        public Criteria andSubjectSubtitleNotBetween(String value1, String value2) {
            addCriterion("SUBJECT_SUBTITLE not between", value1, value2, "subjectSubtitle");
            return (Criteria) this;
        }

        public Criteria andSubjectParentIdIsNull() {
            addCriterion("SUBJECT_PARENT_ID is null");
            return (Criteria) this;
        }

        public Criteria andSubjectParentIdIsNotNull() {
            addCriterion("SUBJECT_PARENT_ID is not null");
            return (Criteria) this;
        }

        public Criteria andSubjectParentIdEqualTo(String value) {
            addCriterion("SUBJECT_PARENT_ID =", value, "subjectParentId");
            return (Criteria) this;
        }

        public Criteria andSubjectParentIdNotEqualTo(String value) {
            addCriterion("SUBJECT_PARENT_ID <>", value, "subjectParentId");
            return (Criteria) this;
        }

        public Criteria andSubjectParentIdGreaterThan(String value) {
            addCriterion("SUBJECT_PARENT_ID >", value, "subjectParentId");
            return (Criteria) this;
        }

        public Criteria andSubjectParentIdGreaterThanOrEqualTo(String value) {
            addCriterion("SUBJECT_PARENT_ID >=", value, "subjectParentId");
            return (Criteria) this;
        }

        public Criteria andSubjectParentIdLessThan(String value) {
            addCriterion("SUBJECT_PARENT_ID <", value, "subjectParentId");
            return (Criteria) this;
        }

        public Criteria andSubjectParentIdLessThanOrEqualTo(String value) {
            addCriterion("SUBJECT_PARENT_ID <=", value, "subjectParentId");
            return (Criteria) this;
        }

        public Criteria andSubjectParentIdLike(String value) {
            addCriterion("SUBJECT_PARENT_ID like", value, "subjectParentId");
            return (Criteria) this;
        }

        public Criteria andSubjectParentIdNotLike(String value) {
            addCriterion("SUBJECT_PARENT_ID not like", value, "subjectParentId");
            return (Criteria) this;
        }

        public Criteria andSubjectParentIdIn(List<String> values) {
            addCriterion("SUBJECT_PARENT_ID in", values, "subjectParentId");
            return (Criteria) this;
        }

        public Criteria andSubjectParentIdNotIn(List<String> values) {
            addCriterion("SUBJECT_PARENT_ID not in", values, "subjectParentId");
            return (Criteria) this;
        }

        public Criteria andSubjectParentIdBetween(String value1, String value2) {
            addCriterion("SUBJECT_PARENT_ID between", value1, value2, "subjectParentId");
            return (Criteria) this;
        }

        public Criteria andSubjectParentIdNotBetween(String value1, String value2) {
            addCriterion("SUBJECT_PARENT_ID not between", value1, value2, "subjectParentId");
            return (Criteria) this;
        }

        public Criteria andSubjectTypeIsNull() {
            addCriterion("SUBJECT_TYPE is null");
            return (Criteria) this;
        }

        public Criteria andSubjectTypeIsNotNull() {
            addCriterion("SUBJECT_TYPE is not null");
            return (Criteria) this;
        }

        public Criteria andSubjectTypeEqualTo(Integer value) {
            addCriterion("SUBJECT_TYPE =", value, "subjectType");
            return (Criteria) this;
        }

        public Criteria andSubjectTypeNotEqualTo(Integer value) {
            addCriterion("SUBJECT_TYPE <>", value, "subjectType");
            return (Criteria) this;
        }

        public Criteria andSubjectTypeGreaterThan(Integer value) {
            addCriterion("SUBJECT_TYPE >", value, "subjectType");
            return (Criteria) this;
        }

        public Criteria andSubjectTypeGreaterThanOrEqualTo(Integer value) {
            addCriterion("SUBJECT_TYPE >=", value, "subjectType");
            return (Criteria) this;
        }

        public Criteria andSubjectTypeLessThan(Integer value) {
            addCriterion("SUBJECT_TYPE <", value, "subjectType");
            return (Criteria) this;
        }

        public Criteria andSubjectTypeLessThanOrEqualTo(Integer value) {
            addCriterion("SUBJECT_TYPE <=", value, "subjectType");
            return (Criteria) this;
        }

        public Criteria andSubjectTypeIn(List<Integer> values) {
            addCriterion("SUBJECT_TYPE in", values, "subjectType");
            return (Criteria) this;
        }

        public Criteria andSubjectTypeNotIn(List<Integer> values) {
            addCriterion("SUBJECT_TYPE not in", values, "subjectType");
            return (Criteria) this;
        }

        public Criteria andSubjectTypeBetween(Integer value1, Integer value2) {
            addCriterion("SUBJECT_TYPE between", value1, value2, "subjectType");
            return (Criteria) this;
        }

        public Criteria andSubjectTypeNotBetween(Integer value1, Integer value2) {
            addCriterion("SUBJECT_TYPE not between", value1, value2, "subjectType");
            return (Criteria) this;
        }

        public Criteria andSubjectSortIsNull() {
            addCriterion("SUBJECT_SORT is null");
            return (Criteria) this;
        }

        public Criteria andSubjectSortIsNotNull() {
            addCriterion("SUBJECT_SORT is not null");
            return (Criteria) this;
        }

        public Criteria andSubjectSortEqualTo(Integer value) {
            addCriterion("SUBJECT_SORT =", value, "subjectSort");
            return (Criteria) this;
        }

        public Criteria andSubjectSortNotEqualTo(Integer value) {
            addCriterion("SUBJECT_SORT <>", value, "subjectSort");
            return (Criteria) this;
        }

        public Criteria andSubjectSortGreaterThan(Integer value) {
            addCriterion("SUBJECT_SORT >", value, "subjectSort");
            return (Criteria) this;
        }

        public Criteria andSubjectSortGreaterThanOrEqualTo(Integer value) {
            addCriterion("SUBJECT_SORT >=", value, "subjectSort");
            return (Criteria) this;
        }

        public Criteria andSubjectSortLessThan(Integer value) {
            addCriterion("SUBJECT_SORT <", value, "subjectSort");
            return (Criteria) this;
        }

        public Criteria andSubjectSortLessThanOrEqualTo(Integer value) {
            addCriterion("SUBJECT_SORT <=", value, "subjectSort");
            return (Criteria) this;
        }

        public Criteria andSubjectSortIn(List<Integer> values) {
            addCriterion("SUBJECT_SORT in", values, "subjectSort");
            return (Criteria) this;
        }

        public Criteria andSubjectSortNotIn(List<Integer> values) {
            addCriterion("SUBJECT_SORT not in", values, "subjectSort");
            return (Criteria) this;
        }

        public Criteria andSubjectSortBetween(Integer value1, Integer value2) {
            addCriterion("SUBJECT_SORT between", value1, value2, "subjectSort");
            return (Criteria) this;
        }

        public Criteria andSubjectSortNotBetween(Integer value1, Integer value2) {
            addCriterion("SUBJECT_SORT not between", value1, value2, "subjectSort");
            return (Criteria) this;
        }

        public Criteria andSubjectMemoIsNull() {
            addCriterion("SUBJECT_MEMO is null");
            return (Criteria) this;
        }

        public Criteria andSubjectMemoIsNotNull() {
            addCriterion("SUBJECT_MEMO is not null");
            return (Criteria) this;
        }

        public Criteria andSubjectMemoEqualTo(Integer value) {
            addCriterion("SUBJECT_MEMO =", value, "subjectMemo");
            return (Criteria) this;
        }

        public Criteria andSubjectMemoNotEqualTo(Integer value) {
            addCriterion("SUBJECT_MEMO <>", value, "subjectMemo");
            return (Criteria) this;
        }

        public Criteria andSubjectMemoGreaterThan(Integer value) {
            addCriterion("SUBJECT_MEMO >", value, "subjectMemo");
            return (Criteria) this;
        }

        public Criteria andSubjectMemoGreaterThanOrEqualTo(Integer value) {
            addCriterion("SUBJECT_MEMO >=", value, "subjectMemo");
            return (Criteria) this;
        }

        public Criteria andSubjectMemoLessThan(Integer value) {
            addCriterion("SUBJECT_MEMO <", value, "subjectMemo");
            return (Criteria) this;
        }

        public Criteria andSubjectMemoLessThanOrEqualTo(Integer value) {
            addCriterion("SUBJECT_MEMO <=", value, "subjectMemo");
            return (Criteria) this;
        }

        public Criteria andSubjectMemoIn(List<Integer> values) {
            addCriterion("SUBJECT_MEMO in", values, "subjectMemo");
            return (Criteria) this;
        }

        public Criteria andSubjectMemoNotIn(List<Integer> values) {
            addCriterion("SUBJECT_MEMO not in", values, "subjectMemo");
            return (Criteria) this;
        }

        public Criteria andSubjectMemoBetween(Integer value1, Integer value2) {
            addCriterion("SUBJECT_MEMO between", value1, value2, "subjectMemo");
            return (Criteria) this;
        }

        public Criteria andSubjectMemoNotBetween(Integer value1, Integer value2) {
            addCriterion("SUBJECT_MEMO not between", value1, value2, "subjectMemo");
            return (Criteria) this;
        }

        public Criteria andSubjectIconUrlIsNull() {
            addCriterion("SUBJECT_ICON_URL is null");
            return (Criteria) this;
        }

        public Criteria andSubjectIconUrlIsNotNull() {
            addCriterion("SUBJECT_ICON_URL is not null");
            return (Criteria) this;
        }

        public Criteria andSubjectIconUrlEqualTo(String value) {
            addCriterion("SUBJECT_ICON_URL =", value, "subjectIconUrl");
            return (Criteria) this;
        }

        public Criteria andSubjectIconUrlNotEqualTo(String value) {
            addCriterion("SUBJECT_ICON_URL <>", value, "subjectIconUrl");
            return (Criteria) this;
        }

        public Criteria andSubjectIconUrlGreaterThan(String value) {
            addCriterion("SUBJECT_ICON_URL >", value, "subjectIconUrl");
            return (Criteria) this;
        }

        public Criteria andSubjectIconUrlGreaterThanOrEqualTo(String value) {
            addCriterion("SUBJECT_ICON_URL >=", value, "subjectIconUrl");
            return (Criteria) this;
        }

        public Criteria andSubjectIconUrlLessThan(String value) {
            addCriterion("SUBJECT_ICON_URL <", value, "subjectIconUrl");
            return (Criteria) this;
        }

        public Criteria andSubjectIconUrlLessThanOrEqualTo(String value) {
            addCriterion("SUBJECT_ICON_URL <=", value, "subjectIconUrl");
            return (Criteria) this;
        }

        public Criteria andSubjectIconUrlLike(String value) {
            addCriterion("SUBJECT_ICON_URL like", value, "subjectIconUrl");
            return (Criteria) this;
        }

        public Criteria andSubjectIconUrlNotLike(String value) {
            addCriterion("SUBJECT_ICON_URL not like", value, "subjectIconUrl");
            return (Criteria) this;
        }

        public Criteria andSubjectIconUrlIn(List<String> values) {
            addCriterion("SUBJECT_ICON_URL in", values, "subjectIconUrl");
            return (Criteria) this;
        }

        public Criteria andSubjectIconUrlNotIn(List<String> values) {
            addCriterion("SUBJECT_ICON_URL not in", values, "subjectIconUrl");
            return (Criteria) this;
        }

        public Criteria andSubjectIconUrlBetween(String value1, String value2) {
            addCriterion("SUBJECT_ICON_URL between", value1, value2, "subjectIconUrl");
            return (Criteria) this;
        }

        public Criteria andSubjectIconUrlNotBetween(String value1, String value2) {
            addCriterion("SUBJECT_ICON_URL not between", value1, value2, "subjectIconUrl");
            return (Criteria) this;
        }

        public Criteria andSubjectIsDelIsNull() {
            addCriterion("SUBJECT_IS_DEL is null");
            return (Criteria) this;
        }

        public Criteria andSubjectIsDelIsNotNull() {
            addCriterion("SUBJECT_IS_DEL is not null");
            return (Criteria) this;
        }

        public Criteria andSubjectIsDelEqualTo(Integer value) {
            addCriterion("SUBJECT_IS_DEL =", value, "subjectIsDel");
            return (Criteria) this;
        }

        public Criteria andSubjectIsDelNotEqualTo(Integer value) {
            addCriterion("SUBJECT_IS_DEL <>", value, "subjectIsDel");
            return (Criteria) this;
        }

        public Criteria andSubjectIsDelGreaterThan(Integer value) {
            addCriterion("SUBJECT_IS_DEL >", value, "subjectIsDel");
            return (Criteria) this;
        }

        public Criteria andSubjectIsDelGreaterThanOrEqualTo(Integer value) {
            addCriterion("SUBJECT_IS_DEL >=", value, "subjectIsDel");
            return (Criteria) this;
        }

        public Criteria andSubjectIsDelLessThan(Integer value) {
            addCriterion("SUBJECT_IS_DEL <", value, "subjectIsDel");
            return (Criteria) this;
        }

        public Criteria andSubjectIsDelLessThanOrEqualTo(Integer value) {
            addCriterion("SUBJECT_IS_DEL <=", value, "subjectIsDel");
            return (Criteria) this;
        }

        public Criteria andSubjectIsDelIn(List<Integer> values) {
            addCriterion("SUBJECT_IS_DEL in", values, "subjectIsDel");
            return (Criteria) this;
        }

        public Criteria andSubjectIsDelNotIn(List<Integer> values) {
            addCriterion("SUBJECT_IS_DEL not in", values, "subjectIsDel");
            return (Criteria) this;
        }

        public Criteria andSubjectIsDelBetween(Integer value1, Integer value2) {
            addCriterion("SUBJECT_IS_DEL between", value1, value2, "subjectIsDel");
            return (Criteria) this;
        }

        public Criteria andSubjectIsDelNotBetween(Integer value1, Integer value2) {
            addCriterion("SUBJECT_IS_DEL not between", value1, value2, "subjectIsDel");
            return (Criteria) this;
        }

        public Criteria andSubjectStateIsNull() {
            addCriterion("SUBJECT_STATE is null");
            return (Criteria) this;
        }

        public Criteria andSubjectStateIsNotNull() {
            addCriterion("SUBJECT_STATE is not null");
            return (Criteria) this;
        }

        public Criteria andSubjectStateEqualTo(Integer value) {
            addCriterion("SUBJECT_STATE =", value, "subjectState");
            return (Criteria) this;
        }

        public Criteria andSubjectStateNotEqualTo(Integer value) {
            addCriterion("SUBJECT_STATE <>", value, "subjectState");
            return (Criteria) this;
        }

        public Criteria andSubjectStateGreaterThan(Integer value) {
            addCriterion("SUBJECT_STATE >", value, "subjectState");
            return (Criteria) this;
        }

        public Criteria andSubjectStateGreaterThanOrEqualTo(Integer value) {
            addCriterion("SUBJECT_STATE >=", value, "subjectState");
            return (Criteria) this;
        }

        public Criteria andSubjectStateLessThan(Integer value) {
            addCriterion("SUBJECT_STATE <", value, "subjectState");
            return (Criteria) this;
        }

        public Criteria andSubjectStateLessThanOrEqualTo(Integer value) {
            addCriterion("SUBJECT_STATE <=", value, "subjectState");
            return (Criteria) this;
        }

        public Criteria andSubjectStateIn(List<Integer> values) {
            addCriterion("SUBJECT_STATE in", values, "subjectState");
            return (Criteria) this;
        }

        public Criteria andSubjectStateNotIn(List<Integer> values) {
            addCriterion("SUBJECT_STATE not in", values, "subjectState");
            return (Criteria) this;
        }

        public Criteria andSubjectStateBetween(Integer value1, Integer value2) {
            addCriterion("SUBJECT_STATE between", value1, value2, "subjectState");
            return (Criteria) this;
        }

        public Criteria andSubjectStateNotBetween(Integer value1, Integer value2) {
            addCriterion("SUBJECT_STATE not between", value1, value2, "subjectState");
            return (Criteria) this;
        }

        public Criteria andSubjectCreateTimeIsNull() {
            addCriterion("SUBJECT_CREATE_TIME is null");
            return (Criteria) this;
        }

        public Criteria andSubjectCreateTimeIsNotNull() {
            addCriterion("SUBJECT_CREATE_TIME is not null");
            return (Criteria) this;
        }

        public Criteria andSubjectCreateTimeEqualTo(Date value) {
            addCriterion("SUBJECT_CREATE_TIME =", value, "subjectCreateTime");
            return (Criteria) this;
        }

        public Criteria andSubjectCreateTimeNotEqualTo(Date value) {
            addCriterion("SUBJECT_CREATE_TIME <>", value, "subjectCreateTime");
            return (Criteria) this;
        }

        public Criteria andSubjectCreateTimeGreaterThan(Date value) {
            addCriterion("SUBJECT_CREATE_TIME >", value, "subjectCreateTime");
            return (Criteria) this;
        }

        public Criteria andSubjectCreateTimeGreaterThanOrEqualTo(Date value) {
            addCriterion("SUBJECT_CREATE_TIME >=", value, "subjectCreateTime");
            return (Criteria) this;
        }

        public Criteria andSubjectCreateTimeLessThan(Date value) {
            addCriterion("SUBJECT_CREATE_TIME <", value, "subjectCreateTime");
            return (Criteria) this;
        }

        public Criteria andSubjectCreateTimeLessThanOrEqualTo(Date value) {
            addCriterion("SUBJECT_CREATE_TIME <=", value, "subjectCreateTime");
            return (Criteria) this;
        }

        public Criteria andSubjectCreateTimeIn(List<Date> values) {
            addCriterion("SUBJECT_CREATE_TIME in", values, "subjectCreateTime");
            return (Criteria) this;
        }

        public Criteria andSubjectCreateTimeNotIn(List<Date> values) {
            addCriterion("SUBJECT_CREATE_TIME not in", values, "subjectCreateTime");
            return (Criteria) this;
        }

        public Criteria andSubjectCreateTimeBetween(Date value1, Date value2) {
            addCriterion("SUBJECT_CREATE_TIME between", value1, value2, "subjectCreateTime");
            return (Criteria) this;
        }

        public Criteria andSubjectCreateTimeNotBetween(Date value1, Date value2) {
            addCriterion("SUBJECT_CREATE_TIME not between", value1, value2, "subjectCreateTime");
            return (Criteria) this;
        }

        public Criteria andSubjectUpdateTimeIsNull() {
            addCriterion("SUBJECT_UPDATE_TIME is null");
            return (Criteria) this;
        }

        public Criteria andSubjectUpdateTimeIsNotNull() {
            addCriterion("SUBJECT_UPDATE_TIME is not null");
            return (Criteria) this;
        }

        public Criteria andSubjectUpdateTimeEqualTo(Date value) {
            addCriterion("SUBJECT_UPDATE_TIME =", value, "subjectUpdateTime");
            return (Criteria) this;
        }

        public Criteria andSubjectUpdateTimeNotEqualTo(Date value) {
            addCriterion("SUBJECT_UPDATE_TIME <>", value, "subjectUpdateTime");
            return (Criteria) this;
        }

        public Criteria andSubjectUpdateTimeGreaterThan(Date value) {
            addCriterion("SUBJECT_UPDATE_TIME >", value, "subjectUpdateTime");
            return (Criteria) this;
        }

        public Criteria andSubjectUpdateTimeGreaterThanOrEqualTo(Date value) {
            addCriterion("SUBJECT_UPDATE_TIME >=", value, "subjectUpdateTime");
            return (Criteria) this;
        }

        public Criteria andSubjectUpdateTimeLessThan(Date value) {
            addCriterion("SUBJECT_UPDATE_TIME <", value, "subjectUpdateTime");
            return (Criteria) this;
        }

        public Criteria andSubjectUpdateTimeLessThanOrEqualTo(Date value) {
            addCriterion("SUBJECT_UPDATE_TIME <=", value, "subjectUpdateTime");
            return (Criteria) this;
        }

        public Criteria andSubjectUpdateTimeIn(List<Date> values) {
            addCriterion("SUBJECT_UPDATE_TIME in", values, "subjectUpdateTime");
            return (Criteria) this;
        }

        public Criteria andSubjectUpdateTimeNotIn(List<Date> values) {
            addCriterion("SUBJECT_UPDATE_TIME not in", values, "subjectUpdateTime");
            return (Criteria) this;
        }

        public Criteria andSubjectUpdateTimeBetween(Date value1, Date value2) {
            addCriterion("SUBJECT_UPDATE_TIME between", value1, value2, "subjectUpdateTime");
            return (Criteria) this;
        }

        public Criteria andSubjectUpdateTimeNotBetween(Date value1, Date value2) {
            addCriterion("SUBJECT_UPDATE_TIME not between", value1, value2, "subjectUpdateTime");
            return (Criteria) this;
        }

        public Criteria andSubjectCreateUserIsNull() {
            addCriterion("SUBJECT_CREATE_USER is null");
            return (Criteria) this;
        }

        public Criteria andSubjectCreateUserIsNotNull() {
            addCriterion("SUBJECT_CREATE_USER is not null");
            return (Criteria) this;
        }

        public Criteria andSubjectCreateUserEqualTo(String value) {
            addCriterion("SUBJECT_CREATE_USER =", value, "subjectCreateUser");
            return (Criteria) this;
        }

        public Criteria andSubjectCreateUserNotEqualTo(String value) {
            addCriterion("SUBJECT_CREATE_USER <>", value, "subjectCreateUser");
            return (Criteria) this;
        }

        public Criteria andSubjectCreateUserGreaterThan(String value) {
            addCriterion("SUBJECT_CREATE_USER >", value, "subjectCreateUser");
            return (Criteria) this;
        }

        public Criteria andSubjectCreateUserGreaterThanOrEqualTo(String value) {
            addCriterion("SUBJECT_CREATE_USER >=", value, "subjectCreateUser");
            return (Criteria) this;
        }

        public Criteria andSubjectCreateUserLessThan(String value) {
            addCriterion("SUBJECT_CREATE_USER <", value, "subjectCreateUser");
            return (Criteria) this;
        }

        public Criteria andSubjectCreateUserLessThanOrEqualTo(String value) {
            addCriterion("SUBJECT_CREATE_USER <=", value, "subjectCreateUser");
            return (Criteria) this;
        }

        public Criteria andSubjectCreateUserLike(String value) {
            addCriterion("SUBJECT_CREATE_USER like", value, "subjectCreateUser");
            return (Criteria) this;
        }

        public Criteria andSubjectCreateUserNotLike(String value) {
            addCriterion("SUBJECT_CREATE_USER not like", value, "subjectCreateUser");
            return (Criteria) this;
        }

        public Criteria andSubjectCreateUserIn(List<String> values) {
            addCriterion("SUBJECT_CREATE_USER in", values, "subjectCreateUser");
            return (Criteria) this;
        }

        public Criteria andSubjectCreateUserNotIn(List<String> values) {
            addCriterion("SUBJECT_CREATE_USER not in", values, "subjectCreateUser");
            return (Criteria) this;
        }

        public Criteria andSubjectCreateUserBetween(String value1, String value2) {
            addCriterion("SUBJECT_CREATE_USER between", value1, value2, "subjectCreateUser");
            return (Criteria) this;
        }

        public Criteria andSubjectCreateUserNotBetween(String value1, String value2) {
            addCriterion("SUBJECT_CREATE_USER not between", value1, value2, "subjectCreateUser");
            return (Criteria) this;
        }

        public Criteria andSubjectUpdateUserIsNull() {
            addCriterion("SUBJECT_UPDATE_USER is null");
            return (Criteria) this;
        }

        public Criteria andSubjectUpdateUserIsNotNull() {
            addCriterion("SUBJECT_UPDATE_USER is not null");
            return (Criteria) this;
        }

        public Criteria andSubjectUpdateUserEqualTo(String value) {
            addCriterion("SUBJECT_UPDATE_USER =", value, "subjectUpdateUser");
            return (Criteria) this;
        }

        public Criteria andSubjectUpdateUserNotEqualTo(String value) {
            addCriterion("SUBJECT_UPDATE_USER <>", value, "subjectUpdateUser");
            return (Criteria) this;
        }

        public Criteria andSubjectUpdateUserGreaterThan(String value) {
            addCriterion("SUBJECT_UPDATE_USER >", value, "subjectUpdateUser");
            return (Criteria) this;
        }

        public Criteria andSubjectUpdateUserGreaterThanOrEqualTo(String value) {
            addCriterion("SUBJECT_UPDATE_USER >=", value, "subjectUpdateUser");
            return (Criteria) this;
        }

        public Criteria andSubjectUpdateUserLessThan(String value) {
            addCriterion("SUBJECT_UPDATE_USER <", value, "subjectUpdateUser");
            return (Criteria) this;
        }

        public Criteria andSubjectUpdateUserLessThanOrEqualTo(String value) {
            addCriterion("SUBJECT_UPDATE_USER <=", value, "subjectUpdateUser");
            return (Criteria) this;
        }

        public Criteria andSubjectUpdateUserLike(String value) {
            addCriterion("SUBJECT_UPDATE_USER like", value, "subjectUpdateUser");
            return (Criteria) this;
        }

        public Criteria andSubjectUpdateUserNotLike(String value) {
            addCriterion("SUBJECT_UPDATE_USER not like", value, "subjectUpdateUser");
            return (Criteria) this;
        }

        public Criteria andSubjectUpdateUserIn(List<String> values) {
            addCriterion("SUBJECT_UPDATE_USER in", values, "subjectUpdateUser");
            return (Criteria) this;
        }

        public Criteria andSubjectUpdateUserNotIn(List<String> values) {
            addCriterion("SUBJECT_UPDATE_USER not in", values, "subjectUpdateUser");
            return (Criteria) this;
        }

        public Criteria andSubjectUpdateUserBetween(String value1, String value2) {
            addCriterion("SUBJECT_UPDATE_USER between", value1, value2, "subjectUpdateUser");
            return (Criteria) this;
        }

        public Criteria andSubjectUpdateUserNotBetween(String value1, String value2) {
            addCriterion("SUBJECT_UPDATE_USER not between", value1, value2, "subjectUpdateUser");
            return (Criteria) this;
        }

        public Criteria andSubjectDeptIsNull() {
            addCriterion("SUBJECT_DEPT is null");
            return (Criteria) this;
        }

        public Criteria andSubjectDeptIsNotNull() {
            addCriterion("SUBJECT_DEPT is not null");
            return (Criteria) this;
        }

        public Criteria andSubjectDeptEqualTo(String value) {
            addCriterion("SUBJECT_DEPT =", value, "subjectDept");
            return (Criteria) this;
        }

        public Criteria andSubjectDeptNotEqualTo(String value) {
            addCriterion("SUBJECT_DEPT <>", value, "subjectDept");
            return (Criteria) this;
        }

        public Criteria andSubjectDeptGreaterThan(String value) {
            addCriterion("SUBJECT_DEPT >", value, "subjectDept");
            return (Criteria) this;
        }

        public Criteria andSubjectDeptGreaterThanOrEqualTo(String value) {
            addCriterion("SUBJECT_DEPT >=", value, "subjectDept");
            return (Criteria) this;
        }

        public Criteria andSubjectDeptLessThan(String value) {
            addCriterion("SUBJECT_DEPT <", value, "subjectDept");
            return (Criteria) this;
        }

        public Criteria andSubjectDeptLessThanOrEqualTo(String value) {
            addCriterion("SUBJECT_DEPT <=", value, "subjectDept");
            return (Criteria) this;
        }

        public Criteria andSubjectDeptLike(String value) {
            addCriterion("SUBJECT_DEPT like", value, "subjectDept");
            return (Criteria) this;
        }

        public Criteria andSubjectDeptNotLike(String value) {
            addCriterion("SUBJECT_DEPT not like", value, "subjectDept");
            return (Criteria) this;
        }

        public Criteria andSubjectDeptIn(List<String> values) {
            addCriterion("SUBJECT_DEPT in", values, "subjectDept");
            return (Criteria) this;
        }

        public Criteria andSubjectDeptNotIn(List<String> values) {
            addCriterion("SUBJECT_DEPT not in", values, "subjectDept");
            return (Criteria) this;
        }

        public Criteria andSubjectDeptBetween(String value1, String value2) {
            addCriterion("SUBJECT_DEPT between", value1, value2, "subjectDept");
            return (Criteria) this;
        }

        public Criteria andSubjectDeptNotBetween(String value1, String value2) {
            addCriterion("SUBJECT_DEPT not between", value1, value2, "subjectDept");
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