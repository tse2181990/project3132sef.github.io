<%@ include file="/WEB-INF/jsp/base.jspf" %>
  <!DOCTYPE html>
  <html>

  <head>
    <title>
      <spring:message code="poll.title" /> -
      <c:out value="${poll.question}" />
    </title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
  </head>

  <body class="bg-light">

    <spring:message code="poll.confirmDelete" var="pollConfirmDeleteMsg" />
    <spring:message code="comment.confirmDelete" var="commentConfirmDeleteMsg" />

    <nav class="navbar navbar-expand-lg navbar-dark bg-primary">
      <div class="container">
        <a class="navbar-brand" href="<c:url value='/'/>">
          <spring:message code="index.title" />
        </a>
        <div class="collapse navbar-collapse">
          <ul class="navbar-nav me-auto">
            <li class="nav-item">
              <a class="nav-link" href="<c:url value='/'/>">
                <spring:message code="nav.home" />
              </a>
            </li>
          </ul>
          <ul class="navbar-nav ms-auto">
            <li class="nav-item dropdown">
              <a class="nav-link dropdown-toggle" href="#" role="button" data-bs-toggle="dropdown">
                🌐
                <spring:message code="nav.language" />
              </a>
              <ul class="dropdown-menu dropdown-menu-end">
                <li><a class="dropdown-item" href="?lang=en">🇬🇧 English</a></li>
                <li><a class="dropdown-item" href="?lang=zh_TW">🇭🇰 繁體中文</a></li>
              </ul>
            </li>
            <sec:authorize access="isAuthenticated()">
              <li class="nav-item">
                <a class="nav-link" href="<c:url value='/user/commentHistory'/>">
                  <spring:message code="nav.commentHistory" />
                </a>
              </li>
              <li class="nav-item">
                <a class="nav-link" href="<c:url value='/profile'/>">
                  <spring:message code="nav.profile" />
                </a>
              </li>
              <sec:authorize access="hasRole('TEACHER')">
                <li class="nav-item">
                  <a class="nav-link" href="<c:url value='/user/list'/>">
                    <spring:message code="nav.users" />
                  </a>
                </li>
              </sec:authorize>
              <li class="nav-item">
                <form action="<c:url value='/logout'/>" method="post" class="d-inline">
                  <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                  <button type="submit" class="btn btn-outline-light btn-sm mt-1">
                    <spring:message code="nav.logout" />
                  </button>
                </form>
              </li>
            </sec:authorize>
            <sec:authorize access="!isAuthenticated()">
              <li class="nav-item">
                <a class="nav-link" href="<c:url value='/login'/>">
                  <spring:message code="nav.login" />
                </a>
              </li>
            </sec:authorize>
          </ul>
        </div>
      </div>
    </nav>

    <div class="container mt-4">
      <a href="<c:url value='/'/>" class="btn btn-secondary btn-sm mb-3">←
        <spring:message code="button.back" />
      </a>

      <div class="card">
        <div class="card-header bg-info text-white">
          <h4 class="mb-0">
            <spring:message code="poll.title" />
          </h4>
        </div>
        <div class="card-body">
          <h5 class="card-title">
            <c:out value="${poll.question}" />
          </h5>

          <hr />

          <h6>
            <spring:message code="poll.options" />
          </h6>
          <c:choose>
            <c:when test="${empty poll.options}">
              <p class="text-muted">
                <spring:message code="poll.noOptions" />
              </p>
            </c:when>
            <c:otherwise>
              <div class="list-group">
                <c:forEach var="option" items="${poll.options}">
                  <div class="list-group-item d-flex justify-content-between align-items-center">
                    <div>
                      <c:out value="${option.optionText}" />
                      <c:if test="${userVote != null && userVote.pollOption.id == option.id}">
                        <span class="badge bg-success ms-2">
                          <spring:message code="poll.yourVote" />
                        </span>
                      </c:if>
                    </div>
                    <div class="d-flex align-items-center">
                      <span class="badge bg-primary rounded-pill me-3">
                        <c:out value="${option.voteCount}" />
                        <spring:message code="poll.votes" />
                      </span>
                      <sec:authorize access="isAuthenticated()">
                        <form method="post" action="<c:url value='/poll/${poll.id}/vote'/>" class="d-inline">
                          <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                          <input type="hidden" name="optionId" value="${option.id}" />
                          <c:choose>
                            <c:when test="${userVote != null && userVote.pollOption.id == option.id}">                              
                                <button type="submit" class="btn btn-success btn-sm" disabled>
                                  <spring:message code="poll.voted" />
                                </button>
                            </c:when>
                            <c:otherwise>                              
                                <button type="submit" class="btn btn-primary btn-sm">
                                  <c:choose>
                                    <c:when test="${userVote != null}">
                                      <spring:message code="poll.changeVote" />
                                    </c:when>
                                    <c:otherwise>
                                      <spring:message code="poll.vote" />
                                    </c:otherwise>
                                  </c:choose>
                                </button>
                            </c:otherwise>
                          </c:choose>

                        </form>
                      </sec:authorize>
                    </div>
                  </div>
                </c:forEach>
              </div>
            </c:otherwise>
          </c:choose>

          <sec:authorize access="hasRole('TEACHER')">
            <hr />
            <a href="<c:url value='/poll/delete/${poll.id}'/>" class="btn btn-danger btn-sm"
              onclick="return confirm('${pollConfirmDeleteMsg}')">
            <spring:message code="poll.delete" />
            </a>
          </sec:authorize>
        </div>
      </div>

      <hr />

      <%-- Comments --%>
        <div class="card">
          <div class="card-header bg-secondary text-white">
            <h5 class="mb-0">
              <spring:message code="poll.comments" />
            </h5>
          </div>
          <div class="card-body">
            <c:choose>
              <c:when test="${empty poll.comments}">
                <p class="text-muted">
                  <spring:message code="poll.noComments" />
                </p>
              </c:when>
              <c:otherwise>
                <c:forEach var="comment" items="${poll.comments}">
                  <div class="border rounded p-3 mb-2">
                    <div class="d-flex justify-content-between">
                      <strong>
                        <c:out value="${comment.username}" />
                      </strong>
                      <small class="text-muted">
                        <fmt:formatDate value="${comment.createdAtAsDate}" pattern="yyyy-MM-dd HH:mm" />
                      </small>
                    </div>
                    <p class="mb-1">
                      <c:out value="${comment.content}" />
                    </p>
                    <sec:authorize access="hasRole('TEACHER')">
                      <form method="post" action="<c:url value='/poll/${poll.id}/deleteComment/${comment.id}'/>" class="d-inline">
                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                        <button type="submit" class="btn btn-sm btn-outline-danger"
                          onclick="return confirm('${commentConfirmDeleteMsg}')">
                          <spring:message code="button.delete" />
                        </button>
                      </form>
                    </sec:authorize>
                  </div>
                </c:forEach>
              </c:otherwise>
            </c:choose>

            <%-- Add Comment (Registered users only) --%>
              <sec:authorize access="isAuthenticated()">
                <hr />
                <h6>
                  <spring:message code="poll.addComment" />
                </h6>
                <form method="post" action="<c:url value='/poll/${poll.id}/comment'/>">
                  <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                  <div class="mb-3">
                    <textarea name="content" class="form-control" rows="3" required></textarea>
                  </div>
                  <button type="submit" class="btn btn-primary">
                    <spring:message code="button.submit" />
                  </button>
                </form>
              </sec:authorize>
          </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
  </body>

  </html>