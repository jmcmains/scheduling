$('#myModalLabel<%= @project.id %>').html "<%=j render 'projects/project_title_link', project: @project %>"
$('#project_title<%= @project.id %>').text "<%= @project.name %>"

