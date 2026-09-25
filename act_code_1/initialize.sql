-- NOTE: This file is NOT covered by the repository's MIT license.
-- Original code provided by Raoni Kulesza for Big Data.
-- Included for educational/reference purposes only; all rights reserved to the author.

-- ============================================
  -- SETUP COMPLETO: loja_online
  -- Execute este bloco inteiro no SQL Editor
  -- ============================================

  DROP TABLE IF EXISTS avaliacoes, itens_pedido, pedidos, clientes, produtos, categorias CASCADE;

  CREATE TABLE categorias (
    id        SERIAL PRIMARY KEY,
    nome      TEXT NOT NULL UNIQUE,
    descricao TEXT
  );

  CREATE TABLE produtos (
    id            SERIAL PRIMARY KEY,
    nome          TEXT NOT NULL,
    preco         NUMERIC(10,2) NOT NULL,
    categoria_id  INT REFERENCES categorias(id),
    estoque       INT DEFAULT 0,
    ativo         BOOLEAN DEFAULT true
  );

  CREATE TABLE clientes (
    id        SERIAL PRIMARY KEY,
    nome      TEXT NOT NULL,
    email     TEXT UNIQUE NOT NULL,
    cidade    TEXT,
    estado    CHAR(2),
    criado_em TIMESTAMP DEFAULT now()
  );

  CREATE TABLE pedidos (
    id          SERIAL PRIMARY KEY,
    cliente_id  INT REFERENCES clientes(id),
    data_pedido TIMESTAMP DEFAULT now(),
    status      TEXT DEFAULT 'pendente',
    frete       NUMERIC(10,2) DEFAULT 0
  );

  CREATE TABLE itens_pedido (
    id             SERIAL PRIMARY KEY,
    pedido_id      INT REFERENCES pedidos(id),
    produto_id     INT REFERENCES produtos(id),
    quantidade     INT NOT NULL CHECK (quantidade > 0),
    preco_unitario NUMERIC(10,2) NOT NULL
  );

  CREATE TABLE avaliacoes (
    id              SERIAL PRIMARY KEY,
    produto_id      INT REFERENCES produtos(id),
    cliente_id      INT REFERENCES clientes(id),
    nota            INT CHECK (nota BETWEEN 1 AND 5),
    comentario      TEXT,
    data_avaliacao  TIMESTAMP DEFAULT now()
  );

  -- ==================
  -- DADOS DE EXEMPLO
  -- ==================

  INSERT INTO categorias (nome, descricao) VALUES
    ('Eletrônicos',   'Smartphones, notebooks, tablets'),
    ('Livros',        'Livros físicos e digitais'),
    ('Roupas',        'Vestuário masculino e feminino'),
    ('Casa e Jardim', 'Móveis, decoração e jardinagem'),
    ('Esportes',      'Equipamentos e acessórios esportivos');

  INSERT INTO produtos (nome, preco, categoria_id, estoque, ativo) VALUES
    ('Smartphone Galaxy S24',     4299.90,  1, 150, true),
    ('Notebook Dell Inspiron',    3899.00,  1, 80,  true),
    ('Fone Bluetooth JBL',        299.90,   1, 500, true),
    ('Clean Code (livro)',        89.90,    2, 200, true),
    ('O Senhor dos Anéis',        69.90,    2, 300, true),
    ('Camiseta Polo Ralph',       189.90,   3, 250, true),
    ('Tênis Nike Air Max',        599.90,   5, 120, true),
    ('Cadeira Gamer Thunder',     1299.00,  4, 45,  true),
    ('Kindle Paperwhite',         649.00,   1, 90,  true),
    ('Mochila Osprey 40L',        459.90,   5, 60,  false);

  INSERT INTO clientes (nome, email, cidade, estado) VALUES
    ('Ana Costa',      'ana@email.com',      'João Pessoa',   'PB'),
    ('Bruno Lima',     'bruno@email.com',    'Recife',        'PE'),
    ('Carla Souza',    'carla@email.com',    'Natal',         'RN'),
    ('Daniel Ferreira', 'daniel@email.com',  'Campina Grande', 'PB'),
    ('Elena Rocha',    'elena@email.com',    'Salvador',      'BA'),
    ('Felipe Santos',  'felipe@email.com',   'Fortaleza',     'CE'),
    ('Gabriela Dias',  'gabi@email.com',     'Maceió',        'AL'),
    ('Hugo Martins',   'hugo@email.com',     'João Pessoa',   'PB');

  INSERT INTO pedidos (cliente_id, data_pedido, status, frete) VALUES
    (1, '2025-01-10 09:30', 'entregue',  25.00),
    (1, '2025-02-14 14:20', 'entregue',  0.00),
    (2, '2025-02-20 11:00', 'enviado',   18.50),
    (3, '2025-03-01 16:45', 'pago',      32.00),
    (4, '2025-03-05 08:15', 'cancelado', 15.00),
    (5, '2025-03-10 19:00', 'entregue',  0.00),
    (2, '2025-03-15 10:30', 'pendente',  22.00),
    (1, '2025-04-01 12:00', 'entregue',  0.00),
    (6, '2025-04-10 15:30', 'pago',      28.00),
    (3, '2025-04-20 09:45', 'entregue',  12.00);

  INSERT INTO itens_pedido (pedido_id, produto_id, quantidade, preco_unitario) VALUES
    (1, 1, 1, 4299.90), (1, 3, 2, 299.90),
    (2, 4, 1, 89.90),  (2, 5, 1, 69.90),
    (3, 2, 1, 3899.00),
    (4, 7, 1, 599.90), (4, 6, 2, 189.90),
    (5, 8, 1, 1299.00),
    (6, 9, 1, 649.00), (6, 4, 3, 89.90),
    (7, 1, 1, 4299.90),
    (8, 3, 1, 299.90), (8, 7, 1, 599.90),
    (9, 2, 1, 3899.00),
    (10, 6, 1, 189.90), (10, 5, 2, 69.90);

  INSERT INTO avaliacoes (produto_id, cliente_id, nota, comentario, data_avaliacao) VALUES
    (1, 1, 5, 'Excelente! Câmera incrível.',         '2025-01-20'),
    (3, 1, 4, 'Bom som, bateria poderia durar mais.', '2025-01-22'),
    (4, 1, 5, 'Leitura obrigatória para devs.',       '2025-02-20'),
    (2, 2, 4, 'Ótimo custo-benefício.',               '2025-03-01'),
    (7, 3, 3, 'Bonito mas apertou um pouco.',         '2025-03-15'),
    (9, 5, 5, 'Melhor e-reader que já tive!',          '2025-03-20'),
    (4, 5, 4, 'Muito bom, recomendo.',                '2025-03-22'),
    (1, 2, 5, 'Top demais!',                         '2025-04-05'),
    (6, 3, 2, 'Qualidade do tecido decepcionou.',     '2025-04-22'),
    (5, 3, 5, 'Clássico absoluto.',                   '2025-04-25');

  SELECT 'categorias' AS tabela, COUNT(*) FROM categorias
  UNION ALL SELECT 'produtos',      COUNT(*) FROM produtos
  UNION ALL SELECT 'clientes',      COUNT(*) FROM clientes
  UNION ALL SELECT 'pedidos',       COUNT(*) FROM pedidos
  UNION ALL SELECT 'itens_pedido',  COUNT(*) FROM itens_pedido
  UNION ALL SELECT 'avaliacoes',    COUNT(*) FROM avaliacoes;
