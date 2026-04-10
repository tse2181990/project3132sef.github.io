<%@ include file="/WEB-INF/jsp/base.jspf" %>
<!DOCTYPE html>
<html>
<head>
  <title><spring:message code="user.register"/></title>
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
          <a class="nav-link" href="<c:url value='/login'/>"><spring:message code="nav.login"/></a>
        </li>
      </ul>
    </div>
  </div>
</nav>

<div class="container mt-5">
  <div class="row justify-content-center">
    <div class="col-md-6">
      <div class="card">
        <div class="card-header bg-primary text-white text-center">
          <h4 class="mb-0"><spring:message code="user.register"/></h4>
        </div>
        <div class="card-body">
          <c:if test="${param.error != null}">
            <div class="alert alert-danger">
              <spring:message code="register.error"/>
            </div>
          </c:if>
          
          <form method="post" action="<c:url value='/register'/>">
            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
            
            <div class="mb-3">
              <label class="form-label"><spring:message code="user.username"/></label>
              <input type="text" name="username" class="form-control" required 
                     placeholder="<spring:message code='user.usernamePlaceholder'/>"/>
            </div>
            
            <div class="mb-3">
              <label class="form-label"><spring:message code="user.password"/></label>
              <input type="password" name="password" class="form-control" required 
                     placeholder="<spring:message code='user.passwordPlaceholder'/>"/>
            </div>
            
            <div class="mb-3">
              <label class="form-label"><spring:message code="user.fullName"/></label>
              <input type="text" name="fullName" class="form-control" required 
                     placeholder="<spring:message code='user.fullNamePlaceholder'/>"/>
            </div>
            
            <div class="mb-3">
              <label class="form-label"><spring:message code="user.email"/></label>
              <input type="email" name="email" class="form-control" required 
                     placeholder="<spring:message code='user.emailPlaceholder'/>"/>
            </div>
            
            <div class="mb-3">
              <label class="form-label"><spring:message code="user.phone"/></label>
              <input type="text" name="phone" class="form-control" 
                     placeholder="<spring:message code='user.phonePlaceholder'/>"/>
            </div>
            
            <div class="d-grid gap-2">
              <button type="submit" class="btn btn-primary"><spring:message code="user.register"/></button>
            </div>
          </form>
          
          <hr/>
          
          <div class="text-center">
            <p class="mb-0"><spring:message code="register.hasAccount"/> 
              <a href="<c:url value='/login'/>"><spring:message code="nav.login"/></a>
            </p>
          </div>
        </div>
      </div>
    </div>
  </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
