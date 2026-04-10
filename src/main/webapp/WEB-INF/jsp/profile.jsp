<%@ include file="/WEB-INF/jsp/base.jspf" %>
<!DOCTYPE html>
<html>
<head>
  <title><spring:message code="nav.profile"/></title>
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
            <a class="nav-link active" href="<c:url value='/profile'/>"><spring:message code="nav.profile"/></a>
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

<div class="container mt-5">
  <div class="row justify-content-center">
    <div class="col-md-6">
      <div class="card">
        <div class="card-header bg-primary text-white text-center">
          <h4 class="mb-0"><spring:message code="nav.profile"/></h4>
        </div>
        <div class="card-body">
          <c:if test="${param.success != null}">
            <div class="alert alert-success">
              <spring:message code="profile.updateSuccess"/>
            </div>
          </c:if>
          
          <form method="post" action="<c:url value='/profile'/>">
            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
            
            <div class="mb-3">
              <label class="form-label"><spring:message code="user.username"/></label>
              <input type="text" class="form-control" value="<c:out value='${user.username}'/>" disabled/>
              <div class="form-text"><spring:message code="profile.usernameCannotChange"/></div>
            </div>
            
            <div class="mb-3">
              <label class="form-label"><spring:message code="user.password"/></label>
              <input type="password" name="password" class="form-control" 
                     placeholder="<spring:message code='profile.passwordPlaceholder'/>"/>
              <div class="form-text"><spring:message code="profile.passwordHint"/></div>
            </div>
            
            <div class="mb-3">
              <label class="form-label"><spring:message code="user.fullName"/></label>
              <input type="text" name="fullName" class="form-control" 
                     value="<c:out value='${user.fullName}'/>" required/>
            </div>
            
            <div class="mb-3">
              <label class="form-label"><spring:message code="user.email"/></label>
              <input type="email" name="email" class="form-control" 
                     value="<c:out value='${user.email}'/>" required/>
            </div>
            
            <div class="mb-3">
              <label class="form-label"><spring:message code="user.phone"/></label>
              <input type="text" name="phone" class="form-control" 
                     value="<c:out value='${user.phone}'/>"/>
            </div>
            
            <div class="mb-3">
              <label class="form-label"><spring:message code="user.role"/></label>
              <div>
                <c:forEach var="role" items="${user.roles}">
                  <span class="badge bg-info">
                    <c:choose>
                      <c:when test="${role.role == 'ROLE_TEACHER'}">
                        <spring:message code="role.teacher"/>
                      </c:when>
                      <c:otherwise>
                        <spring:message code="role.student"/>
                      </c:otherwise>
                    </c:choose>
                  </span>
                </c:forEach>
              </div>
            </div>
            
            <div class="d-flex gap-2">
              <button type="submit" class="btn btn-primary"><spring:message code="user.update"/></button>
              <a href="<c:url value='/'/>" class="btn btn-secondary"><spring:message code="button.back"/></a>
            </div>
          </form>
        </div>
      </div>
    </div>
  </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
