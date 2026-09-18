SELECT categorias.nome AS categoria, produtos.nome AS produto, preco,
ROW_NUMBER() OVER (PARTITION BY categorias.id ORDER BY preco DESC) AS posicao
from produtos
INNER JOIN categorias on categorias.id = produtos.categoria_id
order by categoria, posicao
;