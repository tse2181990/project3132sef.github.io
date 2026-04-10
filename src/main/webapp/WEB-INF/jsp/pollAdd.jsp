<%@ include file="/WEB-INF/jsp/base.jspf" %>
<!DOCTYPE html>
<html>
<head>
  <title><spring:message code="poll.add"/></title>
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
      </ul>
    </div>
  </div>
</nav>

<div class="container mt-4">
  <a href="<c:url value='/'/>" class="btn btn-secondary btn-sm mb-3">← <spring:message code="button.back"/></a>
  
  <div class="card">
    <div class="card-header bg-primary text-white">
      <h4 class="mb-0"><spring:message code="poll.add"/></h4>
    </div>
    <div class="card-body">
      <form method="post" action="<c:url value='/poll/create'/>">
        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
        
        <div class="mb-3">
          <label class="form-label"><spring:message code="poll.question"/></label>
          <input type="text" name="question" class="form-control" required 
                 placeholder="<spring:message code='poll.questionPlaceholder'/>"/>
        </div>
        
        <hr/>
        
        <h6><spring:message code="poll.options"/></h6>
        <p class="text-muted"><spring:message code="poll.optionsHint"/></p>
        
        <div class="mb-3">
          <label class="form-label"><spring:message code="poll.option"/> 1</label>
          <input type="text" name="options" class="form-control" required/>
        </div>
        
        <div class="mb-3">
          <label class="form-label"><spring:message code="poll.option"/> 2</label>
          <input type="text" name="options" class="form-control" required/>
        </div>
        
        <div class="mb-3">
          <label class="form-label"><spring:message code="poll.option"/> 3</label>
          <input type="text" name="options" class="form-control" required/>
        </div>
        
        <div class="mb-3">
          <label class="form-label"><spring:message code="poll.option"/> 4</label>
          <input type="text" name="options" class="form-control" required/>
        </div>
        
        <div class="mb-3">
          <label class="form-label"><spring:message code="poll.option"/> 5</label>
          <input type="text" name="options" class="form-control" required/>
        </div>
        
        <div class="d-flex gap-2">
          <button type="submit" class="btn btn-primary"><spring:message code="button.save"/></button>
          <a href="<c:url value='/'/>" class="btn btn-secondary"><spring:message code="button.cancel"/></a>
        </div>
      </form>
    </div>
  </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
