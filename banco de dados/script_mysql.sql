CREATE DATABASE IF NOT EXISTS delivery_italiano
CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE delivery_italiano;

CREATE TABLE IF NOT EXISTS categorias (
    id_categoria INT AUTO_INCREMENT PRIMARY KEY,
    nome         VARCHAR(40) NOT NULL
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS usuarios (
id_usuario INT AUTO_INCREMENT PRIMARY KEY,
nome VARCHAR(50) NOT NULL,
sobrenome VARCHAR(80) NOT NULL,
email VARCHAR(100) NOT NULL UNIQUE,
senha_hash VARCHAR(255) NOT NULL,
cpf CHAR(11)  NOT NULL,
telefone VARCHAR(11) NOT NULL,
criado_em  DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS produtos (
id_produto INT AUTO_INCREMENT PRIMARY KEY,
id_categoria INT NOT NULL,
nome VARCHAR(60) NOT NULL,
descricao VARCHAR(255),
preco DECIMAL(8,2) NOT NULL,
imagem_url VARCHAR(255),
ativo  TINYINT(1)   NOT NULL DEFAULT 1,
FOREIGN KEY (id_categoria) REFERENCES categorias(id_categoria)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS enderecos (
id_endereco INT AUTO_INCREMENT PRIMARY KEY,
id_usuario INT NOT NULL,
apelido VARCHAR(30) NOT NULL,
cep VARCHAR(9) NOT NULL,
rua  VARCHAR(100) NOT NULL,
numero VARCHAR(10)  NOT NULL,
complemento VARCHAR(50),
bairro VARCHAR(60)  NOT NULL,
cidade  VARCHAR(60)  NOT NULL,
uf  CHAR(2) NOT NULL,
referencia  VARCHAR(100),
frete DECIMAL(8,2) NOT NULL DEFAULT 0.00,
FOREIGN KEY (id_usuario) REFERENCES usuarios(id_usuario) ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS pedidos (
id_pedido INT AUTO_INCREMENT PRIMARY KEY,
id_usuario INT NOT NULL,
id_endereco INT NOT NULL,
forma_pagamento ENUM('pix','cartao','pagar_na_entrega') NOT NULL,
status ENUM('recebido','em_preparo','saiu_para_entrega','entregue','cancelado')
NOT NULL DEFAULT 'recebido',
subtotal   DECIMAL(8,2) NOT NULL,
frete DECIMAL(8,2) NOT NULL,
total DECIMAL(8,2) NOT NULL,
criado_em  DATETIME  NOT NULL DEFAULT CURRENT_TIMESTAMP,
FOREIGN KEY (id_usuario) REFERENCES usuarios(id_usuario),
FOREIGN KEY (id_endereco) REFERENCES enderecos(id_endereco)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS cartoes (
id_cartao  INT AUTO_INCREMENT PRIMARY KEY,
id_usuario  INT NOT NULL,
bandeira VARCHAR(20) NOT NULL,
ultimos4 CHAR(4)  NOT NULL,
nome_titular VARCHAR(80) NOT NULL,
validade CHAR(5) NOT NULL,
FOREIGN KEY (id_usuario) REFERENCES usuarios(id_usuario) ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS itens_pedido (
id_pedido INT NOT NULL,
id_produto INT NOT NULL,
quantidade INT NOT NULL,
preco_unitario DECIMAL(8,2) NOT NULL,
PRIMARY KEY (id_pedido, id_produto),
FOREIGN KEY (id_pedido)  REFERENCES pedidos(id_pedido) ON DELETE CASCADE,
FOREIGN KEY (id_produto) REFERENCES produtos(id_produto)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS carrinho_itens (
id_usuario INT NOT NULL,
id_produto INT NOT NULL,
quantidade INT NOT NULL,
PRIMARY KEY (id_usuario, id_produto),
FOREIGN KEY (id_usuario) REFERENCES usuarios(id_usuario) ON DELETE CASCADE,
FOREIGN KEY (id_produto) REFERENCES produtos(id_produto) ON DELETE CASCADE
) ENGINE=InnoDB;

INSERT INTO categorias (id_categoria, nome) VALUES
(1, 'Pizzas'),
(2, 'Massas'),
(3, 'Bebidas'),
(4, 'Sobremesas')
ON DUPLICATE KEY UPDATE nome = novo.nome;

INSERT INTO produtos (id_produto, id_categoria, nome, descricao, preco, imagem_url, ativo) VALUES
(1,  1, 'Pizza de Frango com Catupiry', 'Massa artesanal de fermentação natural, molho de tomate italiano, frango desfiado temperado com ervas finas, coberto com Catupiry e azeitonas pretas.', 75.00, 'pizza-catupiry3.png', 1),
(2,  2, 'Macarrão', 'Massa fresca tipo fettuccine com molho sugo de tomates San Marzano, manjericão fresco, azeite extra virgem e queijo parmesão.', 55.00, 'macarrão2.png', 1),
(3,  2, 'Risoto', 'Risoto de arroz arbório cremoso com cogumelos frescos, manteiga de emulsão, caldo artesanal de vegetais e toque de azeite trufado.', 85.00, 'risoto-1.png', 1),
(4,  2, 'Lasanha', 'Camadas de massa fresca artesanal, molho bolonhesa, molho bechamel e muçarela gratinada ao forno.', 45.00, 'lasanha-1.png', 1),
(5,  1, 'Pizza de Pepperoni', 'Massa crocante, molho de tomate rústico, muçarela derretida, fatias de pepperoni especial e orégano fresco.', 70.00, 'pizza-pepperoni-1.png', 1),
(6,  2, 'Gnocchi', 'Nhoque artesanal de batata com molho pomodoro, manjericão e lascas de queijo parmesão.', 50.00, 'gnocchi-1.png', 1),
(7,  3, 'Água com gás', 'Água mineral natural gaseificada garrafa 500ml.', 4.50, 'agua-3.png', 1),
(8,  3, 'Vinho Barbera', 'Vinho tinto italiano Barbera d’Asti de acidez harmoniosa e notas de frutas vermelhas.', 120.00, 'vinho-barbera-2.png', 1),
(9,  3, 'Refrigerante Zero', 'Lata 350ml bem gelada, zero açúcares.', 6.50, 'coca-2.png', 1),
(10, 3, 'Suco natural de maracujá', 'Suco feito com a polpa natural da fruta no momento do pedido. Copo 400ml.', 5.69, 'sucu-1.png', 1),
(11, 4, 'Gelato de Pistache', 'Gelato artesanal italiano elaborado com pistaches selecionados da Sicília.', 13.50, 'pistache-1.png', 1),
(12, 4, 'Tiramisù', 'Clássica sobremesa italiana com biscoitos champagne embebidos em café espresso, creme mascarpone e cacau em pó.', 55.61, 'tiramisu-1.png', 1),
(13, 4, 'Maritozzo', 'Pão doce tradicional de Roma recheado com chantilly leve e açúcar de confeiteiro.', 20.42, 'maritozzo-1.png', 1),
(14, 4, 'Gelato de Morango', 'Gelato cremoso preparado com morangos frescos e selecionados, sem corantes artificiais.', 14.67, 'morango-1.png', 1)
ON DUPLICATE KEY UPDATE
id_categoria = novo.id_categoria,
nome = novo.nome,
descricao = novo.descricao,
preco = novo.preco,
imagem_url = novo.imagem_url,
ativo = novo.ativo;

