select t1.object_name
from (select pizza_name as object_name, 'menu' as label
      from menu
      union all
      select name, 'person' as label
      from person
      order by label desc, object_name) as t1