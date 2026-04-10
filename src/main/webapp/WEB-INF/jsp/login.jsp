<%@ include file="/WEB-INF/jsp/base.jspf" %>
<!DOCTYPE html>
<html>
<head>
  <title><spring:message code="user.login"/></title>
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
        <li class="nav-item">
          <a class="nav-link" href="<c:url value='/register'/>"><spring:message code="nav.register"/></a>
        </li>
      </ul>
    </div>
  </div>
</nav>

<div class="container mt-5">
  <div class="row justify-content-center">
    <div class="col-md-4">
      <div class="card">
        <div class="card-header bg-primary text-white text-center">
          <h4 class="mb-0"><spring:message code="user.login"/></h4>
        </div>
        <div class="card-body">
          <c:if test="${param.error != null}">
            <div class="alert alert-danger">
              <spring:message code="login.error"/>
            </div>
          </c:if>
          <c:if test="${param.logout != null}">
            <div class="alert alert-success">
              <spring:message code="login.logoutSuccess"/>
            </div>
          </c:if>
          <c:if test="${param.registered != null}">
            <div class="alert alert-success">
              <spring:message code="login.registeredSuccess"/>
            </div>
          </c:if>
          
          <form method="post" action="<c:url value='/login'/>">
            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
            
            <div class="mb-3">
              <label class="form-label"><spring:message code="user.username"/></label>
              <input type="text" name="username" class="form-control" required autofocus/>
            </div>
            
            <div class="mb-3">
              <label class="form-label"><spring:message code="user.password"/></label>
              <input type="password" name="password" class="form-control" required/>
            </div>
            
            <div class="d-grid gap-2">
              <button type="submit" class="btn btn-primary"><spring:message code="user.login"/></button>
            </div>
          </form>
          
          <hr/>
          
          <div class="text-center">
            <p class="mb-0"><spring:message code="login.noAccount"/> 
              <a href="<c:url value='/register'/>"><spring:message code="nav.register"/></a>
            </p>
          </div>
          
          <hr/>
          
          <div class="alert alert-info">
            <small><strong><spring:message code="login.demoAccounts"/></strong></small><br/>
            <small><spring:message code="login.teacherAccount"/></small><br/>
            <small><spring:message code="login.studentAccount"/></small>
          </div>
        </div>
      </div>
    </div>
  </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
