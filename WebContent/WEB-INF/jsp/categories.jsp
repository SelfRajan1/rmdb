<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<%-- 	<script src="http://code.jquery.com/jquery-latest.min.js" type="text/javascript"></script> --%>
<%-- <script type="text/javascript" src="<c:url value="/resources/javascripts/script.js" />"></script> --%>
<script type="text/javascript"
	src="<c:url value="/resources/javascripts/jquery-latest.min.js" />"></script>

<script type="text/javascript"
	src="<c:url value="/resources/javascripts/jquery.dataTables.min.js" />"></script>


<script>
	$(document).ready(function() {
		$(".leftmenu li.has-sub>a").click(function() {
			$(this).removeAttr('href');
			var element = $(this).parent('li');
			if (element.hasClass('open')) {
				element.removeClass('open');
				element.find('li').removeClass('open');
				element.find('ul').slideUp();
			} else {
				element.addClass('open');
				element.children('ul').slideDown();
				element.siblings('li').children('ul').slideUp();
				element.siblings('li').removeClass('open');
				element.siblings('li').find('li').removeClass('open');
				element.siblings('li').find('ul').slideUp();
			}
		});
	});

	$(document).ready(function() {
		$(".leftmenu ul ul li a").click(function() {
			$('#abc').empty();
			getMediaDetails($(this).html());
		});
	});

	function getMediaDetails(name) {
		$.ajax({
					type : 'GET',
					url : location.origin+"${pageContext.request.contextPath}"+'/moviesdb/media/getMediaDetails',
					data : {
						'mediaName' : name
					},
					headers : {
						Accept : 'application/json'
					},
					dataType : 'json',

					success : function(data) {
						var tableHolder = '<table id="myTable" class="display"><thead><tr><th>File Name</th><th>Parent Directory</th><th>Subtitles(Y/N)</th><th>File Size(Mb)</th></tr></thead><tbody>';

						$.each(data, function(index, val) {
							var subDisplay=(val.hasSubtitles==true)?'Y':'N';

							tableHolder += '<tr><td>' + val.fileName
									+ '</td><td>' + val.parentDir + '</td><td>'
									+ subDisplay + '</td><td>'
									+ val.fileSize + '</td></tr>';

						});
						tableHolder += '</tbody></table>';
						$('#abc').append(tableHolder);
						$('#myTable').DataTable({
							scrollY: 300,
							"scrollCollapse": true,
							"scrollX": false,
							"lengthMenu": [[ 10, 25, 50, 75, 100, -1 ],[ 10, 25, 50, 75, 100, "All" ]],
							"pagingType": "full_numbers"
						});
						$('#abc').css("background-color","white");

					},

					error : function(data) {
						alert('It failed');
					}
				});
	}
	
</script>



<div class="leftpanel">
<div class="leftmenu">
	<ul>
		<li class='active'><a href='/MoviesDBatRS/moviesdb/userHome'>Home</a></li>
	</ul>
	<c:forEach var="category" items="${categories}">
		<ul>
			<li class='has-sub'><a id="Parent" href="#"><c:out
						value="${category.key}" /></a> <c:forEach var="subcategory"
					items="${category.value}">
					<ul>
						<li><a id="Child" href="#"><c:out value="${subcategory}" /></a>
					</ul>
				</c:forEach></li>
		</ul>
	</c:forEach>
</div>
</div>
<div class="middlepanel">
<div class="headerpanel">
	<h1>Welcome to RMDb</h1>
</div>
<div id="abc" class="moviepanel">
	<table id="myTable" class="display">
	</table>
</div>
</div>



