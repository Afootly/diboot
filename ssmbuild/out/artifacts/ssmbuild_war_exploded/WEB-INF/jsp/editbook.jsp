<%--
  Created by IntelliJ IDEA.
  User: 30606
  Date: 2021/2/15
  Time: 11:53
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>addbooks</title>
    <link href="https://cdn.staticfile.org/twitter-bootstrap/3.3.7/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
<div class="container">
    <div class="row clearfix">
        <div class="col-md-12 column">
            <div class="page-header">
                <h1>
                    <small>添加书籍</small>
                </h1>
            </div>
        </div>

    </div>
    <div>
        <form action="${pageContext.request.contextPath}/book/book" method="post">
            <input type="hidden" name="_method" value="PUT">
            <input type="hidden" name="bookID" value="${book.bookID}">
            <div class="form-group">
                <label>书籍名称</label>
                <input type="text" class="form-control" name="bookName" value="${book.bookName}" placeholder="name" required>
            </div>
            <div class="form-group">
                <label>书籍数量</label>
                <input type="text" class="form-control" name="bookCounts"  value="${book.bookCounts}" placeholder="quantity" required>
            </div>
            <div class="form-group">
                <label>书籍描述</label>
                <input type="text" class="form-control" name="detail" value="${book.detail}" placeholder="description" required>
            </div>
            <div class="form-group">
                <button type="submit" class="form-control">修改</button>
            </div>
        </form>
    </div>
</div>
</body>
</html>
