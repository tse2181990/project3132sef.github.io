<%@ include file="/WEB-INF/jsp/base.jspf" %>
<!DOCTYPE html>
<html>
<head>
  <title><spring:message code="user.list"/></title>
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
          <li class="nav-item">
            <a class="nav-link active" href="<c:url value='/user/list'/>"><spring:message code="nav.users"/></a>
          </li>
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
  <a href="<c:url value='/'/>" class="btn btn-secondary btn-sm mb-3">← <spring:message code="button.back"/></a>
  
  <div class="card">
    <div class="card-header bg-primary text-white d-flex justify-content-between align-items-center">
      <h4 class="mb-0"><spring:message code="user.list"/></h4>
      <a href="<c:url value='/user/create'/>" class="btn btn-light btn-sm">+ <spring:message code="user.add"/></a>
    </div>
    <div class="card-body">
      <table class="table table-striped table-hover">
        <thead class="table-dark">
          <tr>
            <th><spring:message code="user.username"/></th>
            <th><spring:message code="user.fullName"/></th>
            <th><spring:message code="user.email"/></th>
            <th><spring:message code="user.phone"/></th>
            <th><spring:message code="user.role"/></th>
            <th><spring:message code="button.edit"/></th>
          </tr>
        </thead>
        <tbody>
          <c:forEach var="user" items="${courseUsers}">
            <tr>
              <td><c:out value="${user.username}"/></td>
              <td><c:out value="${user.fullName}"/></td>
              <td><c:out value="${user.email}"/></td>
              <td><c:out value="${user.phone}"/></td>
              <td>
                <c:forEach var="role" items="${user.roles}">
                  <c:choose>
                    <c:when test="${role.role == 'ROLE_TEACHER'}">
                      <span class="badge bg-primary"><spring:message code="role.teacher"/></span>
                    </c:when>
                    <c:otherwise>
                      <span class="badge bg-secondary"><spring:message code="role.student"/></span>
                    </c:otherwise>
                  </c:choose>
                </c:forEach>
              </td>
              <td>
                <a href="<c:url value='/user/edit/${user.username}'/>" class="btn btn-warning btn-sm">
                  <spring:message code="button.edit"/>
                </a>
                <a href="<c:url value='/user/delete/${user.username}'/>" 
                   class="btn btn-danger btn-sm"
                   onclick="return confirm(&quot;<spring:message code='user.confirmDelete'/>&quot;)">
                  <spring:message code="button.delete"/>
                </a>
              </td>
            </tr>
          </c:forEach>
        </tbody>
      </table>
    </div>
  </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
