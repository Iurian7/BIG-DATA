with receita_mensal as (SELECT to_char(data_pedido, 'YYYY-MM') AS mes,
SUM(quantidade * preco_unitario) AS receita from pedidos
INNER JOIN itens_pedido on itens_pedido.pedido_id = pedidos.id
where status != 'cancelado'
group by mes
)
SELECT mes, receita,
LAG(receita) OVER (ORDER BY mes) AS receita_mes_anterior,
receita - LAG(receita) OVER (ORDER BY mes) AS variacao_abs,
ROUND(100.0 * (receita - LAG(receita) OVER (ORDER BY mes))
/ NULLIF(LAG(receita) OVER (ORDER BY mes), 0), 1) AS variacao_pct
from receita_mensal
order by mes
;