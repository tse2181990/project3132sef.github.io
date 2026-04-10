<%@ include file="/WEB-INF/jsp/base.jspf" %>
<!DOCTYPE html>
<html>
<head>
  <title><spring:message code="commentHistory.title"/></title>
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
            <a class="nav-link active" href="<c:url value='/user/commentHistory'/>"><spring:message code="nav.commentHistory"/></a>
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
      </ul>
    </div>
  </div>
</nav>

<div class="container mt-4">
  <h2>
    <spring:message code="commentHistory.title"/>
    <small class="text-muted">(${username})</small>
  </h2>
  <hr/>

  <c:choose>
    <c:when test="${empty comments}">
      <div class="alert alert-info">
        <spring:message code="commentHistory.noComments"/>
      </div>
    </c:when>
    <c:otherwise>
      <table class="table table-striped table-hover">
        <thead class="table-dark">
          <tr>
            <th>#</th>
            <th><spring:message code="commentHistory.type"/></th>
            <th><spring:message code="commentHistory.relatedTo"/></th>
            <th><spring:message code="commentHistory.content"/></th>
            <th><spring:message code="commentHistory.date"/></th>
          </tr>
        </thead>
        <tbody>
          <c:forEach var="comment" items="${comments}" varStatus="status">
            <tr>
              <td>${status.index + 1}</td>
              <td>
                <c:choose>
                  <c:when test="${comment.lecture != null}">
                    <span class="badge bg-primary">
                      <spring:message code="commentHistory.lecture"/>
                    </span>
                  </c:when>
                  <c:otherwise>
                    <span class="badge bg-success">
                      <spring:message code="commentHistory.poll"/>
                    </span>
                  </c:otherwise>
                </c:choose>
              </td>
              <td>
                <c:choose>
                  <c:when test="${comment.lecture != null}">
                    <a href="<c:url value='/lecture/view/${comment.lecture.id}'/>">
                      <c:out value="${comment.lecture.title}"/>
                    </a>
                  </c:when>
                  <c:otherwise>
                    <a href="<c:url value='/poll/view/${comment.poll.id}'/>">
                      <c:out value="${comment.poll.question}"/>
                    </a>
                  </c:otherwise>
                </c:choose>
              </td>
              <td><c:out value="${comment.content}"/></td>
              <td>
                <fmt:formatDate value="${comment.createdAtAsDate}" pattern="yyyy-MM-dd HH:mm"/>
              </td>
            </tr>
          </c:forEach>
        </tbody>
      </table>
    </c:otherwise>
  </c:choose>

  <a href="<c:url value='/'/>" class="btn btn-secondary mt-2">
    <spring:message code="button.back"/>
  </a>
</div>

<%@ include file="/WEB-INF/jsp/base_footer.jspf" %>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
