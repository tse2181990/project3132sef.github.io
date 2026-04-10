<%@ include file="/WEB-INF/jsp/base.jspf" %>
<!DOCTYPE html>
<html>
<head>
  <title><spring:message code="lecture.title"/> - <c:out value="${lecture.title}"/></title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">

<nav class="navbar navbar-expand-lg navbar-dark bg-primary">
  <div class="container">
    <a class="navbar-brand" href="<c:url value='/'/>"><spring:message code="index.title"/></a>
    <div class="collapse navbar-collapse">
      <ul class="navbar-nav me-auto">
        <li class="nav-item">
          <a class="nav-link" href="<c:url value='/'/>"><spring:message code="nav.home"/></a>
        </li>
      </ul>
      <ul class="navbar-nav ms-auto">
        <li class="nav-item dropdown">
          <a class="nav-link dropdown-toggle" href="#" role="button" data-bs-toggle="dropdown">
            🌐 <spring:message code="nav.language"/>
          </a>
          <ul class="dropdown-menu dropdown-menu-end">
            <li><a class="dropdown-item" href="?lang=en">🇬🇧 English</a></li>
            <li><a class="dropdown-item" href="?lang=zh_TW">🇭🇰 繁體中文</a></li>
          </ul>
        </li>
        <sec:authorize access="isAuthenticated()">
          <li class="nav-item">
            <a class="nav-link" href="<c:url value='/user/commentHistory'/>"><spring:message code="nav.commentHistory"/></a>
          </li>
          <li class="nav-item">
            <a class="nav-link" href="<c:url value='/profile'/>"><spring:message code="nav.profile"/></a>
          </li>
          <sec:authorize access="hasRole('TEACHER')">
            <li class="nav-item">
              <a class="nav-link" href="<c:url value='/user/list'/>"><spring:message code="nav.users"/></a>
            </li>
          </sec:authorize>
          <li class="nav-item">
            <form action="<c:url value='/logout'/>" method="post" class="d-inline">
              <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
              <button type="submit" class="btn btn-outline-light btn-sm mt-1"><spring:message code="nav.logout"/></button>
            </form>
          </li>
        </sec:authorize>
        <sec:authorize access="!isAuthenticated()">
          <li class="nav-item">
            <a class="nav-link" href="<c:url value='/login'/>"><spring:message code="nav.login"/></a>
          </li>
        </sec:authorize>
      </ul>
    </div>
  </div>
</nav>

<div class="container mt-4">
  <a href="<c:url value='/'/>" class="btn btn-secondary btn-sm mb-3">← <spring:message code="button.back"/></a>
  
  <div class="card">
    <div class="card-header bg-primary text-white">
      <h4 class="mb-0"><c:out value="${lecture.title}"/></h4>
    </div>
    <div class="card-body">
      <h6><spring:message code="lecture.summary"/></h6>
      <p class="card-text"><c:out value="${lecture.summary}"/></p>
      
      <hr/>
      
      <h6><spring:message code="lecture.materials"/></h6>
      <c:choose>
        <c:when test="${empty lecture.attachments}">
          <p class="text-muted"><spring:message code="lecture.noMaterials"/></p>
        </c:when>
        <c:otherwise>
          <div class="list-group">
            <c:forEach var="a" items="${lecture.attachments}">
              <div class="list-group-item d-flex justify-content-between align-items-center">
                <span><c:out value="${a.name}"/></span>
                <div>
                  <a href="<c:url value='/lecture/${lecture.id}/attachment/${a.id}'/>" 
                     class="btn btn-primary btn-sm">
                    <spring:message code="lecture.download"/>
                  </a>
                  <sec:authorize access="hasRole('TEACHER')">
                    <a href="<c:url value='/lecture/${lecture.id}/deleteAttachment/${a.id}'/>" 
                       class="btn btn-danger btn-sm ms-2"
                        onclick="return confirm(&quot;<spring:message code='attachment.confirmDelete'/>&quot;)">
                      <spring:message code="button.delete"/>
                    </a>
                  </sec:authorize>
                </div>
              </div>
            </c:forEach>
          </div>
        </c:otherwise>
      </c:choose>
      
      <sec:authorize access="hasRole('TEACHER')">
        <hr/>
        <div class="d-flex gap-2">
          <a href="<c:url value='/lecture/edit/${lecture.id}'/>" class="btn btn-warning btn-sm">
            <spring:message code="lecture.edit"/>
          </a>
          <a href="<c:url value='/lecture/delete/${lecture.id}'/>" 
             class="btn btn-danger btn-sm"
             onclick="return confirm(&quot;<spring:message code='lecture.confirmDelete'/>&quot;)">
            <spring:message code="lecture.delete"/>
          </a>
        </div>
      </sec:authorize>
    </div>
  </div>
  
  <hr/>
  
  <%-- Comments --%>
  <div class="card">
    <div class="card-header bg-secondary text-white">
      <h5 class="mb-0"><spring:message code="lecture.comments"/></h5>
    </div>
    <div class="card-body">
      <c:choose>
        <c:when test="${empty lecture.comments}">
          <p class="text-muted"><spring:message code="lecture.noComments"/></p>
        </c:when>
        <c:otherwise>
          <c:forEach var="comment" items="${lecture.comments}">
            <div class="border rounded p-3 mb-2">
              <div class="d-flex justify-content-between">
                <strong><c:out value="${comment.username}"/></strong>
                <small class="text-muted"><fmt:formatDate value="${comment.createdAtAsDate}" pattern="yyyy-MM-dd HH:mm"/></small>
              </div>
              <p class="mb-1"><c:out value="${comment.content}"/></p>
              <sec:authorize access="hasRole('TEACHER')">
                <form method="post" action="<c:url value='/lecture/${lecture.id}/deleteComment/${comment.id}'/>" class="d-inline">
                  <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                  <button type="submit" class="btn btn-sm btn-outline-danger"
                          onclick="return confirm(&quot;<spring:message code='comment.confirmDelete'/>&quot;)">
                    <spring:message code="button.delete"/>
                  </button>
                </form>
              </sec:authorize>
            </div>
          </c:forEach>
        </c:otherwise>
      </c:choose>
      
      <%-- Add Comment (Registered users only) --%>
      <sec:authorize access="isAuthenticated()">
        <hr/>
        <h6><spring:message code="lecture.addComment"/></h6>
        <form method="post" action="<c:url value='/lecture/${lecture.id}/comment'/>">
          <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
          <div class="mb-3">
            <textarea name="content" class="form-control" rows="3" required></textarea>
          </div>
          <button type="submit" class="btn btn-primary"><spring:message code="button.submit"/></button>
        </form>
      </sec:authorize>
    </div>
  </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
