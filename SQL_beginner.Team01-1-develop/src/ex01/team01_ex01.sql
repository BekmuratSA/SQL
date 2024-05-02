-- Прежде чем глубже погрузиться в эту задачу, примените приведенные ниже инструкции INSERT.

-- insert into currency values (100, 'EUR', 0.85, '2022-01-01 13:29');
-- insert into currency values (100, 'EUR', 0.79, '2022-01-08 13:29');

/*
Напишите оператор SQL, который возвращает всех пользователей и все транзакции баланса 
(в этой задаче игнорируйте валюты, для которых нет ключа в таблице Currency) с названием валюты 
и расчетным значением. валюты в долларах США на ближайшие сутки.

	- нужно найти ближайший курс валюты в прошлом (t1)
	- если t1 пуст (означает отсутствие каких-либо ставок в прошлом), то найдите ближайший курс_к_долларам валюты в будущем (t2)
	- используйте курс t1 ИЛИ t2 для расчета валюты в формате USD

Пожалуйста, взгляните на образец выходных данных ниже. Отсортируйте результат по имени пользователя в порядке убывания, 
а затем по фамилии пользователя и названию валюты в порядке возрастания.
*/

with user_balance as (
	-- объединение пользователей и баланса
	select case when u.name is NULL then 'not defined' else u.name end as name, 
		case when u.lastname is NULL then 'not defined' else u.lastname end as lastname,
		b.currency_id,
		b.updated, money
	from public.user u full outer join balance b on u.id = b.user_id
	)

select t1_t2.name, lastname, c2.name as currency_name,
	money * c2.rate_to_usd as currency_in_usd
from (
	-- выводит user_balance с добавлением актальной даты обновления валют
	select ub.name, lastname, currency_id,
		money, ub.updated,
		coalesce(
			(select max(updated) from currency c where ub.currency_id = c.id and ub.updated > c.updated),
			(select min(updated) from currency c where ub.currency_id = c.id and ub.updated < c.updated)
			) as cur_updated
	from user_balance ub
) t1_t2 
	inner join currency c2 on t1_t2.cur_updated = c2.updated and t1_t2.currency_id = c2.id

order by 1 desc, 2, 3;

/*
"Иван"	"Иванов"	"EUR"	150.10
"Иван"	"Иванов"	"EUR"	17.00
"Иван"	"Иванов"	"EUR"	158.00
"not defined"	"not defined"	"JPY"	0.9480
"not defined"	"not defined"	"USD"	120
"not defined"	"Сидоров"	"EUR"	39.50
"not defined"	"Сидоров"	"JPY"	3.9500
"not defined"	"Сидоров"	"USD"	500
*/