<%@ include file="/WEB-INF/jsp/base.jspf" %>
<!DOCTYPE html>
<html>
<head>
  <title><spring:message code="index.title"/></title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">

<nav class="navbar navbar-expand-lg navbar-dark bg-primary">
  <div class="container">
    <a class="navbar-brand" href="<c:url value='/'/>"><spring:message code="index.title"/></a>
    <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
      <span class="navbar-toggler-icon"></span>
    </button>
    <div class="collapse navbar-collapse" id="navbarNav">
      <ul class="navbar-nav me-auto">
        <li class="nav-item">
          <a class="nav-link active" href="<c:url value='/'/>"><spring:message code="nav.home"/></a>
        </li>
      </ul>
      <ul class="navbar-nav ms-auto">
        <%-- Language Switcher --%>
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
          <li class="nav-item">
            <a class="nav-link" href="<c:url value='/register'/>"><spring:message code="nav.register"/></a>
          </li>
        </sec:authorize>
      </ul>
    </div>
  </div>
</nav>

<div class="container mt-4">
  <%-- Course Info --%>
  <div class="jumbotron bg-white p-5 rounded shadow-sm mb-4">
    <h1 class="display-5"><spring:message code="index.welcome"/></h1>
    <p class="lead"><spring:message code="index.description"/></p>
    <hr class="my-4">
    <p><spring:message code="index.courseInfo"/></p>
  </div>

  <div class="row">
    <%-- Lecture List --%>
    <div class="col-md-6">
      <div class="card">
        <div class="card-header bg-primary text-white d-flex justify-content-between align-items-center">
          <h5 class="mb-0"><spring:message code="index.lectures"/></h5>
          <sec:authorize access="hasRole('TEACHER')">
            <a href="<c:url value='/lecture/create'/>" class="btn btn-light btn-sm">+ <spring:message code="lecture.add"/></a>
          </sec:authorize>
        </div>
        <div class="card-body">
          <c:choose>
            <c:when test="${empty lectures}">
              <p class="text-muted"><spring:message code="index.noLectures"/></p>
            </c:when>
            <c:otherwise>
              <div class="list-group">
                <c:forEach var="lecture" items="${lectures}">
                  <div class="list-group-item d-flex justify-content-between align-items-center">
                    <a href="<c:url value='/lecture/view/${lecture.id}'/>" class="text-decoration-none">
                      <c:out value="${lecture.title}"/>
                    </a>
                    <sec:authorize access="hasRole('TEACHER')">
                      <a href="<c:url value='/lecture/delete/${lecture.id}'/>" 
                         class="btn btn-danger btn-sm"
                         onclick="return confirm(&quot;<spring:message code='lecture.confirmDelete'/>&quot;)">
                        <spring:message code="button.delete"/>
                      </a>
                    </sec:authorize>
                  </div>
                </c:forEach>
              </div>
            </c:otherwise>
          </c:choose>
        </div>
      </div>
    </div>

    <%-- Poll List --%>
    <div class="col-md-6">
      <div class="card">
        <div class="card-header bg-info text-white d-flex justify-content-between align-items-center">
          <h5 class="mb-0"><spring:message code="index.polls"/></h5>
          <sec:authorize access="hasRole('TEACHER')">
            <a href="<c:url value='/poll/create'/>" class="btn btn-light btn-sm">+ <spring:message code="poll.add"/></a>
          </sec:authorize>
        </div>
        <div class="card-body">
          <c:choose>
            <c:when test="${empty polls}">
              <p class="text-muted"><spring:message code="index.noPolls"/></p>
            </c:when>
            <c:otherwise>
              <div class="list-group">
                <c:forEach var="poll" items="${polls}">
                  <div class="list-group-item d-flex justify-content-between align-items-center">
                    <a href="<c:url value='/poll/view/${poll.id}'/>" class="text-decoration-none">
                      <c:out value="${poll.question}"/>
                    </a>
                    <sec:authorize access="hasRole('TEACHER')">
                      <a href="<c:url value='/poll/delete/${poll.id}'/>" 
                         class="btn btn-danger btn-sm"
                         onclick="return confirm(&quot;<spring:message code='poll.confirmDelete'/>&quot;)">
                        <spring:message code="button.delete"/>
                      </a>
                    </sec:authorize>
                  </div>
                </c:forEach>
              </div>
            </c:otherwise>
          </c:choose>
        </div>
      </div>
    </div>
  </div>
</div>

<%@ include file="/WEB-INF/jsp/base_footer.jspf" %>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
